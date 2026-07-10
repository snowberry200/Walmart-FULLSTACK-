package com.walmart.walmart.service.jwtUtils;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.Collections;
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
            String token = getJwtFromRequest(request);

            if (StringUtils.hasText(token) && jwtTokenProviderImp.validateToken(token)) {
                String email = jwtTokenProviderImp.extractEmailFromToken(token);
                String role = jwtTokenProviderImp.extractRoleFromToken(token);

                System.out.println("DEBUG: Authenticating user - Email: " + email + ", Role: " + role);

                if (email != null) {
                    List<SimpleGrantedAuthority> authorities = Collections.singletonList(
                            new SimpleGrantedAuthority("ROLE_" + role.toUpperCase())
                    );

                    UsernamePasswordAuthenticationToken authentication =
                            new UsernamePasswordAuthenticationToken(
                                    email,
                                    null,
                                    authorities
                            );

                    SecurityContextHolder.getContext().setAuthentication(authentication);
                    System.out.println("DEBUG: Authentication set successfully");
                }
            } else if (token != null) {
                System.out.println("DEBUG: Invalid token received");
            } else {
                System.out.println("DEBUG: No token in request to " + request.getRequestURI());
            }
        } catch (Exception e) {
            System.err.println("ERROR in JWT filter: " + e.getMessage());
            e.printStackTrace();
        }

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