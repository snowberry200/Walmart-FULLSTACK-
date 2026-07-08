// ===== 1. UPDATE YOUR USER STATUS INTERFACE =====
package com.walmart.walmart.userstatus;

import com.walmart.walmart.entity.Users;

public interface UserStatus {

    // STATIC GROUP - what defines this status
    String getStatusCode();     // "ACTIVE", "NOT_ACTIVE" - fixed for instance
    String getStatusName();     // "Active", "Not Active" - fixed display name

    // DYNAMIC GROUP - can change based on context
    boolean canLogin();         // Could check additional conditions
    String getNextStepMessage(); // Personalized message

    // Factory method
    static UserStatus of(String statusCode) {
        return StatusFactory.getStatus(statusCode);
    }

    // Method to get dynamic context for a specific user
    default UserStatus withUserContext(Users user) {
        // Default returns itself, but statuses can override
        return this;
    }
}