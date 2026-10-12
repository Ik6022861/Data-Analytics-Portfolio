# Enterprise Hospital Information and Appointment System (EHIAS)

## Overview

A SQL Server database project designed to manage:

- Patients
- Doctors
- Departments
- Appointments
- Prescriptions
- Billing
- Lab Reports

## Features

### Unique Identifiers

- IDENTITY Primary Keys

### Referential Integrity

- Foreign Keys between related tables

### Data Validation

- Gender validation
- Appointment status validation

### Appointment Management

- Prevent appointments in the past
- Prevent doctor double-booking

### Role Based Access Control

- Senior doctors can view all patients in their department
- Regular doctors can only view their own patients

### Revenue Reporting

- Monthly revenue reports by department

## Technologies

- SQL Server
- SSMS
- T-SQL
- Triggers
- Stored Procedures

## ER Diagram

See [ERD.png](https://github.com/Ik6022861/Data-Analytics-Portfolio/blob/main/EHIAS-Hospital-Management-Database/ERD.png).
