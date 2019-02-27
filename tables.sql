DROP TABLE IF EXISTS Projects;
DROP TABLE IF EXISTS TeamMembers;
DROP TABLE IF EXISTS Teams;
DROP TABLE IF EXISTS Semesters;
DROP TABLE IF EXISTS Role;
DROP TABLE IF EXISTS Members;
DROP TABLE IF EXISTS Assets;
DROP TABLE IF EXISTS Metrics;
DROP TABLE IF EXISTS Preferences;
DROP TABLE IF EXISTS Notifications;
DROP TABLE IF EXISTS AccountLabs;
DROP TABLE IF EXISTS Labs;
DROP TABLE IF EXISTS Accounts;

CREATE TABLE Accounts
(AcctID int auto_increment PRIMARY KEY,
Username VARCHAR(128),
Password VARCHAR(128),
FirstName VARCHAR(25),
LastName VARCHAR(25),
Role VARCHAR(5));

CREATE TABLE Labs
(LabID int auto_increment PRIMARY KEY,
Abbrev VARCHAR(5),
School VARCHAR(50),
City VARCHAR(50),
State VARCHAR(2));

CREATE TABLE AccountLabs
(AcctID int NOT NULL,
LabID int NOT NULL,
FOREIGN KEY (AcctID) REFERENCES Accounts(AcctID),
FOREIGN KEY (LabID) REFERENCES Labs(LabID),
UNIQUE (AcctID, LabID));

CREATE TABLE Notifications
(NotifyID int auto_increment PRIMARY KEY,
Type VARCHAR(25),
Description VARCHAR(255),
Name VARCHAR(40),
Date DATE,
AcctID int,
FOREIGN KEY (AcctID) REFERENCES Accounts(AcctID));

CREATE TABLE Preferences
(PrefID int auto_increment PRIMARY KEY,
NavColor VARCHAR(7),
AcctID int,
FOREIGN KEY (AcctID) REFERENCES Accounts(AcctID));

CREATE TABLE Metrics
(MetID int auto_increment PRIMARY KEY,
Type VARCHAR(25),
Description VARCHAR(50),
IsActive BOOLEAN,
PrefID int,
FOREIGN KEY (PrefID) REFERENCES Preferences(PrefID));

CREATE TABLE Assets
(AssetID int auto_increment PRIMARY KEY,
AssetTag int,
Type VARCHAR(25),
Description VARCHAR(50),
IsImaged boolean,
LabID int,
FOREIGN KEY (LabID) REFERENCES Labs(LabID));

CREATE TABLE Members
(MemberID int auto_increment PRIMARY KEY,
FirstName VARCHAR(20),
LastName VARCHAR(20),
Gender VARCHAR(15),
GradYear VARCHAR(4),
Email VARCHAR(320),
AssetID int,
LabID int,
FOREIGN KEY (AssetID) REFERENCES Assets(AssetID),
FOREIGN KEY (LabID) REFERENCES Labs(LabID));

CREATE TABLE Role
(RoleID int auto_increment PRIMARY KEY,
Type VARCHAR(25),
Status VARCHAR(25),
Description VARCHAR(255),
Date DATE,
MemberID int NOT NULL,
FOREIGN KEY (MemberID) REFERENCES Members(MemberID));

CREATE TABLE Semesters
(SemesterID int auto_increment PRIMARY KEY,
Semester VARCHAR(6),
Year int,
MemberID int,
FOREIGN KEY (MemberID) REFERENCES Members(MemberID));

CREATE TABLE Teams
(TeamID int auto_increment PRIMARY KEY,
TeamName VARCHAR(20),
PO VARCHAR(41),
Mentor VARCHAR(41),
Semester VARCHAR(4),
LabID int,
FOREIGN KEY(LabID) REFERENCES Labs(LabID));

