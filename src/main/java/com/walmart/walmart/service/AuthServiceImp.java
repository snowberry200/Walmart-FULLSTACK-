package com.walmart.walmart.service;

import com.walmart.walmart.entity.Role;
import com.walmart.walmart.entity.Users;
import com.walmart.walmart.repository.AuthRepository;
import com.walmart.walmart.repository.RoleRepository;
import com.walmart.walmart.requestDTO.AuthRequestDTO;
import com.walmart.walmart.responseDTO.AuthResponseDTO;
import com.walmart.walmart.responseDTO.UserDTO;
import com.walmart.walmart.service.jwtUtils.JwtTokenProvider;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.time.LocalDateTime;

@Service
public class AuthServiceImp implements AuthService {
    private static final Logger logger = LoggerFactory.getLogger(AuthServiceImp.class);

    private final PasswordEncoder passwordEncoder;
    private final AuthRepository authRepository;
    private final RoleRepository roleRepository;
    private final JwtTokenProvider jwtTokenProvider;

    public AuthServiceImp(PasswordEncoder passwordEncoder, AuthRepository authRepository,
                          RoleRepository roleRepository, JwtTokenProvider jwtTokenProvider) {
        this.passwordEncoder = passwordEncoder;
        this.authRepository = authRepository;
        this.roleRepository = roleRepository;
        this.jwtTokenProvider = jwtTokenProvider;
    }

    @Override
    public AuthResponseDTO signup(AuthRequestDTO authRequestDTO) {
        logger.info("Signup attempt for email: {}", authRequestDTO.getEmail());
        try {
            // 1. Check if email exists
            String email = authRequestDTO.getEmail();
            if (authRepository.existsByEmail(email)) {
                logger.warn("Signup failed - email already exists: {}", email);
                throw new RuntimeException("This email address already exists");
            }

            // 2. Hash password
            String hashedPass = passwordEncoder.encode(authRequestDTO.getPassword());
            logger.debug("Password encoded for user: {}", email);

            // 3. Create new user
            Users newUser = Users.createNewUser(
                    authRequestDTO.getName(),
                    authRequestDTO.getEmail(),
                    hashedPass
            );

            // 4. Get or create role
            Role userRole = roleRepository.findByName("USER")
                    .orElseGet(() -> {
                        logger.info("Creating default USER role");
                        Role newRole = Role.createNewRole("USER");
                        return roleRepository.save(newRole);
                    });

            // 5. Assign role and set active
            newUser.addRole(userRole);
            newUser.setActive(true);
            newUser.setCreatedAt(LocalDateTime.now());

            // 6. Save user
            Users savedUser = authRepository.save(newUser);
            logger.info("User saved successfully with ID: {}", savedUser.getId());

            // 7. Create UserDTO
            UserDTO userDTO = UserDTO.createUserDTO(savedUser);

            // 8. Generate JWT token
            String accessToken = jwtTokenProvider.createToken(savedUser);
            logger.debug("JWT token generated for user: {}", email);

            // 9. Create personalized success message
            String message = savedUser.getName() + " was successfully registered";

            // 10. Return response
            return AuthResponseDTO.forSignUp(
                    "",                    // verificationToken
                    false,                 // requiresVerification
                    message,               // personalized message
                    accessToken,
                    userDTO                // user DTO
            );

        } catch (Exception e) {
            logger.error("Signup failed: {}", e.getMessage(), e);
            throw new RuntimeException("Signup failed: " + e.getMessage(), e);
        }
    }

    @Override
    public AuthResponseDTO signin(AuthRequestDTO authRequestDTO) {
        String email = authRequestDTO.getEmail();
        String password = authRequestDTO.getPassword();

        logger.info("Login attempt for email: {}", email);

        try {
            // Find user by email
            Users user = authRepository.findByEmail(email)
                    .orElseThrow(() -> {
                        logger.warn("Login failed - user not found: {}", email);
                        return new RuntimeException("Invalid credentials");
                    });

            logger.debug("User found: ID={}, active={}", user.getId(), user.isActive());

            // Check if user is active
            if (!user.isActive()) {
                logger.warn("Login failed - inactive account: {}", email);
                throw new RuntimeException("Account is inactive");
            }

            // Verify password
            if (!passwordEncoder.matches(password, user.getPassword())) {
                logger.warn("Login failed - invalid password for: {}", email);
                throw new RuntimeException("Invalid credentials");
            }

            logger.info("Password verified successfully for: {}", email);

            // Generate token
            String accessToken = jwtTokenProvider.createToken(user);
            logger.debug("JWT token generated for: {}", email);

            // Create UserDTO
            UserDTO dto = UserDTO.createUserDTO(user);

            // Update last login
            user.setLastLogin(LocalDateTime.now());
            authRepository.save(user);
            logger.info("Last login updated for user: {}", email);

            // Return success response
            return AuthResponseDTO.forSignIn(
                    "",     // verificationToken
                    false,  // requiresVerification
                    "Welcome to Walmart",
                    accessToken,
                    dto
            );

        } catch (RuntimeException e) {
            logger.error("Login failed for {}: {}", email, e.getMessage());
            // Re-throw with specific message based on error
            if (e.getMessage().contains("inactive")) {
                throw new RuntimeException("Account is inactive. Please contact support.");
            }
            throw new RuntimeException("Invalid email or password");
        }
    }

}