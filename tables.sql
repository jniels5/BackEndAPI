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

INSERT INTO Members(FirstName, LastName, Gender, GradSemester, GradYear, Email, WorkEmail, AssetID, LabID) VALUES
('Jeremy', 'Nielson', 'Male', 'Spring', 2019, 'saktirshinu@gmail.com', 'jeremynielson@discover.com', 20100206, 1),
('Sean', 'Wallace', 'Male', 'Spring', 2020, 'walis846@gmail.com', 'seanwallace@discover.com', 20100464, 1),
('Cole', 'Braswell', 'Male', 'Spring', 2020, 'braswellcole@outlook.com', 'colebraswell@discover.com', 20100217, 1),
('Cody', 'Knight', 'Male', 'Spring', 2019, 'pulse14@live.com', 'codyknight@discover.com', 20108969, 1),
('Michael', 'Pacyga', 'Male', 'Spring', 2020, NULL, 'michaelpacyga@discover.com', 20108939, 1),
('Mike', 'Brenner', 'Male', NULL, NULL, NULL, 'michaelbrenner@discover.com', 10000000, 1),
('Brady', 'Goldsworthy', 'Male', 'Spring', 2019, NULL, 'bradygoldsworthy@discover.com', 10000000, 1),
('Justin', 'Dupre', 'Male', NULL , NULL, NULL, 'justindupre@discover.com', 10000000, 1),
('Bradley', 'Protano', 'Male', 'Fall', 2018, NULL, 'bradleyprotano@discover.com', 10000000, 1),
('Katie', 'Berendt', 'Female', 'Fall', 2019, NULL, 'katieberendt@discover.com', 10000000, 1),
('Jackie', 'Salim', 'Female', 'Spring', 2019, NULL,'jacquelinesalim@discover.com', 10000000, 1),
('Nahom', 'Gebremichael', 'Male', NULL, NULL, NULL, 'nahomgebremichael@discover.com', 10000000, 1),
('Thomas', 'Franczak', 'Male', NULL, NULL, NULL, 'thomasfranczak@discover.com', 10000000, 1),
('Kyle', 'Wilson', 'Male', NULL, NULL, NULL, 'kylewilson@discover.com', 10000000, 1),
('Ben', 'Lane', 'Male', NULL, NULL, NULL, 'benlane@discover.com', 10000000, 1),
('Kevin', 'Miyata', 'Male', NULL, NULL, NULL, 'kevimiyata@discover.com', 10000000, 1),
('James', 'Bonasera', 'Male', NULL, NULL, NULL, 'jamesbonasera@discover.com', 10000000, 1),
('Kris', 'Schrader', 'Female', NULL, NULL, NULL, 'krisschrader@discover.com', 10000000, 1),
('Samuel', 'Rutledge', 'Male', NULL, NULL, NULL, 'samuelrutledge@discover.com', 10000000, 1),
('Nicholas', 'Swanson', 'Male', NULL, NULL, NULL, 'nicholasswanson@discover.com', 10000000, 1),
('Alex', 'Boyle', 'Male', NULL, NULL, NULL, 'alexboyle@discover.com', 10000000, 1),
('Amy', 'Jakopin', 'Female', NULL, NULL, NULL, 'amyjakopin@discover.com', 10000000, 1),
('Andrew', 'Slade', 'Male', NULL, NULL, NULL, 'andrewslade@discover.com', 10000000, 1),
('Kristen', 'Arms', 'Female', NULL, NULL, NULL, 'kristenarms@discover.com', 10000000, 1),
('Shiva', 'Singh', 'Male', NULL, NULL, NULL, 'shivasingh@discover.com', 10000000, 1),
('Dylan', 'Drake', 'Male', NULL, NULL, NULL, 'dylandrake@discover.com', 10000000, 1),
('Jane', 'Swift', 'Female', NULL, NULL, NULL, 'janeswift@discover.com', 10000000, 1),
('Kwaku', 'Agyemang', 'Male', NULL, NULL, NULL, 'kwakuagyemang@discover.com', 10000000, 1),
('Nathanael', 'Isola', 'Male', NULL, NULL, NULL, 'nathanaelisola@discover.com', 10000000, 1),
('Quinton', 'Lee', 'Male', NULL, NULL, NULL, 'quintonlee@discover.com', 10000000, 1),
('Adam', 'Remes', 'Male', NULL, NULL, NULL, 'adamremes@discover.com', 10000000, 1),
('Elly', 'Jdaidany', 'Male', NULL, NULL, NULL, 'ellyjdaidany@discover.com', 10000000, 1),
('Jessica', 'Guenther', 'Female', NULL, NULL, NULL, 'jessicaguenther@discover.com', 10000000, 1),
('Spencer', 'Yoder', 'Male', NULL, NULL, NULL, 'spenceryoder@discover.com', 10000000, 1),
('Vishy', 'Singh', 'Male', NULL, NULL, NULL, 'vishysingh@discover.com', 10000000, 1),
('Nicholas', 'Glaviano', 'Male', NULL, NULL, NULL, 'nicholasglaviano@discover.com', 10000000, 1),
('Javier', 'Gomez', 'Male', NULL, NULL, NULL, 'javiergomez@discover.com', 10000000, 1),
('Cameron', 'Badenoch', 'Male', NULL, NULL, NULL, 'cameronbadenoch@discover.com', 10000000, 1),
('Krystal', 'McIntyre-Miller', 'Female', NULL, NULL, NULL, 'krystalmcintyremiller@discover.com', 10000000, 1),
('Nicholas', 'Rosso', 'Male', NULL, NULL, NULL, 'nicholasrosso@discover.com', 10000000, 1),
('Tyler', 'Havener', 'Male', NULL, NULL, NULL, 'tylerhavener@discover.com', 10000000, 1);

