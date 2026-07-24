package model;

import java.io.Serializable;
import java.sql.Timestamp;

/**
 * ============================================================
 * Vehicle Model
 * ============================================================
 * Represents a vehicle owned by a user.
 *
 * Table : vehicles
 * ============================================================
 */
public class Vehicle implements Serializable {

    private int vehicleId;
    private int userId;
    private String vehicleNumber;
    private String vehicleType;
    private boolean defaultVehicle;
    private Timestamp createdAt;

    // Default Constructor
    public Vehicle() {

    }

    // Constructor for Registration
    public Vehicle(String vehicleNumber,
                   String vehicleType) {

        this.vehicleNumber = vehicleNumber;
        this.vehicleType = vehicleType;
    }

    // ==========================
    // Getters and Setters
    // ==========================

    public int getVehicleId() {
        return vehicleId;
    }

    public void setVehicleId(int vehicleId) {
        this.vehicleId = vehicleId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getVehicleNumber() {
        return vehicleNumber;
    }

    public void setVehicleNumber(String vehicleNumber) {
        this.vehicleNumber = vehicleNumber;
    }

    public String getVehicleType() {
        return vehicleType;
    }

    public void setVehicleType(String vehicleType) {
        this.vehicleType = vehicleType;
    }

    public boolean isDefaultVehicle() {
        return defaultVehicle;
    }

    public void setDefaultVehicle(boolean defaultVehicle) {
        this.defaultVehicle = defaultVehicle;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {

        return "Vehicle{"
                + "vehicleId=" + vehicleId
                + ", userId=" + userId
                + ", vehicleNumber='" + vehicleNumber + '\''
                + ", vehicleType='" + vehicleType + '\''
                + ", defaultVehicle=" + defaultVehicle
                + '}';

    }

}