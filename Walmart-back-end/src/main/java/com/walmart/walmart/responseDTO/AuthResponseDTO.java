package com.walmart.walmart.responseDTO;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonProperty;
import java.time.LocalDateTime;

@JsonInclude(JsonInclude.Include.NON_NULL)
public class AuthResponseDTO {
    @JsonProperty("user")
    private UserDTO userDTO;

    @JsonProperty("accessToken")
    private String accessToken;

    @JsonProperty("message")
    private String message;

    @JsonProperty("isActive")
    private boolean isActive;

    @JsonProperty("createdAt")
    private LocalDateTime createdAt;

    @JsonProperty("requiresVerification")
    private boolean requiresVerification;

    @JsonProperty("verificationToken")
    private String verificationToken;

    @JsonProperty("emailExists")
    private boolean emailExists;

    public AuthResponseDTO() {
        // Default constructor
    }

    // For Sign In
    public static AuthResponseDTO forSignIn(String verificationToken, boolean requiresVerification,
                                            String message, String accessToken, UserDTO userDTO) {
        AuthResponseDTO authResponseDTO = new AuthResponseDTO();
        authResponseDTO.userDTO = userDTO;
        authResponseDTO.accessToken = accessToken;
        authResponseDTO.verificationToken = verificationToken;
        authResponseDTO.requiresVerification = requiresVerification;
        authResponseDTO.message = message;
        authResponseDTO.isActive = userDTO != null && userDTO.isActive();
        authResponseDTO.emailExists = userDTO != null;
        authResponseDTO.createdAt = LocalDateTime.now();
        return authResponseDTO;
    }

    // For Sign Up
    public static AuthResponseDTO forSignUp(String verificationToken, boolean requiresVerification,
                                            String message, String accessToken, UserDTO userDTO) {
        AuthResponseDTO authResponseDTO = new AuthResponseDTO();
        authResponseDTO.userDTO = userDTO;
        authResponseDTO.accessToken = accessToken;
        authResponseDTO.verificationToken = verificationToken;
        authResponseDTO.requiresVerification = requiresVerification;
        authResponseDTO.message = message;
        authResponseDTO.isActive = true;
        authResponseDTO.emailExists = true;
        authResponseDTO.createdAt = LocalDateTime.now();
        return authResponseDTO;
    }

    // ✅ FIXED: For Email Check - Now properly sets active on UserDTO
    public static AuthResponseDTO forEmailCheck(boolean exists, String email, String message, boolean isActive, UserDTO userDTO) {
        AuthResponseDTO authResponseDTO = new AuthResponseDTO();
        authResponseDTO.emailExists = exists;
        authResponseDTO.message = message;
        authResponseDTO.isActive = isActive;
        authResponseDTO.requiresVerification = false;
        authResponseDTO.accessToken = null;
        authResponseDTO.userDTO = userDTO;  // ✅ Use the provided UserDTO

        // If userDTO is null but exists is true, create a minimal one
        if (exists && userDTO == null) {
            UserDTO minimalUser = new UserDTO();
            minimalUser.setEmail(email);
            minimalUser.setActive(isActive);  // ✅ IMPORTANT: Set active status
            authResponseDTO.userDTO = minimalUser;
        }

        return authResponseDTO;
    }

    // Getters and Setters
    public UserDTO getUserDTO() {
        return userDTO;
    }

    public void setUserDTO(UserDTO userDTO) {
        this.userDTO = userDTO;
    }

    public String getAccessToken() {
        return accessToken;
    }

    public void setAccessToken(String accessToken) {
        this.accessToken = accessToken;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public boolean isRequiresVerification() {
        return requiresVerification;
    }

    public void setRequiresVerification(boolean requiresVerification) {
        this.requiresVerification = requiresVerification;
    }

    public String getVerificationToken() {
        return verificationToken;
    }

    public void setVerificationToken(String verificationToken) {
        this.verificationToken = verificationToken;
    }

    public boolean isEmailExists() {
        return emailExists;
    }

    public void setEmailExists(boolean emailExists) {
        this.emailExists = emailExists;
    }
}