package com.walmart.walmart.userstatus;

import com.walmart.walmart.entity.Users;

public final class BaseNotActiveStatus extends NotActiveStatus {

    BaseNotActiveStatus() { }

    @Override
    public UserStatus withUserContext(Users user) {
        return new NotActiveUserContext(this, user);
    }

    private static final class NotActiveUserContext extends NotActiveStatus {
        private final NotActiveStatus baseStatus;
        private final Users user;

        NotActiveUserContext(NotActiveStatus baseStatus, Users user) {
            this.baseStatus = baseStatus;
            this.user = user;
        }

        @Override
        public String getStatusCode() {
            return baseStatus.getStatusCode();
        }

        @Override
        public String getStatusName() {
            return baseStatus.getStatusName();
        }

        @Override
        public boolean canLogin() {
            return baseStatus.canLogin();
        }

        @Override
        public String getNextStepMessage() {
            if (user.getLastLogin() == null) {
                return user.getName() + ", please complete your registration.";
            }
            return user.getName() + ", your account has been deactivated.";
        }

        @Override
        public UserStatus withUserContext(Users newUser) {
            return new NotActiveUserContext(baseStatus, newUser);
        }
    }
}