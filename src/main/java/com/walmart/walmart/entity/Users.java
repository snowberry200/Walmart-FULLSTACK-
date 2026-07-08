package com.walmart.walmart.entity;

import com.walmart.walmart.userstatus.UserStatus;
import com.walmart.walmart.userstatus.StatusCodes;
import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name = "users")
public class Users {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String name;

    @Column(unique = true, nullable = false)
    private String email;

    @Column(nullable = false)
    private String password;

    private boolean isActive = true;

    private LocalDateTime createdAt;

    private LocalDateTime lastLogin;

    @ManyToMany(fetch = FetchType.EAGER, cascade = CascadeType.ALL)
    @JoinTable(
            name = "user_roles",
            joinColumns = @JoinColumn(name = "user_id"),
            inverseJoinColumns = @JoinColumn(name = "role_id")
    )
    private Set<Role> roles = new HashSet<>();

    @Transient
    private UserStatus cachedStatus;

    // Constructors
    public Users() { }

    public static Users createNewUser(String name, String email, String password) {
        Users user = new Users();
        user.setName(name);
        user.setPassword(password);
        user.setEmail(email);
        user.setCreatedAt(LocalDateTime.now());
        user.setActive(true);
        return user;
    }

    // Get status with context
    public UserStatus getStatus() {
        if (cachedStatus == null) {
            String statusCode = isActive ? StatusCodes.ACTIVE : StatusCodes.NOT_ACTIVE;
            UserStatus baseStatus = UserStatus.of(statusCode);
            cachedStatus = baseStatus.withUserContext(this);
        }
        return cachedStatus;
    }

    // Refresh status after changes
    public void refreshStatus() {
        this.cachedStatus = null;
    }

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public boolean isActive() { return isActive; }
    public void setActive(boolean active) {
        this.isActive = active;
        refreshStatus();
    }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getLastLogin() { return lastLogin; }
    public void setLastLogin(LocalDateTime lastLogin) {
        this.lastLogin = lastLogin;
        refreshStatus();
    }

    public Set<Role> getRoles() { return roles; }
    public void setRoles(Set<Role> roles) {
        this.roles = roles;
        refreshStatus();
    }

    public void addRole(Role role) {
        this.roles.add(role);
        refreshStatus();
    }

    public void removeRole(Role role) {
        this.roles.remove(role);
        refreshStatus();
    }
}