# 🛒 Walmart Fullstack Authentication App

A complete authentication system with **Spring Boot** backend and **Flutter** frontend. Features JWT-based authentication, role-based access control, user status management, and Firebase integration.

## 📋 Table of Contents
- [Tech Stack](#-tech-stack)
- [Features](#-features)
- [Project Structure](#-project-structure)
- [Installation & Setup](#-installation--setup)
- [Backend Setup](#-backend-setup)
- [Frontend Setup](#-frontend-setup)
- [API Endpoints](#-api-endpoints)
- [Authentication Flow](#-authentication-flow)
- [State Management](#-state-management)
- [Firebase Integration](#-firebase-integration)
- [Deployment](#-deployment)
- [Contributing](#-contributing)
- [License](#-license)

## 🚀 Tech Stack

### Backend
- **Java 17** with Spring Boot 3.x
- **Spring Security** for authentication & authorization
- **JWT** (JSON Web Tokens) for secure session management
- **JPA/Hibernate** for database operations
- **BCrypt** for password encryption
- **Maven** for dependency management
- **MySQL/PostgreSQL** for production database

### Frontend
- **Flutter 3.x** (Dart)
- **BLoC Pattern** for state management
- **Firebase** for authentication fallback
- **Responsive Design** (Mobile, Tablet, Desktop)
- **REST API** integration with Spring Boot
- **Cross-platform** (Android, iOS, Web)

## ✨ Features

### Authentication
- ✅ User Registration with validation
- ✅ User Login with email/password
- ✅ JWT Token Generation & Validation
- ✅ Password Encryption (BCrypt)
- ✅ Email Verification Check
- ✅ Remember Me functionality

### Authorization
- ✅ Role-Based Access Control (RBAC)
- ✅ User Roles: ADMIN, USER
- ✅ Protected Endpoints with JWT
- ✅ Public & Private Routes
- ✅ CORS Configuration

### User Management
- ✅ User Profile Management
- ✅ Account Status (Active/Inactive)
- ✅ Last Login Tracking
- ✅ Role Assignment
- ✅ User Registration Flow

### Security
- ✅ Stateless JWT Authentication
- ✅ Security Filter Chain
- ✅ Exception Handling
- ✅ Cross-Origin Resource Sharing (CORS)
- ✅ Password Strength Validation

### UI/UX
- ✅ Responsive Design (Mobile/Tablet/Desktop)
- ✅ Form Validation
- ✅ Loading States
- ✅ Error Handling with SnackBars
- ✅ Welcome Screen with Animation
- ✅ Walmart Brand Theme

