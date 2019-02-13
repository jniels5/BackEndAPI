DROP TABLE IF EXISTS Projets;
DROP TABLE IF EXISTS TeamMembers;
DROP TABLE IF EXISTS Teams;
DROP TABLE IF EXISTS Semesters;
DROP TABLE IF EXISTS Role;
DROP TABLE IF EXISTS Members;
DROP TABLE IF EXISTS Assets;
DROP TABLE IF EXISTS Metrics;
DROP TABLE IF EXISTS Preferences;
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

CREATE TABLE Preferences
(PrefID int auto_increment PRIMARY KEY,
NavColor CHAR(6),
AcctID int,
FOREIGN KEY (AcctID) REFERENCES Accounts(AcctID));

CREATE TABLE Metrics
(MetID int auto_increment PRIMARY KEY,
Type VARCHAR(25),
Description VARCHAR(50),
IsActive BOOLEAN,
PrefID int,
FOREIGN KEY (PrefID) REFERENCES Preferences(PrefID));

INSERT INTO Accounts( Username, Password, FirstName, LastName, Role) VALUES
('mbrenner2', 'password', 'Mike', 'Brenner', 'Write');

INSERT INTO Labs(Abbrev, School, City, State) VALUES
('NIU', 'Northern Illinois University', 'Dekalb', 'IL');

INSERT INTO AccountLabs(AcctID, LabID) VALUES
(1, 1);

INSERT INTO Preferences(NavColor, AcctID) VALUES
('202020', 1);

INSERT INTO Metrics(Type, Description, IsActive, PrefID) VALUES
('Total', 'Number of students', 1, 1);
