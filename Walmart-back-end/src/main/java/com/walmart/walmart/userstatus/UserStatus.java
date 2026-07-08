package com.walmart.walmart.userstatus;

public interface UserStatus {
    String getStatusCode();     // "ACTIVE", "NOT_ACTIVE" - fixed for instance
    String getStatusName();
    boolean canLogin();
    String getNextStepMessage();
    void activate();
    void deActivate();
}
