INSERT INTO Members(FirstName, LastName, Gender, GradYear, Email, AssetID, LabID) VALUES
('Jeremy', 'Nielson', 'Male', 'SP19', 'saktirshinu@gmail.com', 1, 1);

INSERT INTO Members(FirstName, LastName, Gender, GradYear, Email, AssetID, LabID) VALUES
('Sean', 'Wallace', 'Male', 'SP20', 'walis846@gmail.com', 2, 1);

INSERT INTO Members(FirstName, LastName, Gender, GradYear, Email, AssetID, LabID) VALUES
('Cole', 'Braswell', 'Male', 'SP20', 'braswellcole@outlook.com', 3, 1);

INSERT INTO Members(FirstName, LastName, Gender, GradYear, Email, AssetID, LabID) VALUES
('Cody', 'Knight', 'Male', 'SP19', 'pulse14@live.com', 4, 1);

INSERT INTO Role(Type, Status, Description, Date, MemberID) VALUES
('Intern', 'Full-time hire', 'Has accepted full time position at DFS. Expected to work following graduation', '2019-2-12', 1),
('Intern', 'Active', 'Working second semester at code_orange', '2019-2-14', 2),
('Intern', 'Active', 'First semester at code_orange', '2019-2-14', 3),
('Intern', 'Active', 'First semester at code_orange. Graduates Spring 2019', '2019-2-14', 4);

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


