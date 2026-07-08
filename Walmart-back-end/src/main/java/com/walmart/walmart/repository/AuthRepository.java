package com.walmart.walmart.repository;

import com.walmart.walmart.entity.Users;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface AuthRepository extends JpaRepository<Users,Long> {
    // Find user by email (for login)
    Optional<Users> findByEmail(String email);

    // Check if email exists (for signup validation)
    boolean existsByEmail(String email);

}
