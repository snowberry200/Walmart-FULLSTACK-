package com.walmart.walmart.entity;

import com.walmart.walmart.userstatus.*;
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

    @Column(name = "is_active")
    private boolean isActive = true;

    @Column(name = "status_code")
    private String statusCode = StatusCodes.NOT_ACTIVE;

    private LocalDateTime createdAt;

    private LocalDateTime lastLogin;

    @ManyToMany(fetch = FetchType.EAGER, cascade = CascadeType.ALL)
    @JoinTable(
            name = "user_roles",
            joinColumns = @JoinColumn(name = "user_id"),
            inverseJoinColumns = @JoinColumn(name = "role_id")
    )
    private Set<Role> roles = new HashSet<>();

    // Transient state pattern fields
    @Transient
    private UserStatusContext statusContext;

    @Transient
    private UserStatus cachedStatus;

    // Constructors
    public Users() {
        initializeStatusContext();
    }

    // Initialize the status context
    private void initializeStatusContext() {
        if (this.statusContext == null) {
            this.statusContext = new UserStatusContext();
        }

        // Set the initial status based on statusCode
        UserStatus initialStatus;
        if (StatusCodes.ACTIVE.equals(this.statusCode)) {
            initialStatus = new ActiveStatus(this.statusContext);
        } else {
            initialStatus = new NonActiveStatus(this.statusContext);
        }

        this.statusContext.setStatus(initialStatus);
        this.cachedStatus = initialStatus;

        // Sync isActive with statusCode
        this.isActive = StatusCodes.ACTIVE.equals(this.statusCode);
    }

    // Get status with context - uses cachedStatus
    public UserStatus getStatus() {
        if (cachedStatus == null || statusContext == null) {
            initializeStatusContext();
        }
        return cachedStatus;
    }

    // Delegate methods to status context
    public boolean canLogin() {
        return statusContext != null && statusContext.canLogin();
    }

    public String getNextStepMessage() {
        return statusContext != null ? statusContext.getNextStepMessage() : "";
    }

    public String getCurrentStatusCode() {
        return statusContext != null ? statusContext.getStatusCode() : this.statusCode;
    }

    // Activate the user using state pattern
    public void activateUser() {
        if (statusContext == null) {
            initializeStatusContext();
        }
        statusContext.activate();
        // Sync persistent fields
        this.statusCode = statusContext.getStatusCode();
        this.isActive = true;
        refreshStatus();
    }

    // Deactivate the user using state pattern
    public void deactivateUser() {
        if (statusContext == null) {
            initializeStatusContext();
        }
        statusContext.deActivate();
        // Sync persistent fields
        this.statusCode = statusContext.getStatusCode();
        this.isActive = false;
        refreshStatus();
    }

    // Refresh status after changes
    public void refreshStatus() {
        if (statusContext != null) {
            // Since we can't get currentStatus directly, we'll use the statusCode from context
            this.statusCode = statusContext.getStatusCode();
            this.isActive = StatusCodes.ACTIVE.equals(this.statusCode);

            // Recreate the cached status based on the current status code
            if (StatusCodes.ACTIVE.equals(this.statusCode)) {
                this.cachedStatus = new ActiveStatus(this.statusContext);
            } else {
                this.cachedStatus = new NonActiveStatus(this.statusContext);
            }
            // Update the context with the new status
            this.statusContext.setStatus(this.cachedStatus);
        }
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
        this.statusCode = active ? StatusCodes.ACTIVE : StatusCodes.NOT_ACTIVE;
        // Reinitialize status context
        initializeStatusContext();
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

    public String getStatusCode() {
        return statusCode;
    }

    public void setStatusCode(String statusCode) {
        this.statusCode = statusCode;
        this.isActive = StatusCodes.ACTIVE.equals(statusCode);
        // Reinitialize the status context
        initializeStatusContext();
        refreshStatus();
    }

    public UserStatusContext getStatusContext() {
        return statusContext;
    }

    public void setStatusContext(UserStatusContext statusContext) {
        this.statusContext = statusContext;
        if (statusContext != null) {
            this.statusCode = statusContext.getStatusCode();
            this.isActive = StatusCodes.ACTIVE.equals(this.statusCode);
            refreshStatus();
        }
    }

    // Create user with state pattern
    public static Users createNewUser(String name, String email, String password) {
        Users user = new Users();
        user.setName(name);
        user.setPassword(password);
        user.setEmail(email);
        user.setCreatedAt(LocalDateTime.now());
        user.setStatusCode(StatusCodes.ACTIVE);
        user.setActive(true);
        user.initializeStatusContext();
        return user;
    }

    // JPA callbacks
    @PostLoad
    private void postLoad() {
        // Ensure statusCode and isActive are in sync
        if (this.statusCode == null) {
            this.statusCode = this.isActive ? StatusCodes.ACTIVE : StatusCodes.NOT_ACTIVE;
        } else {
            this.isActive = StatusCodes.ACTIVE.equals(this.statusCode);
        }
        initializeStatusContext();
    }

    @PrePersist
    private void prePersist() {
        if (this.statusCode == null) {
            this.statusCode = StatusCodes.NOT_ACTIVE;
        }
        if (this.createdAt == null) {
            this.createdAt = LocalDateTime.now();
        }
        this.isActive = StatusCodes.ACTIVE.equals(this.statusCode);
    }

    @PreUpdate
    private void preUpdate() {
        this.isActive = StatusCodes.ACTIVE.equals(this.statusCode);
    }
}