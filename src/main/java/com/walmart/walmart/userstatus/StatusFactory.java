package com.walmart.walmart.userstatus;

import java.util.HashMap;
import java.util.Map;

public class StatusFactory {
    private static final Map<String, UserStatus> cache = new HashMap<>();

    private StatusFactory() { }

    public static UserStatus getStatus(String code) {
        return cache.computeIfAbsent(code, k -> {
            return switch (k) {
                case "ACTIVE" -> new BaseActiveStatus();
                case "NOT_ACTIVE" -> new BaseNotActiveStatus();
                default -> throw new IllegalArgumentException("Unknown status: " + k);
            };
        });
    }
}