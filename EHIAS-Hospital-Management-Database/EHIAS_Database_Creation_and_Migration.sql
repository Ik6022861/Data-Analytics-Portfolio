
-- Create Database 

CREATE DATABASE EHIAS;
USE EHIAS;


-- CREATING Department Table

CREATE TABLE department(
	departmentID INT IDENTITY(1,1) PRIMARY KEY,
	name VARCHAR(50) NOT NULL
)


-- CREATING Doctors Table
CREATE TABLE Doctors(
	doctorID INT IDENTITY(1,1) PRIMARY KEY,
	name VARCHAR(50),
	specialization VARCHAR(100),
	role VARCHAR(50),
	departmentid INT

    FOREIGN KEY (departmentid)
    REFERENCES departments(departmentID)
)


-- CREATE TABLE Patients 
CREATE TABLE patients(
	patientID INT IDENTITY(1,1) PRIMARY KEY,
	name VARCHAR(50),
	DateOfBirth DATE,
	gender CHAR(1),
	phone VARCHAR(20),
	CHECK (gender IN ('m', 'f', 'o'))
)


-- CREATE TABLE Appointments
CREATE TABLE appointments(
	appointmentID INT IDENTITY(1,1) PRIMARY KEY,
	patientid INT,
	doctorid INT,
	appointmentTime DATETIME,
	status VARCHAR(50),
	
	FOREIGN KEY (patientid) REFERENCES patients(patientID),
	FOREIGN KEY (doctorid) REFERENCES Doctors(doctorID),

	CHECK (status IN ('Scheduled', 'Completed', 'Cancelled'))
	
)


-- Create Table Prescriptions
CREATE TABLE prescriptions(
	prescriptionID INT IDENTITY(1,1) PRIMARY KEY,
	appointmentid INT,
	medication VARCHAR(100),
	dosage VARCHAR(100),

	FOREIGN KEY (appointmentid) REFERENCES appointments(appointmentID)
)


-- Create Table Bills

CREATE TABLE bills(
	billID INT IDENTITY(1,1) PRIMARY KEY,
	appointmentid INT,
	amount DECIMAL(10, 2),
	paid BIT,
	billDate DATETIME DEFAULT CURRENT_TIMESTAMP,

	FOREIGN KEY (appointmentid) REFERENCES appointments(appointmentID)
)


-- Create Table LabReports

CREATE TABLE labReports(
	reportID INT IDENTITY(1, 1) PRIMARY KEY,
	appointmentid INT,
	reportData TEXT,
	createdAt DATETIME DEFAULT CURRENT_TIMESTAMP,

	FOREIGN KEY (appointmentid) REFERENCES appointments(appointmentID)
)


-- Insertion IN Database

-- Inserting values Into Department
------------------------------------------------------------
SET IDENTITY_INSERT departments ON;

INSERT INTO departments (departmentID, name)
SELECT
    CONVERT(INT, CONVERT(VARCHAR(50), Departments_DepartmentID)),
    CONVERT(VARCHAR(50), Departments_Name)
FROM hospital_data
WHERE Departments_DepartmentID IS NOT NULL;

SET IDENTITY_INSERT departments OFF;

--------------------------------------------------------------


-- Inserting values Into doctors

SET IDENTITY_INSERT doctors ON;

INSERT INTO doctors (doctorID, name, specialization, role, departmentid)
SELECT
   Doctors_DoctorID,
   Doctors_Name,
   Doctors_Specialization,
   Doctors_Role, 
   Doctors_DepartmentID  
FROM hospital_data
WHERE Doctors_DoctorID IS NOT NULL;

SET IDENTITY_INSERT doctors OFF;

------------------------------------------------------------------

-- Inserting values Into patients

SET IDENTITY_INSERT patients ON;

INSERT INTO patients (patientID, name, DateOfBirth, gender, phone)
SELECT
   Patients_PatientID,
   Patients_Name,
   Patients_DateOfBirth,
   Patients_Gender, 
   Patients_Phone  
FROM hospital_data
WHERE Patients_PatientID IS NOT NULL;

SET IDENTITY_INSERT patients OFF;

----------------------------------------------------------------------

-- Inserting values Into appointments

SET IDENTITY_INSERT appointments ON;

INSERT INTO appointments (appointmentID, patientid, doctorid, appointmentTime, status)
SELECT
   Appointments_AppointmentID,
   Appointments_PatientID,
   Appointments_DoctorID,
   TRY_CONVERT(DATETIME, Appointments_AppointmentTime, 105), 
   Appointments_Status   
FROM hospital_data
WHERE Appointments_AppointmentID IS NOT NULL;

SET IDENTITY_INSERT appointments OFF;

--------------------------------------------------------------------------

-- Inserting values Into Prescriptions

SET IDENTITY_INSERT prescriptions ON;

INSERT INTO prescriptions (prescriptionID, appointmentID, medication, dosage)
SELECT
   Prescriptions_PrescriptionID,
   Prescriptions_AppointmentID,
   Prescriptions_Medication,
   Prescriptions_Dosage  
FROM hospital_data
WHERE Prescriptions_PrescriptionID IS NOT NULL;

SET IDENTITY_INSERT prescriptions OFF;


---------------------------------------------------------------------------------

-- Inserting values Into Bills

SET IDENTITY_INSERT bills ON;

INSERT INTO bills (billID, appointmentid, amount, paid, billDate)
SELECT
   Bills_BillID,
   Bills_AppointmentID,
   Bills_Amount,
   Bills_Paid,
   Bills_BillDate 
FROM hospital_data
WHERE Bills_BillID IS NOT NULL;

