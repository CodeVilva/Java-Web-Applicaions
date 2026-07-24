package model;

import java.io.Serializable;
import java.sql.Timestamp;

/**
 * ============================================================
 * User Model
 * ============================================================
 * Represents a registered user in SNAPSPOT.
 *
 * Table : users
 * ============================================================
 */
public class User implements Serializable {

    private int userId;
    private String fullName;
    private String email;
    private String mobile;
    private String passwordHash;
    private String status;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // Default Constructor
    public User() {
    }

    // Constructor (Registration)
    public User(String fullName,
                String email,
                String mobile,
                String passwordHash) {

        this.fullName = fullName;
        this.email = email;
        this.mobile = mobile;
        this.passwordHash = passwordHash;
    }

    // ===========================
    // Getters & Setters
    // ===========================

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getMobile() {
        return mobile;
    }

    public void setMobile(String mobile) {
        this.mobile = mobile;
    }

    public String getPasswordHash() {
        return passwordHash;
    }

    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

    @Override
    public String toString() {

        return "User{"
                + "userId=" + userId
                + ", fullName='" + fullName + '\''
                + ", email='" + email + '\''
                + ", mobile='" + mobile + '\''
                + ", status='" + status + '\''
                + '}';

    }

}