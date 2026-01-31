package com.walmart.walmart.service.jwtUtils;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.List;

@Component
public class JwtAuthenticationFilter extends OncePerRequestFilter {

    private final JwtTokenProviderImp jwtTokenProviderImp;

    // Constructor injection
    public JwtAuthenticationFilter(JwtTokenProviderImp jwtTokenProviderImp) {
        this.jwtTokenProviderImp = jwtTokenProviderImp;
    }

    @Override
    protected void doFilterInternal(HttpServletRequest request,
                                    HttpServletResponse response,
                                    FilterChain filterChain)
            throws ServletException, IOException {

        try {
            // 1. Extract JWT token from request
            String token = getJwtFromRequest(request);

            // 2. Validate token
            if (token != null && jwtTokenProviderImp.validateToken(token)) {

                // 3. Extract user info from token
                String email = jwtTokenProviderImp.extractEmailFromToken(token);
                String role = extractRoleFromToken(token); // You need to add this method

                // 4. Create authentication object
                UsernamePasswordAuthenticationToken authentication =
                        new UsernamePasswordAuthenticationToken(
                                email,           // Principal (email)
                                null,            // Credentials (none for JWT)
                                getAuthorities(role) // Convert role to authorities
                        );

                // 5. Set authentication in SecurityContext
                SecurityContextHolder.getContext().setAuthentication(authentication);
            }
        } catch (Exception e) {
            // Log error but don't stop the filter chain
            logger.error("Cannot set user authentication", e);
        }

        // 6. Continue with the filter chain
        filterChain.doFilter(request, response);
    }

    // Extract JWT token from Authorization header
    private String getJwtFromRequest(HttpServletRequest request) {
        String bearerToken = request.getHeader("Authorization");
        if (bearerToken != null && bearerToken.startsWith("Bearer ")) {
            return bearerToken.substring(7); // Remove "Bearer " prefix
        }
        return null;
    }

    // Convert role to Spring Security authorities
    private List<SimpleGrantedAuthority> getAuthorities(String role) {
        // You might have multiple roles or permissions
        // For now, just convert single role to authority
        return List.of(new SimpleGrantedAuthority("ROLE_" + role));
    }

    // Extract role from token (add this to JwtTokenProvider or extract here)
    private String extractRoleFromToken(String token) {
        try {
            return jwtTokenProviderImp.extractRoleFromToken(token);  // Just pass token
        } catch (Exception e) {
            return "USER"; // Default role
        }
    }
}