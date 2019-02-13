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

INSERT INTO Accounts( Username, Password, FirstName, LastName, Role) VALUES
('mbrenner2', 'password', 'Mike', 'Brenner', 'Write');

INSERT INTO Labs(Abbrev, School, City, State) VALUES
('NIU', 'Northern Illinois University', 'Dekalb', 'IL');

INSERT INTO AccountLabs(AcctID, LabID) VALUES
(1, 1);
