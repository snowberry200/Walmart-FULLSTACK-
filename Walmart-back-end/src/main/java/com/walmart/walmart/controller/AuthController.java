package com.walmart.walmart.controller;

import com.walmart.walmart.requestDTO.AuthRequestDTO;
import com.walmart.walmart.responseDTO.AuthResponseDTO;
import com.walmart.walmart.service.AuthServiceImp;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
@CrossOrigin(origins = "*")   // Enable CORS
public class AuthController {
    AuthServiceImp authServiceImp;

    public AuthController(AuthServiceImp authServiceImp) {
        this.authServiceImp = authServiceImp;
    }

    @PostMapping("/register")
    public ResponseEntity<AuthResponseDTO> signUp (@RequestBody AuthRequestDTO authRequestDTO){
        try {
            AuthResponseDTO authResponseDTO = authServiceImp.signup(authRequestDTO);
            return ResponseEntity.status(HttpStatus.CREATED).body(authResponseDTO);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    //check if email exists
    @PostMapping("/check-email")
    public ResponseEntity<AuthResponseDTO> checkEmail(@RequestBody AuthRequestDTO request) {
        try {
            AuthResponseDTO authResponseDTO = authServiceImp.checkIfEmailExists(request);
            return ResponseEntity.ok(authResponseDTO);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    // logging in
    @PostMapping("/login")
    public ResponseEntity<AuthResponseDTO> signIn(@RequestBody AuthRequestDTO authRequestDTO) {
        AuthResponseDTO authResponseDTO = authServiceImp.signin(authRequestDTO);

        // Check if login was successful
        if (authResponseDTO.getAccessToken() != null && !authResponseDTO.getAccessToken().isEmpty()) {
            return ResponseEntity.ok(authResponseDTO);
        } else {
            //  Return 401 for failed login
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(authResponseDTO);
        }
    }

}
