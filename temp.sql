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
(MemberID int auto_increment PRIMARY KEY,
FirstName VARCHAR(20),
LastName VARCHAR(20),
Gender VARCHAR(15),
GradSemester VARCHAR(6),
GradYear int,
Email VARCHAR(320),
WorkEmail VARCHAR(320),
Major VARCHAR(75),
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

CREATE TABLE Teams
(TeamID int PRIMARY KEY,
TeamName VARCHAR(20),
TeamNumber int,
Semester VARCHAR(4),
PhotoPath VARCHAR(100),
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
Description VARCHAR(150),
Paragraph VARCHAR(500),
FrontEnd VARCHAR(50),
BackEnd VARCHAR(50),
RDS VARCHAR(50),
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
(10000000, 'N/A', 'N/a', 0, 1),
(20100206, 'Laptop', 'Apple MacBook Pro', 1, 1),
(20100464, 'Laptop', 'Apple MacBook Pro', 1, 1),
(20100217, 'Laptop', 'Apple MacBook Pro', 1, 1),
(20108969, 'Laptop', 'Apple MacBook Pro', 1, 1),
(20108939, 'Laptop', 'Apple MacBook Pro', 1, 1);

INSERT INTO Assets(AssetID, Type, Description, IsImaged, LabID) VALUES
(20100189, 'Laptop', 'Apple MacBook Pro', 1, 1),
(20108961, 'Laptop', 'Apple MacBook Pro', 1, 1),
(20108974, 'Laptop', 'Apple MacBook Pro', 1, 1),
(20100192, 'Laptop', 'Apple MacBook Pro', 1, 1),
(20108549, 'Laptop', 'Apple MacBook Pro', 1, 1),
(20100202, 'Laptop', 'Apple MacBook Pro', 1, 1),
(20108972, 'Laptop', 'Apple MacBook Pro', 1, 1),
(20108945, 'Laptop', 'Apple MacBook Pro', 1, 1),
(20100200, 'Laptop', 'Apple MacBook Pro', 1, 1),
(20108973, 'Laptop', 'Apple MacBook Pro', 1, 1),
(20100191, 'Laptop', 'Apple MacBook Pro', 1, 1),
(20100186, 'Laptop', 'Apple MacBook Pro', 1, 1),
(20100212, 'Laptop', 'Apple MacBook Pro', 1, 1),
(20100198, 'Laptop', 'Apple MacBook Pro', 1, 1),
(20100465, 'Laptop', 'Apple MacBook Pro', 1, 1),
(20108944, 'Laptop', 'Apple MacBook Pro', 1, 1),
(20100205, 'Laptop', 'Apple MacBook Pro', 1, 1),
(20108964, 'Laptop', 'Apple MacBook Pro', 1, 1),
(20108955, 'Laptop', 'Apple MacBook Pro', 1, 1),
(20100182, 'Laptop', 'Apple MacBook Pro', 1, 1),
(20100187, 'Laptop', 'Apple MacBook Pro', 1, 1),
(20100190, 'Laptop', 'Apple MacBook Pro', 1, 1),
(20108956, 'Laptop', 'Apple MacBook Pro', 1, 1),
(20100201, 'Laptop', 'Apple MacBook Pro', 1, 1),
(20108975, 'Laptop', 'Apple MacBook Pro', 1, 1),
(20108947, 'Laptop', 'Apple MacBook Pro', 1, 1),
(20100184, 'Laptop', 'Apple MacBook Pro', 1, 1),
(20108942, 'Laptop', 'Apple MacBook Pro', 1, 1),
(20100199, 'Laptop', 'Apple MacBook Pro', 1, 1),
(20108940, 'Laptop', 'Apple MacBook Pro', 1, 1),
(20110944, 'Laptop', 'Apple MacBook Pro', 1, 1),
(20108946, 'Laptop', 'Apple MacBook Pro', 1, 1),
(20100208, 'Laptop', 'Apple MacBook Pro', 1, 1),
(20100203, 'Laptop', 'Apple MacBook Pro', 1, 1),
(20100219, 'Laptop', 'Apple MacBook Pro', 1, 1),
(20108971, 'Laptop', 'Apple MacBook Pro', 1, 1),
(20108959, 'Laptop', 'Apple MacBook Pro', 1, 1),
(20108938, 'Laptop', 'Apple MacBook Pro', 1, 1),
(20108941, 'Laptop', 'Apple MacBook Pro', 1, 1),
(20100204, 'Laptop', 'Apple MacBook Pro', 1, 1),
(20100193, 'Laptop', 'Apple MacBook Pro', 1, 1),
(20100188, 'Laptop', 'Apple MacBook Pro', 1, 1),
(20108960, 'Laptop', 'Apple MacBook Pro', 1, 1),
(20100214, 'Laptop', 'Apple MacBook Pro', 1, 1),
(20108948, 'Laptop', 'Apple MacBook Pro', 1, 1),
(20100194, 'Laptop', 'Apple MacBook Pro', 1, 1),
(20100181, 'Laptop', 'Apple MacBook Pro', 1, 1),
(20100210, 'Laptop', 'Apple MacBook Pro', 1, 1),
(20108977, 'Laptop', 'Apple MacBook Pro', 1, 1),
(20108950, 'Laptop', 'Apple MacBook Pro', 1, 1),
(20108968, 'Laptop', 'Apple MacBook Pro', 1, 1),
(20108958, 'Laptop', 'Apple MacBook Pro', 1, 1),
(20100195, 'Laptop', 'Apple MacBook Pro', 1, 1),
(20100216, 'Laptop', 'Apple MacBook Pro', 1, 1),
(20108957, 'Laptop', 'Apple MacBook Pro', 1, 1),
(20108976, 'Laptop', 'Apple MacBook Pro', 1, 1),
(20108953, 'Laptop', 'Apple MacBook Pro', 1, 1),
(20100183, 'Laptop', 'Apple MacBook Pro', 1, 1),
(20100180, 'Laptop', 'Apple MacBook Pro', 1, 1),
(20100209, 'Laptop', 'Apple MacBook Pro', 1, 1),
(20100197, 'Laptop', 'Apple MacBook Pro', 1, 1),
(20100196, 'Laptop', 'Apple MacBook Pro', 1, 1),
(20108963, 'Laptop', 'Apple MacBook Pro', 1, 1),
(20100207, 'Laptop', 'Apple MacBook Pro', 1, 1),
(20100211, 'Laptop', 'Apple MacBook Pro', 1, 1),
(20108943, 'Laptop', 'Apple MacBook Pro', 1, 1),
(20108951, 'Laptop', 'Apple MacBook Pro', 1, 1),
(20108949, 'Laptop', 'Apple MacBook Pro', 1, 1),
(20100213, 'Laptop', 'Apple MacBook Pro', 1, 1),
(20108966, 'Laptop', 'Apple MacBook Pro', 1, 1),
(20100215, 'Laptop', 'Apple MacBook Pro', 1, 1);

/* FA18 Starting Interns */
INSERT INTO Members(FirstName, LastName, Gender, GradSemester, GradYear, Email, WorkEmail, AssetID, LabID) VALUES
('Jeremy', 'Nielson', 'Male', 'Spring', 2019, 'saktirshinu@gmail.com', 'jeremynielson@discover.com', 20100206, 1),
('Brady', 'Goldsworthy', 'Male', 'Spring', 2019, 'goldsworthybrady@gmail.com', 'bradygoldsworthy@discover.com', 10000000, 1),
('Justin', 'Dupre', 'Male', NULL , NULL, 'jdupre@niu.edu', 'justindupre@discover.com', 10000000, 1),
('Bradley', 'Protano', 'Male', 'Fall', 2018, NULL, 'bradleyprotano@discover.com', 10000000, 1),
('Katie', 'Berendt', 'Female', 'Fall', 2019, 'kber0167@gmail.com', 'katieberendt@discover.com', 10000000, 1),

('Jackie', 'Salim', 'Female', 'Spring', 2019, 'z1761458@students.niu.edu','jacquelinesalim@discover.com', 10000000, 1),
('Nahom', 'Gebremichael', 'Male', NULL, NULL, 'nahomgm@live.com', 'nahomgebremichael@discover.com', 10000000, 1),
('Thomas', 'Franczak', 'Male', NULL, NULL, 'tfranczak@niu.edu', 'thomasfranczak@discover.com', 10000000, 1),
('Kyle', 'Wilson', 'Male', NULL, NULL, NULL, 'kylewilson@discover.com', 10000000, 1),
('Sean', 'Wallace', 'Male', 'Spring', 2020, 'walis846@gmail.com', 'seanwallace@discover.com', 20100464, 1),

/*10*/
('Ben', 'Lane', 'Male', NULL, NULL, 'LiftPort@gmail.com', 'benlane@discover.com', 10000000, 1),
('Kevin', 'Miyata', 'Male', NULL, NULL, 'kjm015@yahoo.com', 'kevinmiyata@discover.com', 10000000, 1),
('James', 'Bonasera', 'Male', NULL, NULL, 'jabonasera@gmail.com', 'jamesbonasera@discover.com', 10000000, 1),
('Kris', 'Schrader', 'Female', NULL, NULL, 'krissschrader@gmail.com', 'krisschrader@discover.com', 10000000, 1),
('Samuel', 'Rutledge', 'Male', NULL, NULL, NULL, 'samuelrutledge@discover.com', 10000000, 1),

('Nicholas', 'Swanson', 'Male', NULL, NULL, NULL, 'nicholasswanson@discover.com', 10000000, 1),
('Alex', 'Boyle', 'Male', NULL, NULL, 'aboyle75@gmail.com', 'alexboyle@discover.com', 10000000, 1),
('Amy', 'Jakopin', 'Female', NULL, NULL, 'amyjakopin@gmail.com', 'amyjakopin@discover.com', 10000000, 1),
('Andrew', 'Slade', 'Male', NULL, NULL, NULL, 'andrewslade@discover.com', 10000000, 1),
('Kristen', 'Arms', 'Female', NULL, NULL, 'kristena.etruscan@gmail.com', 'kristenarms@discover.com', 10000000, 1),

/*20*/
('Shiva', 'Singh', 'Male', NULL, NULL, 'shivasingh@outlook.com', 'shivasingh@discover.com', 10000000, 1),
('Dylan', 'Drake', 'Male', NULL, NULL, 'dyldrake21@gmail.com', 'dylandrake@discover.com', 10000000, 1),
('Jane', 'Swift', 'Female', NULL, NULL, 'j.e.swift711@gmail.com', 'janeswift@discover.com', 10000000, 1),
('Kwaku', 'Agyemang', 'Male', NULL, NULL, 'mynhiz@gmail.com', 'kwakuagyemang@discover.com', 10000000, 1),
('Nathanael', 'Isola', 'Male', NULL, NULL, NULL, 'nathanaelisola@discover.com', 10000000, 1),

('Quinton', 'Lee', 'Male', NULL, NULL, 'quivistis@gmail.com', 'quintonlee@discover.com', 10000000, 1),
('Adam', 'Remes', 'Male', NULL, NULL, 'adam.j.remes@gmail.com', 'adamremes@discover.com', 10000000, 1),
('Elly', 'Jdaidany', 'Male', NULL, NULL, 'ellyjda@gmail.com', 'ellyjdaidany@discover.com', 10000000, 1),
('Jessica', 'Guenther', 'Female', NULL, NULL, 'jessica.h.guenther@gmail.com', 'jessicaguenther@discover.com', 10000000, 1),
('Spencer', 'Yoder', 'Male', NULL, NULL, NULL, 'spenceryoder@discover.com', 10000000, 1),

/*30*/
('Vishy', 'Singh', 'Male', NULL, NULL, 'vishysingh@outlook.com', 'vishysingh@discover.com', 10000000, 1),
('Nicholas', 'Glaviano', 'Male', NULL, NULL, NULL, 'nicholasglaviano@discover.com', 10000000, 1),
('Javier', 'Gomez', 'Male', NULL, NULL, NULL, 'javiergomez@discover.com', 10000000, 1),
('Cameron', 'Badenoch', 'Male', NULL, NULL, 'cam_badenoch10@live.com', 'cameronbadenoch@discover.com', 10000000, 1),
('Krystal', 'McIntyre-Miller', 'Female', NULL, NULL, 'z1779194@students.niu.edu', 'krystalmcintyremiller@discover.com', 10000000, 1),

/*35*/
('Nicholas', 'Rosso', 'Male', NULL, NULL, 'nicholasrosso@comcast.net', 'nicholasrosso@discover.com', 10000000, 1),
('Tyler', 'Havener', 'Male', NULL, NULL, NULL, 'tylerhavener@discover.com', 10000000, 1);

/* SP19 Starting Interns */
INSERT INTO Members(FirstName, LastName, Gender, GradSemester, GradYear, Email, WorkEmail, AssetID, LabID) VALUES
('Alan', 'Fikar', 'Male', NULL, NULL, 'alan.fikar@gmail.com', 'alanfikar@discover.com', 10000000, 1),
('Matt', 'Blauw', 'Male', NULL, NULL, 'matthewjblauw@gmail.com', 'mattblauw@discover.com', 10000000, 1),
('Patrick', 'Klesyk', 'Male', NULL, NULL, 'pklesyk@gmail.com', 'patrickklesyk@discover.com', 10000000, 1),
('Lucas', 'Damler', 'Male', NULL, NULL, 'ldamler@gmail.com', 'lucasdamler@discover.com', 10000000, 1),

('Purvin', 'Patel', 'Male', NULL, NULL, 'purvin08@ieee.org', 'purvinpatel@discover.com', 10000000, 1),
('Smit', 'Patel', 'Male', NULL, NULL, 'mrsmitp16@gmail.com', 'smitpatel@discover.com', 10000000, 1),
('Connor', 'Petruzzi', 'Male', NULL, NULL, 'connor61095@comcast.net', 'connorpetruzzi@discover.com', 10000000, 1),
('Connor', 'Pekovic', 'Male', NULL, NULL, 'connorpekovic1@gmail.com', 'connorpekovic@discover.com', 10000000, 1),

('Jennifer', 'Ho', 'Female', NULL, NULL, 'jennifer.ho30@gmail.com', 'jenniferho@discover.com', 10000000, 1),
('Akshay', 'Patel', 'Male', NULL, NULL, 'ap95@ieee.org', 'akshaypatel@discover.com', 10000000, 1),
('Cody', 'Farrey', 'Male', NULL, NULL, 'codyfarrey@gmail.com', 'codyfarrey@discover.com', 10000000, 1),
('Noah', 'Miller', 'Male', NULL, NULL, 'nmillercontact@gmail.com', 'noahmiller@discover.com', 10000000, 1),

('Kevin', 'Kang', 'Male', NULL, NULL, 'kevinfkang@gmail.com', 'kevinkang@discover.com', 10000000, 1),
('Marco', 'Martinez', 'Male', NULL, NULL, 'marco.antoni.martinez@gmail.com', 'marcomartinez@discover.com', 10000000, 1),
('Eduardo', 'Leanos', 'Male', NULL, NULL, 'edleanos@gmail.com', 'eduardoleanos@discover.com', 10000000, 1),
('Cody', 'McAntire', 'Male', NULL, NULL, 'z1859456@students.niu.edu', 'codymcantire@discover.com', 10000000, 1),

('Axil', 'Patel', 'Male', NULL, NULL, 'axil95@gmail.com', 'axilpatel@discover.com', 10000000, 1),
('Phillip', 'Boffa', 'Male', NULL, NULL, 'phillipboffa@gmail.com', 'phillipboffa@discover.com', 10000000, 1),
('Aaron', 'Jones', 'Male', NULL, NULL, 'aaroncjones17@gmail.com', 'aaronjones@discover.com', 10000000, 1),
('Anthony', 'Calcagno', 'Male', NULL, NULL, 'z1829706@students.niu.edu', 'anthonycalcagno@discover.com', 10000000, 1),

('Zachary', 'Hueneke', 'Male', NULL, NULL, 'zhueneke@gmail.com', 'zacharyhueneke@discover.com', 10000000, 1),
('Crystal', 'Ritchey', 'Female', NULL, NULL, 'crystalmritchey@gmail.com', 'crystalritchey@discover.com', 10000000, 1),
('Dean', 'LaBarbera', 'Male', NULL, NULL, 'deanmichaellabarbera@hotmail.com', 'deanbarbera@discover.com', 10000000, 1),
('Josh', 'Ruge', 'Male', NULL, NULL, 'joshruge@gmail.com', 'joshruge@discover.com', 10000000, 1),

('Jeremy', 'Torossian', 'Male', NULL, NULL, 'jtorossiananimation@gmail.com', 'jeremytorossian@discover.com', 10000000, 1),
('Tanner', 'Martin', 'Male', NULL, NULL, 'z1800126@students.niu.edu', 'tannermartin@discover.com', 10000000, 1),
('Aleena', 'Ahmad', 'Female', NULL, NULL, 'aleenaahmed85@gmail.com', 'aleenaahmed@discover.com', 10000000, 1),
('Daniel', "O'Malley", 'Male', NULL, NULL, 'daniel.omalley@live.com', 'danielomalley@discover.com', 10000000, 1),

('Byron', 'Hogan', 'Male', NULL, NULL, 'Z1825194@students.niu.edu', 'hoganbyron@discover.com', 10000000, 1),
('Charles', 'Dawes', 'Male', NULL, NULL, 'charliedawes@yahoo.com', 'charlesdawes@discover.com', 10000000, 1),
('Samuel', 'Piecz', 'Male', NULL, NULL, 'samuel.piecz@gmail.com', 'samuelpiecz@discover.com', 10000000, 1),
('Adelaide', 'Adams', 'Male', NULL, NULL, 'adelaide527@gmail.com', 'adelaideadams@discover.com', 10000000, 1),

('Kevin', 'Pallikunnel', 'Male', NULL, NULL, 'oapallikunnel@gmail.com', 'kevinpallikunnel@discover.com', 10000000, 1),
('Henry', 'Pelesh', 'Male', NULL, NULL, 'hjpelesh@gmail.com', 'henrypelesh@discover.com', 10000000, 1),
('Daniel', 'Facundo', 'Male', NULL, NULL, 'daniel8facundo@gmail.com', 'danielfacundo@discover.com', 10000000, 1),
('Angelo', 'Cruz', 'Male', NULL, NULL, 'angelo.t.cruz1@gmail.com', 'angelocruz@discover.com', 10000000, 1),

('Haley', 'Nuber', 'Male', NULL, NULL, 'haleynuber@gmail.com', 'haleynuber@discover.com', 10000000, 1),
('Uzair', 'Ahmed', 'Male', NULL, NULL, 'uzairmasood92@hotmail.com', 'uzairahmed@discover.com', 10000000, 1),
('Yousef', 'Saigh', 'Male', NULL, NULL, 'yousefsaigh@gmail.com', 'yousefsaigh@discover.com', 10000000, 1),
('Payton', 'Suchomel', 'Male', NULL, NULL, 'suchomelpayton@gmail.com', 'paytonsuchomel@discover.com', 10000000, 1),

('Cole', 'Braswell', 'Male', 'Spring', 2020, 'braswellcole@outlook.com', 'colebraswell@discover.com', 20100217, 1),
('Cody', 'Knight', 'Male', 'Spring', 2019, 'pulse14@live.com', 'codyknight@discover.com', 20108969, 1),
('Michael', 'Pacyga', 'Male', 'Spring', 2020, 'michagy@gmail.com', 'michaelpacyga@discover.com', 20108939, 1),

('Kenneth', 'Nguyen', 'Male', NULL, NULL, 'kennethtringuyen@gmail.com', 'kennethnguyen@discover.com', 10000000, 1),
('Dishant', 'Patel', 'Male', NULL, NULL, 'pateldishant17@gmail.com', 'dishantpatel@discover.com', 10000000, 1),
('Edgar', 'Villafuente', 'Male', NULL, NULL, 'edgar.villafuente96@gmail.com', 'edgarvillafuente@discover.com', 10000000, 1),
('Aivree', 'Gomez', 'Male', NULL, NULL, 'aivree@live.com', 'aivreegomez@discover.com', 10000000, 1),

('Mohammad', 'Khan', 'Male', NULL, NULL, 'z1819675@students.niu.edu', 'mohammadkhan@discover.com', 10000000, 1),
('Harshita', 'Kothamasu', 'Female', NULL, NULL, 'harshitakoth11@gmail.com', 'harshitakothamasu@discover.com', 10000000, 1),
('Gonzalo', 'Pantoja', 'Male', NULL, NULL, 'gonzalopantoja@ieee.org', 'gonzalopantoja@discover.com', 10000000, 1),
('Adithya', 'Attavane', 'Male', NULL, NULL, 'aattavane1@niu.edu', 'adithyaattavane@discover.com', 10000000, 1),

('Mike', 'Brenner', 'Male', NULL, NULL, NULL, 'michaelbrenner@discover.com', 10000000, 1);

INSERT INTO Role(Type, Status, Description, Date, MemberID) VALUES
('Intern', 'Full-time hire', 'Has accepted full time position at DFS', '2019-2-12', 1),
('Intern', 'Active', 'Working second semester at code_orange', '2019-2-14', 2),
('Intern', 'Active', 'First semester at code_orange', '2019-2-14', 3),
('Intern', 'Active', 'First semester at code_orange.', '2019-2-14', 4),
('Intern', 'Active', 'First semester at code_orange.', '2019-2-14', 5),
('Intern', 'Active', 'Working second semester at code_orange', '2019-2-14', 6),
('Intern', 'Active', 'Working second semester at code_orange', '2019-2-14', 7),
('Intern', 'Active', 'Working second semester at code_orange', '2019-2-14', 8),
('Former Intern', 'Full-Time', 'Mentor for Team 8', '2019-2-14', 9),
('Intern', 'Active', 'Working second semester at code_orange', '2019-2-14', 10),
('Intern', 'Active', 'Working second semester at code_orange', '2019-2-14', 11),
('Intern', 'Active', 'Working second semester at code_orange', '2019-2-14', 12),
('Intern', 'Active', 'Working second semester at code_orange', '2019-2-14', 13),
('Former Intern', 'Unknown', 'Working second semester', '2019-2-14', 14),
('Intern', 'Active', 'Working second semester at code_orange', '2019-2-14', 15),
('Intern', 'Active', 'Working second semester at code_orange', '2019-2-14', 16),
('Intern', 'Active', 'Working second semester at code_orange', '2019-2-14', 17),
('Intern', 'Active', 'Working second semester at code_orange', '2019-2-14', 18),
('Former Intern', 'Unknown', 'Worked one semester', '2019-2-14', 19),
('Former Intern', 'Unknown', 'Worked one semester', '2019-2-14', 20),
('Intern', 'Active', 'Working second semester at code_orange', '2019-2-14', 21),
('Intern', 'Active', 'Working second semester at code_orange', '2019-2-14', 22),
('Former Intern', 'Grad Student', 'Worked one semester. Focusing on degree.', '2019-2-14', 23),
('Intern', 'Active', 'Working second semester at code_orange', '2019-2-14', 24),
('Intern', 'Active', 'Working second semester at code_orange', '2019-2-14', 25),
('Intern', 'Active', 'Working second semester at code_orange', '2019-2-14', 26),
('Intern', 'Active', 'Working second semester at code_orange', '2019-2-14', 27),
('Intern', 'Active', 'Working second semester at code_orange', '2019-2-14', 28),
('Former Intern', 'Unknown', 'Working second semester at code_orange', '2019-2-14', 29),
('Intern', 'Active', 'Working second semester at code_orange', '2019-2-14', 30),
('Intern', 'Active', 'Working second semester at code_orange', '2019-2-14', 31),
('Intern', 'Active', 'Working second semester at code_orange', '2019-2-14', 32),
('Intern', 'Active', 'Working second semester at code_orange', '2019-2-14', 33),
('Former Intern', 'Unknown', 'Worked one semester', '2019-2-14', 34),
('Intern', 'Active', 'Working second semester at code_orange', '2019-2-14', 35),
('Former Intern', 'Unknown', 'Worked one semester', '2019-2-14', 36),
('Former Intern', 'Unknown', 'Worked one semester', '2019-2-14', 37),
('Intern', 'Active', 'Working second semester at code_orange', '2019-2-14', 38),
('Intern', 'Active', 'Working second semester at code_orange', '2019-2-14', 39),
('Intern', 'Active', 'Working second semester at code_orange', '2019-2-14', 40),
('Former Intern', 'Inactive', 'Not brought back', '2019-2-14', 41),
('Intern', 'Active', 'Working first semester.', '2019-2-14', 42),
('Intern', 'Active', 'Working first semester.', '2019-2-14', 43),
('Intern', 'Active', 'Working first semester.', '2019-2-14', 44),
('Intern', 'Active', 'Working first semester.', '2019-2-14', 45),
('Intern', 'Active', 'Working first semester.', '2019-2-14', 46),
('Intern', 'Active', 'Working first semester.', '2019-2-14', 47),
('Intern', 'Active', 'Working first semester.', '2019-2-14', 48),
('Intern', 'Active', 'Working first semester.', '2019-2-14', 49),
('Intern', 'Active', 'Working first semester.', '2019-2-14', 50),
('Intern', 'Active', 'Working first semester.', '2019-2-14', 51),
('Intern', 'Active', 'Working first semester.', '2019-2-15', 52),
('Intern', 'Active', 'Working first semester.', '2019-2-15', 53),
('Intern', 'Active', 'Working first semester.', '2019-2-15', 54),
('Intern', 'Active', 'Working first semester.', '2019-2-15', 55),
('Intern', 'Active', 'Working first semester.', '2019-2-15', 56),
('Intern', 'Active', 'Working first semester.', '2019-2-15', 57),
('Intern', 'Active', 'Working first semester.', '2019-2-15', 58),
('Intern', 'Active', 'Working first semester.', '2019-2-15', 59),
('Intern', 'Active', 'Working first semester.', '2019-2-15', 60),
('Intern', 'Active', 'Working first semester.', '2019-2-15', 61),
('Intern', 'Active', 'Working first semester.', '2019-2-15', 62),
('Intern', 'Active', 'Working first semester.', '2019-2-15', 63),
('Intern', 'Active', 'Working first semester.', '2019-2-15', 64),
('Intern', 'Active', 'Working first semester.', '2019-2-15', 65),
('Intern', 'Active', 'Working first semester.', '2019-2-15', 66),
('Intern', 'Active', 'Working first semester.', '2019-2-15', 67),
('Intern', 'Active', 'Working first semester.', '2019-2-15', 68),
('Intern', 'Active', 'Working first semester.', '2019-2-15', 69),
('Intern', 'Active', 'Working first semester.', '2019-2-15', 70),
('Intern', 'Active', 'Working first semester.', '2019-2-15', 71),
('Intern', 'Active', 'Working first semester.', '2019-2-15', 72),
('Intern', 'Active', 'Working first semester.', '2019-2-15', 73),
('Intern', 'Active', 'Working first semester.', '2019-2-15', 74),
('Intern', 'Active', 'Working first semester.', '2019-2-15', 75),
('Intern', 'Active', 'Working first semester.', '2019-2-15', 76),
('Intern', 'Active', 'Working first semester.', '2019-2-15', 77),
('Intern', 'Active', 'Working first semester.', '2019-2-15', 78),
('Intern', 'Active', 'Working first semester.', '2019-2-15', 79),
('Intern', 'Active', 'Working first semester.', '2019-2-15', 80),
('Intern', 'Active', 'Working first semester.', '2019-2-15', 81),
('Intern', 'Active', 'Working first semester.', '2019-2-15', 82),
('Intern', 'Active', 'Working first semester.', '2019-2-15', 83),
('Intern', 'Active', 'Working first semester.', '2019-2-15', 84),
('Intern', 'Active', 'Working first semester.', '2019-2-15', 85),
('Intern', 'Active', 'Working first semester.', '2019-2-15', 86),
('Intern', 'Active', 'Working first semester.', '2019-2-15', 87),
('Intern', 'Active', 'Working first semester.', '2019-2-15', 88),
('Product Owner', 'Active', 'Manages Team 11 and the Lab', '2019-2-15', 89);

INSERT INTO Teams(TeamID, TeamName, TeamNumber, Semester, PhotoPath, LabID) VALUES
(1, 'Scurvy', 1, 'FA18', '../Assets/Teams/FA18/GroupPhoto/thebestteam (2 of 3) compressed.JPG', 1),
(2, 'Team X', 2, 'FA18', '../Assets/Teams/FA18/GroupPhoto/Team2.JPG', 1),
(3, 'Triton', 3, 'FA18', '../Assets/Teams/FA18/GroupPhoto/Team3.JPG', 1),
(4, 'aVendors', 4, 'FA18', '../Assets/Teams/FA18/GroupPhoto/Team4.JPG', 1),
(5, 'Wi-fiVe', 5, 'FA18', '../Assets/Teams/FA18/GroupPhoto/Team5.JPG', 1),
(6, 'Et Confusa Novum', 6, 'FA18', '../Assets/Teams/FA18/GroupPhoto/Team6.JPG', 1),
(7, 'Team 777', 7, 'FA18', '../Assets/Teams/FA18/GroupPhoto/Team7.JPG', 1),
(8, 'Atlas', 1, 'SP19', '../Assets/Teams/SP19/GroupPhoto/default.JPG', 1),
(9, 'Dragon Riders', 2, 'SP19', '../Assets/Teams/SP19/GroupPhoto/default.JPG', 1),
(10, 'Triton', 3, 'SP19', '../Assets/Teams/SP19/GroupPhoto/default.JPG', 1),
(11, 'Team 4', 4, 'SP19', '../Assets/Teams/SP19/GroupPhoto/default.JPG', 1),
(12, 'Team Covrt', 5, 'SP19', '../Assets/Teams/SP19/GroupPhoto/default.JPG', 1),
(13, 'Team 6', 6, 'SP19',  '../Assets/Teams/SP19/GroupPhoto/default.JPG', 1),
(14, 'Team 777', 7, 'SP19',  '../Assets/Teams/SP19/GroupPhoto/default.JPG', 1),
(15, 'Xbox_360', 8, 'SP19', '../Assets/Teams/SP19/GroupPhoto/default.JPG', 1),
(16, 'Team Pulse', 9, 'SP19', '../Assets/Teams/SP19/GroupPhoto/default.JPG', 1),
(17, 'Don Juan', 10, 'SP19', '../Assets/Teams/SP19/GroupPhoto/default.JPG', 1),
(18, 'Epic Gamerz', 11, 'SP19', '../Assets/Teams/SP19/GroupPhoto/default.JPG', 1),
(19, '12Bricks', 12,'SP19', '../Assets/Teams/SP19/GroupPhoto/default.JPG', 1),
(20, 'Team AR Matey', 13, 'SP19', '../Assets/Teams/SP19/GroupPhoto/default.JPG', 1);

INSERT INTO TeamMembers(TeamID, MemberID) VALUES
(1, 1), (1, 2), (1, 3), (1, 4), (1, 5),
(2, 6), (2, 7), (2, 8), (2, 9), (2, 10),
(3, 11), (3, 12), (3, 13), (3, 14), (3, 15), (3, 16),
(4, 17), (4, 18), (4, 19), (4, 20),(4, 21),
(5, 22), (5, 23), (5, 24), (5, 25), (5, 26),
(6, 27), (6, 28), (6, 29), (6, 30), (6, 31), (6, 32),
(7, 33), (7, 34), (7, 35), (7, 36), (7, 37),

/*SP19*/
(8, 38), (8, 39), (8, 40), (8, 41), (8, 23), (8, 22),
(9, 28), (9, 42), (9, 43), (9, 44), (9, 45), (9, 29), (9, 8),
(10, 46), (10, 47), (10, 48), (10, 49), (10, 11), (10, 12),
(11, 50), (11, 51), (11, 52), (11, 53), (11, 21), (11, 20),
(12, 54), (12, 55), (12, 56), (12, 57), (12, 13), (12, 18),
(13, 58), (13, 59), (13, 60), (13, 61), (13, 24), (13, 17),
(14, 62), (14, 63), (14, 64), (14, 65), (14, 34), (14, 35),
(15, 66), (15, 67), (15, 68), (15, 69), (15, 36), (15, 5),
(16, 70), (16, 71), (16, 72), (16, 73), (16, 14), (16, 3),
(17, 74), (17, 75), (17, 76), (17, 77), (17, 2), (17, 27),
(18, 1), (18, 10), (18, 78), (18, 79), (18, 80),
(19, 81), (19, 82), (19, 83), (19, 84), (19, 7), (19, 6),
(20, 85), (20, 86), (20, 87), (20, 88), (20, 26), (20, 31);

INSERT INTO Projects(Name, Type, Description, Paragraph, FrontEnd, BackEnd, RDS, TeamID) VALUES
('code_orange Website', 'Website', 'Program Information: description, projects, employment, upcoming events, etc', 'The code_orange website is designed to be the face of the lab as it is outward facing. Anyone can check out the website and learn about the lab, ongoing projects, and how to apply to the program. We built everything you see right now!', 'React', 'Node.JS', 'MySQL', 1),
('Feedback Bubbles', 'Mobile App', 'App to allow feedback for meeting attendees', 'This app is intended to be used in conjunction with conferences. Users will have the app on their phone and connect to the specific conference via iBeacon. Here users can submit feedback bubbles (context dependent).', 'React-Native', 'Node.JS', 'MySQL', 2),
('Talent Acquisition', 'Mobile App', 'Capture Candidate info (resume, etc) electronically, replacing paperwork', 'An app is currently being created to aid in Discover job fairs. Users will be able to essentially create a quick submission of their photo, some basic information, and their resume. This allows better electronic transmission of information and faster processing.', 'React', 'Node.JS', 'MySQL', 3),
('Vendor Contact History Website', 'Website', 'Tool to track/update vendor info across Discover', 'This application is intended to alleviate and aid in the management of vendor contact information. They are creating a better system in which this information is kept, managed, and updated.', 'Angular', 'Springboot', 'MySQL', 4);
('Mgmt Approal/Delegation Tool', 'Website', 'One site for management to get all todo items needing action/decision', 'A better tool for management is being developed to aid in tracking changes and important scheduling that requires manager approval. This will allow managers to operate and monitor these schedules in one place.', 'React', 'Node.JS', 'MySQL', 5);

UPDATE Members SET AssetID = 20100189 WHERE MemberID = 2;
UPDATE Members SET AssetID = 20108961 WHERE MemberID = 74;
UPDATE Members SET AssetID = 20108974 WHERE MemberID = 76;
UPDATE Members SET AssetID = 20100192 WHERE MemberID = 75;
UPDATE Members SET AssetID = 20108594 WHERE MemberID = 77;
UPDATE Members SET AssetID = 20100202 WHERE MemberID = 27;
UPDATE Members SET AssetID = 20108972 WHERE MemberID = 57;
UPDATE Members SET AssetID = 20108945 WHERE MemberID = 54;
UPDATE Members SET AssetID = 20100200 WHERE MemberID = 13;
UPDATE Members SET AssetID = 20108973 WHERE MemberID = 56;
UPDATE Members SET AssetID = 20100191 WHERE MemberID = 18;
UPDATE Members SET AssetID = 20100186 WHERE MemberID = 38;
UPDATE Members SET AssetID = 20100212 WHERE MemberID = 23;
UPDATE Members SET AssetID = 20100198 WHERE MemberID = 22;
UPDATE Members SET AssetID = 20100465 WHERE MemberID = 41;
UPDATE Members SET AssetID = 20108944 WHERE MemberID = 40;
UPDATE Members SET AssetID = 20100205 WHERE MemberID = 39;
UPDATE Members SET AssetID = 20108964 WHERE MemberID = 70;
UPDATE Members SET AssetID = 20108955 WHERE MemberID = 73;
UPDATE Members SET AssetID = 20100182 WHERE MemberID = 14;
UPDATE Members SET AssetID = 20100187 WHERE MemberID = 3;
UPDATE Members SET AssetID = 20100190 WHERE MemberID = 72;
UPDATE Members SET AssetID = 20108956 WHERE MemberID = 71;
UPDATE Members SET AssetID = 20100201 WHERE MemberID = 28;
UPDATE Members SET AssetID = 20108947 WHERE MemberID = 42;
UPDATE Members SET AssetID = 20100184 WHERE MemberID = 29;
UPDATE Members SET AssetID = 20108942 WHERE MemberID = 44;
UPDATE Members SET AssetID = 20100199 WHERE MemberID = 8;
UPDATE Members SET AssetID = 20108940 WHERE MemberID = 43;
UPDATE Members SET AssetID = 20110994 WHERE MemberID = 48;
UPDATE Members SET AssetID = 20108946 WHERE MemberID = 47;
UPDATE Members SET AssetID = 20100208 WHERE MemberID = 12;
UPDATE Members SET AssetID = 20100203 WHERE MemberID = 11;
UPDATE Members SET AssetID = 20100219 WHERE MemberID = 49;
UPDATE Members SET AssetID = 20108971 WHERE MemberID = 46;
UPDATE Members SET AssetID = 20108959 WHERE MemberID = 52;
UPDATE Members SET AssetID = 20108938 WHERE MemberID = 50;
UPDATE Members SET AssetID = 20108941 WHERE MemberID = 51;
UPDATE Members SET AssetID = 20100204 WHERE MemberID = 20;
UPDATE Members SET AssetID = 20100193 WHERE MemberID = 21;
UPDATE Members SET AssetID = 20100188 WHERE MemberID = 24;
UPDATE Members SET AssetID = 20108960 WHERE MemberID = 61;
UPDATE Members SET AssetID = 20100214 WHERE MemberID = 17;
UPDATE Members SET AssetID = 20108948 WHERE MemberID = 60;
UPDATE Members SET AssetID = 20100194 WHERE MemberID = 59;
UPDATE Members SET AssetID = 20100181 WHERE MemberID = 58;
UPDATE Members SET AssetID = 20100210 WHERE MemberID = 34;
UPDATE Members SET AssetID = 20108977 WHERE MemberID = 63;
UPDATE Members SET AssetID = 20108950 WHERE MemberID = 62;
UPDATE Members SET AssetID = 20108968 WHERE MemberID = 64;
UPDATE Members SET AssetID = 20108958 WHERE MemberID = 65;
UPDATE Members SET AssetID = 20100195 WHERE MemberID = 35;
UPDATE Members SET AssetID = 20100216 WHERE MemberID = 36;
UPDATE Members SET AssetID = 20108957 WHERE MemberID = 68;
UPDATE Members SET AssetID = 20108976 WHERE MemberID = 69;
UPDATE Members SET AssetID = 20108953 WHERE MemberID = 66;
UPDATE Members SET AssetID = 20100183 WHERE MemberID = 5;
UPDATE Members SET AssetID = 20100180 WHERE MemberID = 67;
UPDATE Members SET AssetID = 20100209 WHERE MemberID = 83;
UPDATE Members SET AssetID = 20100197 WHERE MemberID = 7;
UPDATE Members SET AssetID = 20100196 WHERE MemberID = 81;
UPDATE Members SET AssetID = 20108963 WHERE MemberID = 82;
UPDATE Members SET AssetID = 20100207 WHERE MemberID = 6;
UPDATE Members SET AssetID = 20100211 WHERE MemberID = 84;