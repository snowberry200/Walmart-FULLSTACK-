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

import java.time.LocalDateTime;

@Service
public class AuthServiceImp implements AuthService {
    PasswordEncoder passwordEncoder;
    AuthRepository authRepository;
    RoleRepository roleRepository;
    JwtTokenProvider jwtTokenProvider;

    public AuthServiceImp(PasswordEncoder passwordEncoder, AuthRepository authRepository, RoleRepository roleRepository, JwtTokenProvider jwtTokenProvider) {
        this.passwordEncoder = passwordEncoder;
        this.authRepository = authRepository;
        this.roleRepository = roleRepository;
        this.jwtTokenProvider = jwtTokenProvider;
    }

    @Override
    public AuthResponseDTO signup(AuthRequestDTO authRequestDTO) {
        try {
            // 1. Check if email exists
            String email = authRequestDTO.getEmail();
            if (authRepository.existsByEmail(email)) {
                throw new RuntimeException("This email address already exists");
            }

            // 2. Hash password
            String hashedPass = passwordEncoder.encode(authRequestDTO.getPassword());

            // 3. Create new user
            Users newUser = Users.createNewUser(
                    authRequestDTO.getName(),
                    authRequestDTO.getEmail(),
                    hashedPass
            );

            // 4. Get or create role
            Role userRole = roleRepository.findByName("USER")
                    .orElseGet(() -> {
                        Role newRole = Role.createNewRole("USER");
                        return roleRepository.save(newRole);
                    });

            // 5. Assign role and set active
            newUser.addRole(userRole);
            newUser.setActive(true);
            newUser.setCreatedAt(LocalDateTime.now());

            // 6. Save user
            Users savedUser = authRepository.save(newUser);

            // 7. Create UserDTO (should include isActive field)
            UserDTO userDTO = UserDTO.createUserDTO(savedUser);

            // 8. Generate JWT token
            String accessToken = jwtTokenProvider.createToken(savedUser);

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
            throw new RuntimeException("Signup failed: " + e.getMessage(), e);
        }
    }

    @Override
    public AuthResponseDTO signin(AuthRequestDTO authRequestDTO) {
        String email = authRequestDTO.getEmail();
        String password = authRequestDTO.getPassword();
        //a. find email
        try {
            Users user = authRepository.findByEmail(email).orElseThrow(()-> new RuntimeException("invalid credentials"));
            //b. verify passwords
            if (!passwordEncoder.matches(password, user.getPassword())) {

                throw new RuntimeException("invalid credentials");
            }
            //c. verificationToken
            String verificationToken = "";
            //d. requiresVerification
            boolean requiresVerification = false;
            //e.message
            String message = "Welcome to Walmart";
            //f. isActive
            boolean isActive = user.isActive();
            //g. accessToken
            String accessToken =jwtTokenProvider.createToken(user);
            //h. create UserDto
            UserDTO dto = UserDTO.createUserDTO(user);


            return AuthResponseDTO.forSignIn(verificationToken,requiresVerification,message,accessToken,dto);
        } catch (RuntimeException e) {
            throw new RuntimeException("login failed");
        }
    }


}