SET IDENTITY_INSERT bills OFF;


-----------------------------------------------------------------------------------

-- Inserting values Into labReports

SET IDENTITY_INSERT labReports ON;

INSERT INTO labReports (reportID, appointmentid, reportData, createdAt)
SELECT
   LabReports_ReportID,
   LabReports_AppointmentID,
   LabReports_ReportData,
   LabReports_CreatedAt
FROM hospital_data
WHERE LabReports_ReportID IS NOT NULL;

SET IDENTITY_INSERT labReports OFF;

--------------------------------------------------------------------------------

-- Point 4

CREATE OR ALTER TRIGGER CHECK_NEW_APPOINTMENT
ON appointments
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS
    (
        SELECT 1
        FROM inserted
        WHERE appointmentTime < GETDATE()
    )
    BEGIN
        ROLLBACK TRANSACTION;
        THROW 50000, 'Error: Appointment cannot be in the past', 1;
    END;

    IF EXISTS
    (
        SELECT 1
        FROM appointments a
        INNER JOIN inserted i
            ON a.doctorid = i.doctorid
           AND a.appointmentTime = i.appointmentTime
           AND a.appointmentID <> i.appointmentID
        WHERE a.status = 'Scheduled'
    )
    BEGIN
        ROLLBACK TRANSACTION;
        THROW 50000, 'Error: Doctor already has an appointment at this time', 1;
    END;
END;

-------------------------------------------------------------------------------------

SET IDENTITY_INSERT appointments ON;

INSERT INTO appointments (appointmentID, patientid, doctorid, appointmentTime, status)
VALUES(4001, 1, 1, '2026-10-08 10:00:00', 'Scheduled')

SET IDENTITY_INSERT appointments OFF;

-------

SET IDENTITY_INSERT appointments ON;

INSERT INTO appointments (appointmentID, patientid, doctorid, appointmentTime, status)
VALUES(4002, 1, 1, '2026-10-08 10:00:00', 'Scheduled')

SET IDENTITY_INSERT appointments OFF;

-------

SET IDENTITY_INSERT appointments ON;

INSERT INTO appointments (appointmentID, patientid, doctorid, appointmentTime, status)
VALUES(4002, 1, 1, '2026-10-07 10:00:00', 'Scheduled')

SET IDENTITY_INSERT appointments OFF;

-------

---------------------------------------------------------------------------------------------------------

-- Point 5

CREATE OR ALTER PROCEDURE VIEW_DOCTOR_DATA @INPUT_USERNAME VARCHAR(100), @INPUT_PASSWORD VARCHAR(100)
AS
BEGIN
	DECLARE 
	@DOC_ROLE VARCHAR(100),
	@DOC_DEPT INT,
	@DOC_ID INT


	-- Check Credentials Of Doctor
	SELECT @DOC_ID = doctor_id 
	FROM doctor_credentials 
	WHERE user_name = @INPUT_USERNAME AND password=@INPUT_PASSWORD


	-- GET Role and Department From Doctor Table
	SELECT @DOC_ROLE=role, @DOC_DEPT=departmentid FROM Doctors
	WHERE doctorID=@DOC_ID 


	-- Show Appropriate Patient Data
	IF @DOC_ROLE='Senior' 

	BEGIN
		SELECT 
			D.doctorID,
			P.patientID, P.name AS 'Patient Name', P.gender, 
			A.appointmentTime,
			PR.medication,
			LR.reportData
		FROM patients AS P
		INNER JOIN
		appointments AS A
		ON
		P.patientID = A.patientid
		LEFT JOIN
		prescriptions AS PR
		ON
		A.appointmentID= PR.appointmentid
		LEFT JOIN 
		labReports AS LR
		ON
		LR.appointmentid = A.appointmentID
		LEFT JOIN
		Doctors AS D
		ON
		A.doctorid = D.doctorID
		WHERE D.departmentid = @DOC_DEPT
	END

	ELSE

	BEGIN
		SELECT 
			A.doctorid, P.patientID, P.name AS 'Patient Name', P.gender, 
			A.appointmentTime,
			PR.medication,
			LR.reportData
		FROM patients AS P
		INNER JOIN
		appointments AS A
		ON
		P.patientID = A.patientid
		LEFT JOIN
		prescriptions AS PR
		ON
		A.appointmentID= PR.appointmentid
		LEFT JOIN 
		labReports AS LR
		ON
		LR.appointmentid = A.appointmentID
		LEFT JOIN
		Doctors AS D
		ON
		A.doctorid = D.doctorID
		WHERE A.doctorid=@DOC_ID
	END
END

EXEC VIEW_DOCTOR_DATA doctor1, W3jzIANG

EXEC VIEW_DOCTOR_DATA doctor4, ic0pFSn0

------------------------------------------------------------------------------------------
--Point 6

CREATE PROCEDURE SP_MONTHLYREVENUE @P_YEAR INT, @P_MONTH INT
AS
BEGIN
	SELECT DEP.name, SUM(B.amount) AS TOTAL_REVENUE
	FROM bills AS B
	INNER JOIN 
	appointments AS A
	ON
	B.appointmentid = A.appointmentID
	INNER JOIN
	Doctors AS D
	ON
	D.doctorID=A.doctorid
	INNER JOIN 
	departments AS DEP
	ON DEP.departmentID = D.departmentid
	WHERE MONTH(B.billDate) = @P_MONTH AND YEAR(B.billDate) = @P_YEAR 
	GROUP BY DEP.name
END

EXEC SP_MONTHLYREVENUE 2025, 4

