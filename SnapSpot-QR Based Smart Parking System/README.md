# 🚗 SNAPSPOT - QR Based Parking Management System

SNAPSPOT is a web-based parking management system that streamlines vehicle parking using QR code technology. The system enables users to reserve parking slots online, generates a unique QR code for each booking, and allows ticket checkers to verify vehicle entry and exit efficiently.

---

## 📌 Features

### 👤 User
- User Registration & Login
- Secure Password Encryption (BCrypt)
- Vehicle Management
- View Available Parking Slots
- Book Parking Slot
- Dummy Payment Gateway
- QR Code Generation
- View Booking History
- User Profile Management

### 🛡️ Admin
- Secure Admin Login
- Dashboard
- Manage Parking Areas
- Manage Parking Floors
- Manage Parking Slots
- Manage Ticket Checkers
- View All Bookings

### 🎫 Ticket Checker
- Secure Login
- Dashboard
- Scan/Verify QR Code
- Vehicle Entry
- Vehicle Exit
- Automatic Slot Availability Update

---

## 🏗 System Architecture

```
User
 │
 ├── Register/Login
 ├── Register Vehicle
 ├── Book Slot
 ├── Dummy Payment
 └── Receive QR Code
          │
          ▼
Ticket Checker
 │
 ├── Scan QR
 ├── Verify Booking
 ├── Entry
 └── Exit
          │
          ▼
Parking Slot Status Updated
          │
          ▼
Admin Dashboard
```

---

## 🛠️ Technologies Used

### Frontend
- HTML5
- CSS3
- Bootstrap 5
- JSP

### Backend
- Java
- Servlets
- JDBC

### Database
- MySQL

### Libraries
- BCrypt
- ZXing (QR Code Generation)

### IDE & Server
- Apache NetBeans
- Apache Tomcat

---

## 📂 Project Structure

```
SNAPSPOT/
│
├── src/
│   ├── controller/
│   ├── dao/
│   ├── model/
│   ├── util/
│   └── constants/
│
├── web/
│   ├── admin/
│   ├── user/
│   ├── ticket-checker/
│   ├── css/
│   ├── js/
│   └── images/
│
├── database/
│
└── README.md
```

---

## 🗄 Database Modules

- Users
- Vehicles
- Parking Areas
- Parking Floors
- Parking Slots
- Bookings
- Payments
- Ticket Checkers
- Entry/Exit Logs

---

## 🔄 System Workflow

### User Flow

1. Register/Login
2. Register Vehicle
3. Select Parking Slot
4. Complete Dummy Payment
5. QR Code Generated
6. Visit Parking
7. QR Verification
8. Vehicle Entry
9. Vehicle Exit
10. Slot Becomes Available

---

### Admin Flow

1. Login
2. Manage Parking Areas
3. Manage Parking Floors
4. Manage Parking Slots
5. Manage Ticket Checkers
6. Monitor Bookings

---

### Ticket Checker Flow

1. Login
2. Scan QR Code
3. Validate Booking
4. Record Vehicle Entry
5. Record Vehicle Exit
6. Update Slot Availability

---

## 🔐 Security Features

- BCrypt Password Hashing
- Session Management
- Role-Based Access Control
- SQL Injection Prevention using Prepared Statements
- Input Validation
- QR-Based Booking Verification

---

## 🚀 Installation

### Prerequisites

- JDK 8+
- Apache Tomcat 9+
- MySQL
- Apache NetBeans IDE

### Steps

1. Clone the repository

```bash
git clone https://github.com/YOUR_USERNAME/SNAPSPOT.git
```

2. Import into NetBeans.

3. Create the MySQL database.

4. Execute the SQL schema.

5. Configure database credentials in `DBConnection.java`.

6. Run the project on Apache Tomcat.

---

## 📸 Screenshots

Add screenshots for:

- Home Page
- User Dashboard
- Admin Dashboard
- Ticket Checker Dashboard
- Booking Page
- QR Code
- QR Verification
- Booking List

---

## 🌟 Future Enhancements

- Real Payment Gateway Integration
- Email Notifications
- SMS Alerts
- Parking Analytics Dashboard
- Mobile Application
- GPS Navigation to Parking Slot
- Automatic QR Scanning

---

## 📄 License

This project is developed for educational purposes as a final-year academic project.