INSERT INTO Role(Type, Status, Description, Date, MemberID) VALUES
('Intern', 'Full-time hire', 'Has accepted full time position at DFS', '2019-2-12', 1),
('Intern', 'Active', 'Working second semester at code_orange', '2019-2-14', 2),
('Intern', 'Active', 'First semester at code_orange', '2019-2-14', 3),
('Intern', 'Active', 'First semester at code_orange.', '2019-2-14', 4),
('Intern', 'Active', 'First semester at code_orange.', '2019-2-14', 5),
('Product Owner', 'Active', 'Product Owner for Team 11.', '2019-3-19', 5),
('Intern', 'Active', 'Working second semester at code_orange', '2019-2-14', 6),
('Intern', 'Active', 'Working second semester at code_orange', '2019-2-14', 7),
('Intern', 'Active', 'Working second semester at code_orange', '2019-2-14', 8),
('Former Intern', 'Full-Time', 'Mentor for Team 8', '2019-2-14', 9),
('Intern', 'Active', 'Working second semester at code_orange', '2019-2-14', 10),
('Intern', 'Active', 'Working second semester at code_orange', '2019-2-14', 11),
('Intern', 'Active', 'Working second semester at code_orange', '2019-2-14', 12),
('Intern', 'Active', 'Working second semester at code_orange', '2019-2-14', 13),
('Intern', 'Active', 'Working second semester at code_orange', '2019-2-14', 14),
('Intern', 'Active', 'Working second semester at code_orange', '2019-2-14', 15),
('Intern', 'Active', 'Working second semester at code_orange', '2019-2-14', 16),
('Intern', 'Active', 'Working second semester at code_orange', '2019-2-14', 17),
('Intern', 'Active', 'Working second semester at code_orange', '2019-2-14', 18),
('Intern', 'Active', 'Working second semester at code_orange', '2019-2-14', 19),
('Intern', 'Active', 'Working second semester at code_orange', '2019-2-14', 20),
('Intern', 'Active', 'Working second semester at code_orange', '2019-2-14', 21),
('Intern', 'Active', 'Working second semester at code_orange', '2019-2-14', 22),
('Intern', 'Active', 'Working second semester at code_orange', '2019-2-14', 23),
('Intern', 'Active', 'Working second semester at code_orange', '2019-2-14', 24),
('Intern', 'Active', 'Working second semester at code_orange', '2019-2-14', 25),
('Intern', 'Active', 'Working second semester at code_orange', '2019-2-14', 26),
('Intern', 'Active', 'Working second semester at code_orange', '2019-2-14', 27),
('Intern', 'Active', 'Working second semester at code_orange', '2019-2-14', 28),
('Intern', 'Active', 'Working second semester at code_orange', '2019-2-14', 29),
('Intern', 'Active', 'Working second semester at code_orange', '2019-2-14', 30),
('Intern', 'Active', 'Working second semester at code_orange', '2019-2-14', 31),
('Intern', 'Active', 'Working second semester at code_orange', '2019-2-14', 32),
('Intern', 'Active', 'Working second semester at code_orange', '2019-2-14', 33),
('Intern', 'Active', 'Working second semester at code_orange', '2019-2-14', 34),
('Intern', 'Active', 'Working second semester at code_orange', '2019-2-14', 35),
('Intern', 'Active', 'Working second semester at code_orange', '2019-2-14', 36),
('Intern', 'Active', 'Working second semester at code_orange', '2019-2-14', 37),
('Intern', 'Active', 'Working second semester at code_orange', '2019-2-14', 38),
('Intern', 'Active', 'Working second semester at code_orange', '2019-2-14', 39),
('Intern', 'Active', 'Working second semester at code_orange', '2019-2-14', 40),
('Former Intern', 'Inactive', 'Not brought back', '2019-2-14', 41);

