// Create a new file: com.walmart.walmart.entity.Role.java
package com.walmart.walmart.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;

import java.util.Collection;

@Entity
@Table(name = "role")
public class Role {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(unique = true, nullable = false)
    private String name; // e.g., "USER", "ADMIN"

    @ManyToMany(mappedBy = "roles")
    @JsonIgnore
    private Collection<Users> users;

    // Constructors
    public Role() {}

    public static Role createnNewRole(String name ){
        Role role = new Role();
        role.setName(name) ;
        return role;
    }

    public Role(String name) {
        this.name = name;
    }

    // Getters and setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public Collection<Users> getUsers() { return users; }
    public void setUsers(Collection<Users> users) { this.users = users; }
}