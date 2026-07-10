package com.walmart.walmart.userstatus;

public abstract class NotActiveStatus implements UserStatus {

    protected NotActiveStatus() { }

    @Override
    public String getStatusCode() {
        return "NOT_ACTIVE";
    }

    @Override
    public String getStatusName() {
        return "Not Active";
    }

    @Override
    public boolean canLogin() {
        return false;
    }

    @Override
    public String getNextStepMessage() {
        return "Please register your account to continue.";
    }

    // withUserContext is NOT declared here - it's inherited from UserStatus
}