INSERT INTO Teams(TeamID, TeamName, TeamNumber, Semester, LabID) VALUES
(1, 'Scurvy', 1, 'FA18', 1),
(2, 'Team X', 2, 'FA18', 1),
(3, 'Triton', 3, 'FA18', 1),
(4, 'aVendors', 4, 'FA18', 1),
(5, 'Wi-fiVe', 5, 'FA18', 1),
(6, 'Et Confusa Novum', 6, 'FA18', 1),
(7, 'Team 777', 7, 'FA18', 1),
(8, 'Atlas', 1, 'SP19', 1),
(9, 'Dragon Riders', 2, 'SP19', 1),
(10, 'Triton', 3, 'SP19', 1),
(11, 'Team 4', 4, 'SP19', 1),
(12, 'Team Covrt', 5, 'SP19', 1),
(13, 'Team 6', 6, 'SP19', 1),
(14, 'Team 777', 7, 'SP19', 1),
(15, 'Xbox_360', 8, 'SP19', 1),
(16, 'Team Pulse', 9, 'SP19', 1),
(17, 'Don Juan', 10, 'SP19', 1),
(18, 'Epic Gamerz', 11, 'SP19', 1),
(19, '12Bricks', 12,'SP19', 1),
(20, 'Team AR Matey', 13, 'SP19', 1);

INSERT INTO TeamMembers(TeamID, MemberID) VALUES
(1, 1),
(18, 1),
(18, 2),
(18, 3),
(18, 4),
(18, 5);

