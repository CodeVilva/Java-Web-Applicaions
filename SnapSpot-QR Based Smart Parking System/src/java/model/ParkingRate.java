package model;

import java.sql.Timestamp;
import constant.AppConstants;

public class ParkingRate {

    private int rateId;
    private String vehicleType;
    private double hourlyRate;
    private Timestamp createdAt;
    private String status;

    public ParkingRate() {
    }

    public void setStatus(String string){
    this.status = AppConstants.STATUS_ACTIVE;
    }
    public int getRateId() {
        return rateId;
    }

    public void setRateId(int rateId) {
        this.rateId = rateId;
    }

    public String getVehicleType() {
        return vehicleType;
    }

    public void setVehicleType(String vehicleType) {
        this.vehicleType = vehicleType;
    }

    public double getHourlyRate() {
        return hourlyRate;
    }

    public void setHourlyRate(double hourlyRate) {
        this.hourlyRate = hourlyRate;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

}