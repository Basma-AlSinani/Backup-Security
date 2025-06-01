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
--recover the database up to the last transaction log backup 
--Step 1: Drop the Current Database (Simulate System Failure)
DROP DATABASE TrainingDB; 
--Step 2: Restore from Your Backups
RESTORE DATABASE TrainingDB
FROM DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Backup\Full.bak'
WITH MOVE 'HospitalDB' TO 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\TrainingDB.mdf',
     MOVE 'HospitalDB_log' TO 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\TrainingDB_log.ldf',
     NORECOVERY;
--3. Restore TRANSACTION LOG backup (if you created one)
RESTORE LOG TrainingDB  
FROM DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Backup\Log.trn' 
WITH RECOVERY;
--
SELECT * FROM Students; 


--1. What would happen if you skipped the differential backup step?
--As long as you have the whole backup and all transaction log backups, you can still fully restore the database even if you neglect the differential backup stage.  Without a differential backup,
--restoration could take longer and necessitate using more transaction logs.
--Ignoring differential backups results in more restore steps and a longer recovery time because they help speed up recovery by capturing all changes since the last full backup.
--2. What’s the difference between restoring a full vs. copy-only backup?
--Complete Backup: This affects future differential and log backups by creating a full backup of the database and updating the backup chain.
--A full backup is also produced by a copy-only backup, which has no impact on the backup chain.  Without interfering with typical backup schedules, 
--it is utilized for ad hoc backups (such as for testing or specific needs).
--In situations involving restoration:
--Differential and log backups often start with a full backup.
-- A copy-only backup cannot be utilized in conjunction with differential or log backups; it is only used as a stand-alone restore point.
--3. What happens if you use WITH RECOVERY in the middle of a restore chain?
--The restore process stops if you use WITH RECOVERY in the middle of a restore sequence.
--You can no longer apply additional backups (such as differential or transaction log backups) when SQL Server brings the database online.  
--Any changes saved in the backups you haven't yet restored will be lost as a result of breaking the restore chain.
--4. Which backup types are optional and which are mandatory for full recovery?
--Full BackUp>>always necessary as the foundation for any restoration.
--Transaction Log Backup>>All modifications made since the last backup had to be restored.
--Differential Backup>>speeds up restoration, but if you have all the logs, it's not necessary.
--Copy-Only Backup>>used for specific objectives without interfering with the normal backup cycle.
--Required for Full Recovery?
--Full BackUp<<<Yes
--Transaction Log Backup<<<Yes "for point in time recovery"
--Differential Backup&&Copy-Only Backup<<<Optional