SET foreign_key_checks = 0;

DROP TABLE IF EXISTS TeamProjects

CREATE TABLE TeamProjects
(TeamID int NOT NULL,
ProjectID int NOT NULL,
FOREIGN KEY (TeamID) REFERENCES Teams(TeamID),
FOREIGN KEY (ProjectID) REFERENCES Projects(ProjectID),
UNIQUE (TeamID, ProjectID));

INSERT INTO TeamProjects (TeamID, ProjectID) VALUES
(1,1),
(2,2),
(3,3), (10,3),
(4,4), (11,4),
(5,5),
(6,6),
(7,7), (14,7),
(8,8),
(9,9),
(12,12),
(13,13),
(15,15),
(16,16),
(17,17),
(18,18),
(19,19),
(20,20);

SET foreign_key_checks = 1;
