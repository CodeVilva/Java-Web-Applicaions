package service;

import java.io.Serializable;

/**
 * ============================================================
 * ServiceResult
 * ============================================================
 * Standard response object returned by all Service classes.
 *
 * Example:
 *
 * ServiceResult result = userService.registerUser(...);
 *
 * if(result.isSuccess()){
 *     ...
 * }
 * else{
 *     ...
 * }
 * ============================================================
 */
public class ServiceResult implements Serializable {

    private boolean success;
    private String message;
    private Object data;

    /**
     * Default Constructor
     */
    public ServiceResult() {

    }

    /**
     * Constructor
     */
    public ServiceResult(boolean success, String message) {

        this.success = success;
        this.message = message;

    }

    /**
     * Constructor
     */
    public ServiceResult(boolean success,
                         String message,
                         Object data) {

        this.success = success;
        this.message = message;
        this.data = data;

    }

    /**
     * Success Factory Method
     */
    public static ServiceResult success(String message) {

        return new ServiceResult(true, message);

    }

    /**
     * Success Factory Method
     */
    public static ServiceResult success(String message,
                                        Object data) {

        return new ServiceResult(true, message, data);

    }

    /**
     * Failure Factory Method
     */
    public static ServiceResult failure(String message) {

        return new ServiceResult(false, message);

    }

    // =============================
    // Getters and Setters
    // =============================

    public boolean isSuccess() {
        return success;
    }

    public void setSuccess(boolean success) {
        this.success = success;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public Object getData() {
        return data;
    }

    public void setData(Object data) {
        this.data = data;
    }

}

