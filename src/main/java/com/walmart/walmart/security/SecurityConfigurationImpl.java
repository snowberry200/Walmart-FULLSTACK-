package com.walmart.walmart.security;

import com.walmart.walmart.service.jwtUtils.JwtAuthenticationFilter;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

import java.util.List;

@Configuration
@EnableWebSecurity
public class SecurityConfigurationImpl {
    private final JwtAuthenticationFilter jwtAuthFilter;

    public SecurityConfigurationImpl(JwtAuthenticationFilter jwtAuthFilter) {
        this.jwtAuthFilter = jwtAuthFilter;
    }

    @Bean
    public PasswordEncoder getPasswordEncoded() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity httpSecurity) {
        try {
            return httpSecurity
                    .cors(cors -> cors.configurationSource(corsConfigurationSource()))
                    .csrf(AbstractHttpConfigurer::disable)
                    .authorizeHttpRequests(auth -> auth
                            // Public endpoints
                            .requestMatchers(
                                    "/api/auth/**",          // Auth API
                                    "/error",                // Error handling
                                    "/favicon.ico",          // Favicon
                                    "/",                     // Root - serves Flutter app
                                    "/index.html",           // Flutter index
                                    "/static/**",            // Static resources
                                    "/assets/**",            // Flutter assets
                                    "/main.dart.js",         // Flutter main JS
                                    "/flutter_service_worker.js",  // Flutter service worker
                                    "/manifest.json",        // Web manifest
                                    "/icons/**",             // Icons
                                    "/*.js",                 // All JS files
                                    "/*.css",                // All CSS files
                                    "/*.png",                // All PNG images
                                    "/*.jpg",                // All JPG images
                                    "/swagger-ui/**",        // Swagger UI
                                    "/v3/api-docs/**"        // OpenAPI docs
                            ).permitAll()
                            // API endpoints require authentication
                            .requestMatchers("/api/**").authenticated()
                            // Everything else (Flutter routes) should be accessible
                            .anyRequest().permitAll()
                    )
                    .sessionManagement(session -> session
                            .sessionCreationPolicy(SessionCreationPolicy.STATELESS)
                    )
                    .exceptionHandling(exception -> exception
                            .authenticationEntryPoint((request, response, authException) -> {
                                // Only return 401 for API calls, not for Flutter routes
                                if (request.getRequestURI().startsWith("/api/")) {
                                    response.setContentType("application/json");
                                    response.setStatus(401);
                                    response.getWriter().write(
                                            "{\"error\": \"Unauthorized\", \"message\": \"Authentication required\"}"
                                    );
                                } else {
                                    // For non-API routes, let it through (Flutter will handle)
                                    response.setStatus(200);
                                    // Serve index.html for Flutter routing
                                    request.getRequestDispatcher("/").forward(request, response);
                                }
                            })
                    )
                    .addFilterBefore(jwtAuthFilter, UsernamePasswordAuthenticationFilter.class)
                    .build();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    @Bean
    public CorsConfigurationSource corsConfigurationSource() {
        CorsConfiguration configuration = new CorsConfiguration();
        configuration.setAllowedOrigins(List.of(
                "http://localhost:3000",
                "http://localhost:8080",
                "http://localhost:5555",  // Flutter web default
                "http://localhost"        // Flutter web
        ));
        configuration.setAllowedMethods(List.of(
                "GET", "POST", "PUT", "DELETE", "PATCH", "OPTIONS", "HEAD"
        ));
        configuration.setAllowedHeaders(List.of(
                "Authorization",
                "Content-Type",
                "Accept",
                "Origin",
                "X-Requested-With",
                "Access-Control-Request-Method",
                "Access-Control-Request-Headers"
        ));
        configuration.setExposedHeaders(List.of(
                "Authorization",
                "Content-Type",
                "Content-Length"
        ));
        configuration.setAllowCredentials(true);
        configuration.setMaxAge(3600L);

        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", configuration);  // Apply to ALL endpoints
        return source;
    }


}