CREATE TABLE TeamMembers
(TeamID int NOT NULL,
MemberID int NOT NULL,
FOREIGN KEY (TeamID) REFERENCES Teams(TeamID),
FOREIGN KEY (MemberID) REFERENCES Members(MemberID),
UNIQUE (TeamID, MemberID));

CREATE TABLE Projects
(ProjectID int auto_increment PRIMARY KEY,
Name VARCHAR(50),
Type VARCHAR(20),
Description VARCHAR(255),
TeamID int,
FOREIGN KEY (TeamID) REFERENCES Teams(TeamID));

INSERT INTO Accounts( Username, Password, FirstName, LastName, Role) VALUES
('mbrenner2', 'password', 'Mike', 'Brenner', 'Write');

INSERT INTO Labs(Abbrev, School, City, State) VALUES
('NIU', 'Northern Illinois University', 'Dekalb', 'IL');

INSERT INTO AccountLabs(AcctID, LabID) VALUES
(1, 1);

INSERT INTO Notifications(Type, Description, Name, Date, AcctID) VALUES
('Alert', 'This user sucks', 'Not Me', '2019-2-12', 1);

INSERT INTO Preferences(NavColor, AcctID) VALUES
('#202020', 1);

INSERT INTO Metrics(Type, Description, IsActive, PrefID) VALUES
('Total', 'Number of students', 1, 1);

INSERT INTO Assets(AssetTag, Type, Description, IsImaged, LabID) VALUES
( 20100206, 'Laptop', 'Apple MacBook Pro', 1, 1),
( 20100464, 'Laptop', 'Apple MacBook Pro', 1, 1),
( 20100217, 'Laptop', 'Apple MacBook Pro', 1, 1),
( 20108969, 'Laptop', 'Apple MacBook Pro', 1, 1);

INSERT INTO Members(FirstName, LastName, Gender, GradYear, Email, AssetID, LabID) VALUES
('Jeremy', 'Nielson', 'Male', 'SP19', 'saktirshinu@gmail.com', 1, 1),
('Sean', 'Wallace', 'Male', 'SP20', 'walis846@gmail.com', 2, 1),
('Cole', 'Braswell', 'Male', 'SP20', 'braswellcole@outlook.com', 3, 1),
('Cody', 'Knight', 'Male', 'SP19', 'pulse14@live.com', 4, 1),
('Michael', 'Pacyga', 'Male', 'SP20', 'michagy@gmail.com', 5, 1);
('Rick', 'Danger', 'Male', 'SP20', 'example@fake.com', NULL, 1);

INSERT INTO Role(Type, Status, Description, Date, MemberID) VALUES
('Intern', 'Full-time hire', 'Has accepted full time position at DFS. Expected to work following graduation', '2019-2-12', 1),
('Intern', 'Active', 'Working second semester at code_orange', '2019-2-14', 2),
('Intern', 'Active', 'First semester at code_orange', '2019-2-14', 3),
('Intern', 'Active', 'First semester at code_orange. Graduates Spring 2019', '2019-2-14', 4),
('Open House', 'Active', 'Has visited the code_orange Open House and expressed interest', '2019-2-27', 5);

INSERT INTO Semesters(Semester, Year, MemberID) VALUES
('Fall', 2018, 1),
('Spring', 2019, 1),
('Fall', 2018, 2),
('Spring', 2019, 2),
('Spring', 2019, 3),
('Spring', 2019, 4);

INSERT INTO Teams(TeamName, PO, Mentor, Semester, LabID) VALUES
('Team11', 'Mike Brenner', 'Jeremy Nielson', 'SP19', 1);

INSERT INTO TeamMembers(TeamID, MemberID) VALUES
(1, 1),
(1, 2),
(1, 3),
(1, 4);

INSERT INTO Projects(Name, Type, Description, TeamID) VALUES
('Applicant Tracking & Dashboard', 'Website', 'Keep track of all applicants, interns, and hires from the code_orange project', 1);
