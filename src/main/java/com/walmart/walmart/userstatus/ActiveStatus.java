package com.walmart.walmart.userstatus;

// Abstract base class
public abstract class ActiveStatus implements UserStatus {

    protected ActiveStatus() { }

    @Override
    public String getStatusCode() {
        return "ACTIVE";
    }

    @Override
    public String getStatusName() {
        return "Active";
    }

    @Override
    public boolean canLogin() {
        return true;
    }

    @Override
    public String getNextStepMessage() {
        return "Welcome back!";
    }

}
