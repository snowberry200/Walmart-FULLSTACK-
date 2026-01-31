package com.walmart.walmart.controller;

import com.walmart.walmart.requestDTO.AuthRequestDTO;
import com.walmart.walmart.responseDTO.AuthResponseDTO;
import com.walmart.walmart.service.AuthServiceImp;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")  //
@CrossOrigin(origins = "*")   // Enable CORS
public class AuthController {
    AuthServiceImp authServiceImp;

    public AuthController(AuthServiceImp authServiceImp) {
        this.authServiceImp = authServiceImp;
    }

    @PostMapping("/register")
    public ResponseEntity<AuthResponseDTO> signup (@RequestBody AuthRequestDTO authRequestDTO){
        try {
            AuthResponseDTO authResponseDTO = authServiceImp.signup(authRequestDTO);
            return ResponseEntity.status(HttpStatus.CREATED).body(authResponseDTO);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }


    @PostMapping("/login")
    public ResponseEntity<AuthResponseDTO> signin(@RequestBody AuthRequestDTO authRequestDTO){
        AuthResponseDTO authResponseDTO = authServiceImp.signin(authRequestDTO);
        return ResponseEntity.ok(authResponseDTO);
    }

}
