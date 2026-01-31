package com.walmart.walmart.security;

import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;

public interface SecurityConfiguration {
    PasswordEncoder getPasswordEncoded();
    SecurityFilterChain securityFilterChain(HttpSecurity httpSecurity);
}
