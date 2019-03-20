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
IsRead BOOLEAN,
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
(AssetID int PRIMARY KEY,
Type VARCHAR(25),
Description VARCHAR(50),
IsImaged boolean,
LabID int,
FOREIGN KEY (LabID) REFERENCES Labs(LabID));

CREATE TABLE Members
(MemberID int PRIMARY KEY,
FirstName VARCHAR(20),
LastName VARCHAR(20),
Gender VARCHAR(15),
GradSemester VARCHAR(6),
GradYear int,
Email VARCHAR(320),
WorkEmail VARCHAR(320),
AssetID int,
LabID int,
FOREIGN KEY (AssetID) REFERENCES Assets(AssetID),
FOREIGN KEY (LabID) REFERENCES Labs(LabID));

CREATE TABLE Role
(RoleID int PRIMARY KEY,
Type VARCHAR(25),
Status VARCHAR(25),
Description VARCHAR(255),
Date DATE,
MemberID int NOT NULL,
FOREIGN KEY (MemberID) REFERENCES Members(MemberID));

CREATE TABLE Teams
(TeamID int PRIMARY KEY,
TeamName VARCHAR(20),
TeamNumber int,
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

INSERT INTO Notifications(Type, Description, Name, Date, IsRead, AcctID) VALUES
('Alert', 'Updated Graduation Date', 'Jeremy Nielson', '2019-2-12', 0, 1),
('Alert', 'Added Phone Number', 'Sean Wallace', '2020-2-17', 1, 1);

INSERT INTO Preferences(NavColor, AcctID) VALUES
('#202020', 1);

INSERT INTO Metrics(Type, Description, IsActive, PrefID) VALUES
('Total', 'Number of students', 1, 1);

INSERT INTO Assets(AssetID, Type, Description, IsImaged, LabID) VALUES
( 20100206, 'Laptop', 'Apple MacBook Pro', 1, 1),
( 20100464, 'Laptop', 'Apple MacBook Pro', 1, 1),
( 20100217, 'Laptop', 'Apple MacBook Pro', 1, 1),
( 20108969, 'Laptop', 'Apple MacBook Pro', 1, 1),
( 12345678, 'Laptop', 'Apple MacBook Pro', 1, 1);

INSERT INTO Members(MemberID, FirstName, LastName, Gender, GradSemester, GradYear, Email, WorkEmail, AssetID, LabID) VALUES
(1, 'Jeremy', 'Nielson', 'Male', 'Spring', 2019, 'saktirshinu@gmail.com', 'jeremynielson@discover.com', 20100206, 1),
(2, 'Sean', 'Wallace', 'Male', 'Spring', 2020, 'walis846@gmail.com', 'seanwallace@discover.com', 20100464, 1),
(3, 'Cole', 'Braswell', 'Male', 'Spring', 2020, 'braswellcole@outlook.com', 'colebraswell@discover.com', 20100217, 1),
(4, 'Cody', 'Knight', 'Male', 'Spring', 2019, 'pulse14@live.com', 'codyknight@discover.com', 20108969, 1);

INSERT INTO Role(RoleID, Type, Status, Description, Date, MemberID) VALUES
(1, 'Intern', 'Full-time hire', 'Has accepted full time position at DFS. Expected to work following graduation', '2019-2-12', 1),
(2, 'Intern', 'Active', 'Working second semester at code_orange', '2019-2-14', 2),
(3, 'Intern', 'Active', 'First semester at code_orange', '2019-2-14', 3),
(4, 'Intern', 'Active', 'First semester at code_orange. Graduates Spring 2019', '2019-2-14', 4),
(5, 'Product Owner', 'Active', 'Product Owner for Team 11.', '2019-3-19', 5),
(6, 'Intern', 'Active', 'First semester at code_orange. Graduates Fall 2019', '2019-2-14', 42),
(7, 'Applicant', 'Submitted', 'Applicantion Submitted, awaiting approval', '2019-3-12', 43),
(8, 'Open House', 'Visited', 'Checked in at open house', '2019-3-12', 44);

INSERT INTO Teams(TeamID, TeamName, TeamNumber, Semester, LabID) VALUES
(1, 'Scurvy', 1, 'FA18', 1),
(2, 'Team X', 2, 'FA18', 1),
(3, 'Triton', 3, 'FA18', 1),
(4, 'aVendors', 4, 'FA18', 1),
(5, 'Wi-fiVe', 5, 'FA18', 1),
(6, 'Et Confusa Novum', 6, 'FA18', 1),
(7, 'Team 777', 7, 'FA18', 1),
(8, 'Atlas', 1, 'SP19', 1),
(9, 'Team2', 2, 'SP19', 1),
(10, 'Team3', 3, 'SP19', 1),
(11, 'Team4', 4, 'SP19', 1),
(12, 'Team5', 5, 'SP19', 1),
(13, 'Team6', 6, 'SP19', 1),
(14, 'Team7', 7, 'SP19', 1),
(15, 'Team8', 8, 'SP19', 1),
(16, 'Team9', 9, 'SP19', 1),
(17, 'Team10', 10, 'SP19', 1),
(18, 'Epic Gamerz', 11, 'SP19', 1),
(19, 'Team12', 12,'SP19', 1),
(20, 'Team13', 13, 'SP19', 1),
(21, 'Team14', 14, 'SP19', 1);

INSERT INTO TeamMembers(TeamID, MemberID) VALUES
(18, 1),
(18, 2),
(18, 3),
(18, 4),
(18, 5);

INSERT INTO Projects(Name, Type, Description, TeamID) VALUES
('NIU Lab Website', 'Website', 'Program Information: description, projects, employment, upcoming events, etc', 1),
('Feedback Bubbles', 'Mobile App', 'App to allow feedback for meeting attendees', 2),
('Talent Acquisition', 'Mobile App', 'Capture Candidate info (resume, etc) electronically, replacing paperwork', 3),
('Vendor Contact History Website', 'Website', 'Tool to track/update vendor info across Discover', 4),
('Mgmt Approal/Delegation Tool', 'Website', 'One site for management to get all todo items needing action/decision', 5),
('NIU Innovation App', 'Mobile App', 'Create app that allows students to connect within the space', 6),
('Change log rewrite', 'Website', 'Create change log to improve tracking of production impacting projects', 7),
('Applicant Tracking & Dashboard', 'Website', 'Keep track of all applicants, interns, and hires from the code_orange project', 18);
