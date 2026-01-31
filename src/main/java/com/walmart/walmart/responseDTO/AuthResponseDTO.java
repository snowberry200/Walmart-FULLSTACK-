package com.walmart.walmart.responseDTO;

import java.time.LocalDateTime;

public class AuthResponseDTO{
     private  UserDTO user;
    private String accessToken;
    private String message;
    private boolean isActive;
    private LocalDateTime createdAt;
    private boolean requiresVerification;
    private String verificationToken;

    public AuthResponseDTO(){}

    public static AuthResponseDTO forSignIn (String verificationToken, boolean requiresVerification, String message,String accessToken, UserDTO user){
        AuthResponseDTO authResponseDTO = new AuthResponseDTO();
        authResponseDTO.user = user;
        authResponseDTO.accessToken = accessToken;
        authResponseDTO.verificationToken = verificationToken;
        authResponseDTO.requiresVerification = requiresVerification;
        authResponseDTO.message = message;
        authResponseDTO.isActive = true;
        return authResponseDTO;

    }


    public static AuthResponseDTO forSignUp (String verificationToken, boolean requiresVerification, String message, String accessToken, UserDTO user){
        AuthResponseDTO authResponseDTO = new AuthResponseDTO();
        authResponseDTO.accessToken = accessToken;
        authResponseDTO.isActive = true;
        authResponseDTO.verificationToken = verificationToken;
        authResponseDTO.requiresVerification = requiresVerification;
        authResponseDTO.message = message;
        authResponseDTO.user= user;
        authResponseDTO.createdAt = LocalDateTime.now();
        return authResponseDTO;
    }



    public boolean isActive() {
        return isActive;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public UserDTO getUser() {
        return user;
    }

    public String getVerificationToken() {
        return verificationToken;
    }

    public boolean isRequiresVerification() {
        return requiresVerification;
    }

    public String getMessage() {
        return message;
    }

    public String getAccessToken() {
        return accessToken;
    }
}

