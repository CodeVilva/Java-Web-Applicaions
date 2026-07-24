# 🔐 Hybrid Encryption–Based Secure File Sharing System

A secure Java web application that enables encrypted file storage and sharing using a **Hybrid Encryption** approach. The system combines the speed of **AES** for file encryption with the security of **RSA** for key exchange, ensuring that sensitive files remain confidential during storage and transmission.

---

## 📌 Table of Contents

- [Overview](#-overview)
- [Key Features](#-key-features)
- [Technology Stack](#-technology-stack)
- [System Architecture](#-system-architecture)
- [Encryption Workflow](#-encryption-workflow)
- [Project Structure](#-project-structure)
- [Installation](#-installation)
- [Database Configuration](#-database-configuration)
- [How to Run](#-how-to-run)
- [Security Features](#-security-features)
- [Future Enhancements](#-future-enhancements)
- [Screenshots](#-screenshots)
- [Author](#-author)
- [License](#-license)

---

# 📖 Overview

Traditional file-sharing systems often store uploaded files without adequate encryption, making them vulnerable to unauthorized access and data breaches.

This project addresses those challenges by implementing a **Hybrid Encryption Model**, where:

- Files are encrypted using **AES-256**
- AES keys are encrypted using **RSA-2048**
- Only authorized users can decrypt and access shared files
- User authentication and role-based access control protect sensitive resources

The application is built using Java Enterprise technologies and follows a secure client-server architecture.

---

# ✨ Key Features

### 👤 User Module

- User Registration
- Secure Login
- Upload Files
- Download Files
- View Uploaded Files
- Delete Files
- Profile Management

### 👨‍💼 Admin Module

- Admin Login
- User Management
- File Management
- Activity Monitoring
- Access Control

### 🔐 Security

- AES-256 File Encryption
- RSA-2048 Key Encryption
- Secure Key Exchange
- Password Hashing
- Session Management
- Role-Based Authorization
- Input Validation
- SQL Injection Prevention

---

# 💻 Technology Stack

## Frontend

- HTML5
- CSS3
- Bootstrap
- JavaScript

## Backend

- Java
- JSP
- Servlets
- JDBC

## Database

- MySQL

## Cryptography

- AES-256
- RSA-2048
- Java Cryptography Architecture (JCA)

## IDE

- NetBeans IDE

## Web Server

- Apache Tomcat

---

# 🏗️ System Architecture

```
                +----------------------+
                |      Web Browser     |
                +----------+-----------+
                           |
                           |
                    HTTP Request
                           |
                           ▼
               +-----------------------+
               | JSP / Servlet Layer   |
               +----------+------------+
                          |
         +----------------+----------------+
         |                                 |
         ▼                                 ▼
 Encryption Module                 Authentication
(AES + RSA)                        & Authorization
         |                                 |
         +----------------+----------------+
                          |
                          ▼
                  JDBC Database Layer
                          |
                          ▼
                      MySQL Database
```

---

# 🔐 Encryption Workflow

```
User Uploads File
        │
        ▼
Generate Random AES Key
        │
        ▼
Encrypt File using AES
        │
        ▼
Encrypt AES Key using RSA Public Key
        │
        ▼
Store:
 • Encrypted File
 • Encrypted AES Key
        │
        ▼
User Requests Download
        │
        ▼
RSA Private Key decrypts AES Key
        │
        ▼
AES decrypts File
        │
        ▼
Original File Downloaded
```

---

# 📁 Project Structure

```
Hybrid-Encryption-Based-Secure-File-Sharing-System
│
├── src
│   ├── controller
│   ├── dao
│   ├── model
│   ├── service
│   ├── util
│   └── encryption
│
├── WebContent
│   ├── css
│   ├── js
│   ├── images
│   ├── uploads
│   ├── WEB-INF
│   ├── index.jsp
│   ├── login.jsp
│   ├── register.jsp
│   ├── dashboard.jsp
│   └── upload.jsp
│
├── database
│   └── database.sql
│
├── README.md
└── LICENSE
```

---

# ⚙️ Installation

## 1. Clone Repository

```bash
git clone https://github.com/<your-username>/Hybrid-Encryption-Based-Secure-File-Sharing-System.git
```

---

## 2. Open Project

Open the project using **NetBeans IDE**.

---

## 3. Install Required Software

- JDK 8 or above
- Apache Tomcat 9+
- MySQL
- NetBeans IDE

---

## 4. Configure Database

Create a database in MySQL.

```sql
CREATE DATABASE secure_file_sharing;
```

Import the provided SQL file.

```
database/database.sql
```

---

## 5. Configure Database Connection

Update your JDBC configuration.

```java
String url = "jdbc:mysql://localhost:3306/secure_file_sharing";
String username = "root";
String password = "your_password";
```

---

## 6. Deploy

Deploy the project on Apache Tomcat.

---

## 7. Run

Open your browser.

```
http://localhost:8080/HybridEncryption
```

---

# 🛡️ Security Features

- Hybrid AES + RSA Encryption
- Secure Key Exchange
- Password Hashing
- Session Timeout
- Authentication
- Authorization
- Role-Based Access
- Input Validation
- SQL Injection Protection
- Exception Handling
- Secure File Storage
- Access Logging

---

# 🚀 Future Enhancements

- Cloud Storage Integration
- Two-Factor Authentication (2FA)
- Email Verification
- OTP-Based Login
- File Versioning
- Temporary Secure Sharing Links
- QR-Based Secure File Access
- Digital Signature Verification
- Blockchain-Based Audit Logs
- Mobile Application

---

# 📸 Screenshots

Add screenshots of your application here.

Example:

```
screenshots/
│
├── home.png
├── login.png
├── register.png
├── dashboard.png
├── upload.png
├── download.png
└── admin-dashboard.png
```

---

# 👨‍💻 Author

**Vilva**

Software Developer | Java Full Stack | Secure Systems Enthusiast

---

# 📄 License

This project is licensed under the MIT License.

You are free to use, modify, and distribute this project for educational and personal purposes.

---

# ⭐ Support

If you found this project useful, please consider giving it a **⭐ Star** on GitHub.

It helps others discover the project and supports future development.

---

## 🤝 Contributing

Contributions are welcome!

1. Fork this repository
2. Create a new branch

```bash
git checkout -b feature-name
```

3. Commit your changes

```bash
git commit -m "Add new feature"
```

4. Push to GitHub

```bash
git push origin feature-name
```

5. Open a Pull Request

---

## 📬 Contact

For questions, suggestions, or collaborations, feel free to connect through GitHub.

**Happy Coding! 🚀**
