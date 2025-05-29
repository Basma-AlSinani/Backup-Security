CREATE DATABASE TrainingDB; 
USE TrainingDB; 
GO 
CREATE TABLE Students (
StudentID INT PRIMARY KEY, 
FullName NVARCHAR(100), 
EnrollmentDate DATE 
);

INSERT INTO Students VALUES  
(1, 'Sara Ali', '2023-09-01'), 
(2, 'Mohammed Nasser', '2023-10-15'); 


--C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Backup\
--1. Full Backup
BACKUP DATABASE TrainingDB
TO DISK ='C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Backup\Full.bak';
--2. Insert New Record (simulate data change)
INSERT INTO Students VALUES  
(3, 'Fatma Said', '2024-01-10'); 
--3. Differential Backup
BACKUP DATABASE TrainingDB
TO DISK ='C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Backup\Diff.bak'
WITH DIFFERENTIAL;
--4. Transaction Log Backup 
ALTER DATABASE TrainingDB SET RECOVERY FULL;  
BACKUP LOG TrainingDB  
TO DISK ='C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Backup\Log.trn'
--5. Copy-Only Backup 
BACKUP DATABASE TrainingDB TO DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Backup\CopyOnly.bak'
WITH COPY_ONLY;