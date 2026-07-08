package com.walmart.walmart.security;

import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.web.cors.CorsConfigurationSource;

public interface SecurityConfiguration {
    PasswordEncoder passwordEncoder();
    SecurityFilterChain securityFilterChain(HttpSecurity httpSecurity);
    CorsConfigurationSource corsConfigurationSource();
}
