package com.walmart.walmart.responseDTO;

import com.walmart.walmart.entity.Users;

import javax.management.relation.Role;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Collection;

public class UserDTO {
    private Long id;
    private String name;
    private String email;
    private int age;
    private Collection<Role> roles = new ArrayList<>();
    private boolean isActive;
    private LocalDateTime createdAt;
    private boolean requiresVerification;
    private String verificationToken;

    public UserDTO(){}


    public UserDTO(Long id, String name, int age, Collection<Role> roles, String email, String verificationToken, boolean requiresVerification, LocalDateTime createdAt, boolean isActive) {
        this.id = id;
        this.name = name;
        this.age = age;
        this.roles = roles;
        this.email = email;
        this.verificationToken = verificationToken;
        this.requiresVerification = requiresVerification;
        this.createdAt = createdAt;
        this.isActive = isActive;
    }

    public static UserDTO createUserDTO (Users user){
        UserDTO dto = new UserDTO();
        dto.id = user.getId();
        dto.name = user.getName();
        dto.email = user.getEmail();
        dto.isActive = user.isActive();
        dto.createdAt = user.getCreatedAt();
        return dto;

    }


    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public int getAge() {
        return age;
    }

    public void setAge(int age) {
        this.age = age;
    }

    public Collection<Role> getRoles() {
        return roles;
    }

    public void setRoles(Collection<Role> roles) {
        this.roles = roles;
    }
    public String getVerificationToken() {
        return verificationToken;
    }

    public void setVerificationToken(String verificationToken) {
        this.verificationToken = verificationToken;
    }

    public boolean isRequiresVerification() {
        return requiresVerification;
    }

    public void setRequiresVerification(boolean requiresVerification) {
        this.requiresVerification = requiresVerification;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
    }

}
