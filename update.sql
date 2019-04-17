DROP TABLE IF EXISTS Delegations;
DROP TABLE IF EXISTS ApprovalsHistory;

CREATE TABLE Delegations
(DelegationID int auto_increment PRIMARY KEY,
Delegator LONG VARCHAR,
Email VARCHAR(320),
Delegatee LONG VARCHAR,
StartDate DATE,
EndDate DATE,
Description VARCHAR(255),
State INT,
Status VARCHAR(255));

CREATE TABLE ApprovalsHistory
(ApprovalID int auto_increment PRIMARY KEY,
Email VARCHAR(320),
FullName LONG VARCHAR,
Service VARCHAR(512),
Description VARCHAR(255),
RequestedBy LONG VARCHAR,
RequestDate DATE,
CloseDate DATE,
Status VARCHAR(255));

SET foreign_key_checks = 0;

UPDATE Teams SET PhotoPath = "Scurvy.jpg" WHERE TeamID = 1;
UPDATE Teams SET PhotoPath = "X.jpg" WHERE TeamID = 2;
UPDATE Teams SET PhotoPath = "Triton_FA18.jpg" WHERE TeamID = 3;
UPDATE Teams SET PhotoPath = "aVendors_FA18.jpg" WHERE TeamID = 4;
UPDATE Teams SET PhotoPath = "Wi-fiVe.jpg" WHERE TeamID = 5;
UPDATE Teams SET PhotoPath = "EtConfusaNovum.jpg" WHERE TeamID = 6;
UPDATE Teams SET PhotoPath = "777_FA18.jpg" WHERE TeamID = 7;
UPDATE Teams SET PhotoPath = "Atlas.jpg" WHERE TeamID = 8;
UPDATE Teams SET PhotoPath = "Dragon_Riders.jpg" WHERE TeamID = 9;
UPDATE Teams SET PhotoPath = "Triton_SP19.jpg" WHERE TeamID = 10;
UPDATE Teams SET Teamame = "aVendors", PhotoPath = "aVendors_SP19.jpg" WHERE TeamID = 11;
UPDATE Teams SET PhotoPath = "Covrt.jpg" WHERE TeamID = 12;
UPDATE Teams SET PhotoPath = "Six.jpg" WHERE TeamID = 13;
UPDATE Teams SET PhotoPath = "777_SP19.jpg" WHERE TeamID = 14;
UPDATE Teams SET PhotoPath = "Xbox_360.jpg" WHERE TeamID = 15;
UPDATE Teams SET PhotoPath = "Pulse.jpg" WHERE TeamID = 16;
UPDATE Teams SET PhotoPath = "Don_Juan.jpg" WHERE TeamID = 17;
UPDATE Teams SET PhotoPath = "EpicGamerz.jpg" WHERE TeamID = 5;
UPDATE Teams SET PhotoPath = "12_Bricks.jpg" WHERE TeamID = 5;
UPDATE Teams SET PhotoPath = "ARMatey.jpg" WHERE TeamID = 5;

UPDATE Projects SET BackEnd = "Node.JS" WHERE ProjectID = 12;
UPDATE Projects SET BackEnd = "Node.JS" WHERE ProjectID = 19;

SET foreign_key_checks = 1;