INSERT INTO Projects(Name, Type, Description, Paragraph, FrontEnd, BackEnd, RDS, TeamID) VALUES
('code_orange Website', 'Website', 'Program Information: description, projects, employment, upcoming events, etc', 'The code_orange website is designed to be the face of the lab as it is outward facing. Anyone can check out the website and learn about the lab, ongoing projects, and how to apply to the program. We built everything you see right now!', 'React', 'Node.JS', 'MySQL', 1),
('Feedback Bubbles', 'Mobile App', 'App to allow feedback for meeting attendees', 'This app is intended to be used in conjunction with conferences. Users will have the app on their phone and connect to the specific conference via iBeacon. Here users can submit feedback bubbles (context dependent).', 'React-Native', 'Node.JS', 'MySQL', 2),
('Talent Acquisition', 'Mobile App', 'Capture Candidate info (resume, etc) electronically, replacing paperwork', 'An app is currently being created to aid in Discover job fairs. Users will be able to essentially create a quick submission of their photo, some basic information, and their resume. This allows better electronic transmission of information and faster processing.', 'React', 'Node.JS', 'MySQL', 3),
('Vendor Contact History Website', 'Website', 'Tool to track/update vendor info across Discover', 'This application is intended to alleviate and aid in the management of vendor contact information. They are creating a better system in which this information is kept, managed, and updated.', 'Angular', 'Springboot', 'MySQL', 4),
('Mgmt Approal/Delegation Tool', 'Website', 'One site for management to get all todo items needing action/decision', 'A better tool for management is being developed to aid in tracking changes and important scheduling that requires manager approval. This will allow managers to operate and monitor these schedules in one place.', 'React', 'Node.JS', 'MySQL', 5),
('NIU Innovation App', 'Mobile App', 'Create app that allows students to connect within the space', 'The application is utilizing mobile phones to check-in to the lab using bluetooth. You will be able to see who is in the lab and get some basic information about them.', 'React-Native', 'Node.JS', 'MySQL', 6),
('Change log rewrite', 'Website', 'Create change log to improve tracking of production impacting projects', 'A rework is currently underway of an older piece of Discover software regarding change logs. This application will allow better management and scheduling changes and change log control.', 'React', 'Node.JS', 'MongoDB', 7),
('MAP/code_orange Website', 'Website', 'Manager Approval Tool and code_orange website completion.', 'A completion of the Manager Aproval Portal as well as maintaining/completing the code_orange website, and starting and running social media for the lab.', 'React', 'Node.JS', 'MySQL', 8),
('Feedback Radar/ Valkyrie', 'Mobile App', 'One stop shop application for intern information.', 'A mobile application that allows users to see who is currently in the lab, request help, display a map view where a user will be able to see where innovators are in the space, scan for the closest room or white board and connect to other individuals who are also close to that space. Allows feedback to be sent as well.', 'React-Native', 'Node.JS', 'MySQL', 9),
('Talent Acquisiton', 'Mobile App', 'Job fair application that stores candidate infomation.', 'An app is currently being created to aid in Discover job fairs. Users will be able to essentially create a quick submission of their photo, some basic information, and their resume. This allows better electronic transmission of information and faster processing.', 'React', 'Kotlin', 'MySQL', 10),
('Vendor Contact History', 'Website', 'Application that manages vendor information', 'This application is intended to alleviate and aid in the management of vendor contact information. They are creating a better system in which this information is kept, managed, and updated.', 'Angular', 'Springboot', 'MySQL', 11),
('VR Lab Tour', 'VR Application', 'A VR space that shows a tour of the code_orange lab.', 'A Virtual 360 image tour of the code_orange lab. Allows users to explore the code_orange space that Discover has provided for the interns to use.', 'React-360', 'NodeJS', 'MongoDB', 12),
('Discover Account Center', 'VR Application', 'A VR space that tracks spending and organizes transactions.', 'A Spend Analyzer application which allows users to track their spending and organize their transactions in a VR space.', 'Angular', 'Node.JS', 'MySQL', 13),
('Change Log Rewrite', 'Web Application', 'Additional MVPs and preparation for production of change log rewrite.', 'Working on a change log to improve tracking of production impacting projects.', 'React', 'Node.JS', 'MongoDB', 14),
('360 Student Evaluation', 'Web Application', 'A website for constructive feedback for group projects.', 'A 360 review website allowing team members, mentors, PO, etc. to rate each other and give constructive criticism to those you’re working with in a project together', 'VueJS', 'Django', 'PostgreSQL', 15),
('VR: Brand Command Center', 'VR Application', 'Displays all information, feeds, and social media for any company.', 'VR center that displays all information including Discover and competitors in the tag. This can include feeds and social media from multiple plaforms.', 'React-360', 'Node.JS', 'MySQL', 16),
('Amazon DeepLens Facial Recognition', 'Amazon Deep Lens', 'Facial recognition and responses for users in the lab.', 'An Amazon DeepLens project that will recognize the faces of people in the lab that walk by the device and print a personalized message for them.', 'React', 'Lambda', 'N/A', 17),
('Applicant Tracking & Dashboard', 'Website', 'Keep track of all applicants, interns, and hires from the code_orange project', 'A website that is used to keep track of all potential, current, and former members of the code_orange program.', 'React', 'Node.JS', 'MySQL', 18),
('Cash Back Bonus Application', 'AR Application', 'AR app that allows users to access stores with information about the Discover Cash Back Bonus Program', 'An AR mobile application allowing users to view their favorite stores through their device in real time with information about the Discover Cash Back Bonus program.', 'React-Native', 'NodeJS', 'DynamoDB', 19),
('AR DMS/Huddle board application', 'AR Application', 'AR platform that allows users to explore information regarding team projects.', 'An AR experience for teams that use the Customer Engagement Platform (CEP) room at Riverwoods. Users will receive additional information, documentation, and any relevant external links when viewing a project card.', 'React', 'Unity', 'Vuforia', 20);
