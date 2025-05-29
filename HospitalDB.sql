CREATE DATABASE HospitalDB;
USE HospitalDB
CREATE TABLE Patients (
    PatientID INT PRIMARY KEY IDENTITY,
    FullName NVARCHAR(100),
    Gender CHAR(1),
    BirthDate DATE,
    Phone NVARCHAR(20)
);

INSERT INTO Patients (FullName, Gender, BirthDate, Phone)
VALUES 
('Ahmed Ali', 'M', '1990-01-01', '0551234567'),
('Sara Saleh', 'F', '1985-05-20', '0559876543');
--C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Backup\
BACKUP DATABASE HospitalDB
TO DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Backup\Full.bak'
WITH FORMAT, INIT, NAME = 'Full Backup of HospitalDB';

BACKUP DATABASE HospitalDB
TO DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Backup\Diff.bak'
WITH DIFFERENTIAL, INIT, NAME = 'Differential Backup of HospitalDB';

BACKUP LOG HospitalDB
TO DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Backup\Log.trn'
WITH INIT, NAME = 'Transaction Log Backup of HospitalDB';