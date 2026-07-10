package com.walmart.walmart.service.jwtUtils;

import com.walmart.walmart.entity.Users;

import java.security.Key;

public interface JwtTokenProvider {
    // signing Key
    Key getSigningKey();
    // generate token
    String createToken(Users user);
    // validate token
    boolean validateToken(String token);
    // extract email method
    String extractEmailFromToken( String token);
    // extract userId from token
    Long extractUserId (String token);
    //Extract role from token
     String extractRoleFromToken(String token);


}
