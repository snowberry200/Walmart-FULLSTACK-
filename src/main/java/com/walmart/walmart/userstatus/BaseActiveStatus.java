package com.walmart.walmart.userstatus;

import com.walmart.walmart.entity.Users;

import java.time.LocalDateTime;

// Concrete implementation for factory use
final class BaseActiveStatus extends ActiveStatus {

    BaseActiveStatus() {}
    @Override
    public UserStatus withUserContext(Users user) {
        return new ActiveUserContext(this, user);
    }

    // Context class
    private static final class ActiveUserContext extends ActiveStatus {
        private final ActiveStatus baseStatus;
        private final Users user;

        ActiveUserContext(ActiveStatus baseStatus, Users user) {
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
            if (user.getLastLogin() != null &&
                    user.getLastLogin().isBefore(LocalDateTime.now().minusDays(90))) {
                return false;
            }
            return baseStatus.canLogin();
        }

        @Override
        public String getNextStepMessage() {
            if (user.getLastLogin() == null) {
                return "Welcome " + user.getName() + "!";
            }
            return "Welcome back " + user.getName() + "!";
        }

        @Override
        public UserStatus withUserContext(Users newUser) {
            return new ActiveUserContext(baseStatus, newUser);
        }
    }
}