// Create: com.walmart.walmart.repository.RoleRepository.java
package com.walmart.walmart.repository;

import com.walmart.walmart.entity.Role;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface RoleRepository extends JpaRepository<Role, Long> {
    Optional<Role> findByName(String name);
}