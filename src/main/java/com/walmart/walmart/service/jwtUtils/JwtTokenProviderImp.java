package com.walmart.walmart.service.jwtUtils;

import com.walmart.walmart.entity.Users;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.security.Keys;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.security.Key;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

@Component
public class JwtTokenProviderImp implements JwtTokenProvider {
    @Value("${jwt.secret:yourSuperSecretKeyThatIsAtLeast32CharactersLong}")
    private String jwtSecret;

    @Value("${jwt.expiration:86400000}") // 24 hours in milliseconds
    private long jwtExpiration;


    public JwtTokenProviderImp() {}

    //overall process
    //1. signingKey
    //2. generate token
    //3. validate token
    //4. states methods to extract Id,roles and email Note these are required by the filter

    @Override
    public  Key getSigningKey() {
        byte[] keyBytes = jwtSecret.getBytes();  // Convert string to bytes
        return Keys.hmacShaKeyFor(keyBytes);     // Create HMAC SHA key
    }

    @Override
    public String createToken(Users user) {
        //a. fill in claims list
        Map<String,Object> claims =new HashMap<>();
        claims.put("userId",user.getId());
        claims.put("userEmail",user.getEmail());
        // FIX: Get the first role name as string
        String roleName = user.getRoles().stream()
                .findFirst()
                .map(role -> role.getName())  // Assuming Role has getName()
                .orElse("USER");

        claims.put("userRole", roleName);  // Store as String
        claims.put("userName",user.getName());
        claims.put("userIsActive",user.isActive());

        //b. return String
        return Jwts.builder()
                .setClaims(claims)
                .setSubject(user.getEmail())
                .setIssuedAt(new Date())
                .setExpiration(new Date(System.currentTimeMillis()+jwtExpiration))
                .signWith(getSigningKey(), SignatureAlgorithm.HS256)
                .compact();
        // note all the above ends in compact and that returns String


    }
    //validate token
    @Override
    public boolean validateToken(String token) {
        try {
            Jwts.parserBuilder()
                    .setSigningKey(getSigningKey())
                    .build()
                    .parseClaimsJws(token);
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    // extract email
    @Override
    public String extractEmailFromToken(String token) {
        return Jwts.parserBuilder()
                .setSigningKey(getSigningKey())
                .build()
                .parseClaimsJws(token)
                .getBody()
                .getSubject(); //this is where the email is .
    }

    // extract userId
    @Override
    public Long extractUserId(String token) {
        return Jwts.parserBuilder()
                .setSigningKey(getSigningKey())
                .build()
                .parseClaimsJws(token)
                .getBody()
                .get("userId", Long.class);
    }

    @Override
    public String extractRoleFromToken(String token) {
        try {
            // Extract the "userRole" claim from the token
            return Jwts.parserBuilder()
                    .setSigningKey(getSigningKey())  // Use your existing getSignKey() method
                    .build()
                    .parseClaimsJws(token)        // Parse and validate the token
                    .getBody()                    // Get the claims (payload)
                    .get("userRole", String.class); // Extract "userRole" as String
        } catch (Exception e) {
            // If token is invalid or role not found, return default
            return "USER";  // Or throw exception: throw new RuntimeException("Invalid token");
        }
    }

}
