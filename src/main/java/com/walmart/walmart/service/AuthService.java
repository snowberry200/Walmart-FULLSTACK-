package com.walmart.walmart.service;

import com.walmart.walmart.requestDTO.AuthRequestDTO;
import com.walmart.walmart.responseDTO.AuthResponseDTO;

public interface AuthService {
    AuthResponseDTO signup (AuthRequestDTO authRequestDTO);
    AuthResponseDTO signin (AuthRequestDTO authRequestDTO);
}
