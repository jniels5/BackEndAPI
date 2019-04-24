SET foreign_key_checks = 0;

ALTER TABLE Projects DROP FOREIGN KEY Projects_ibfk_1;
ALTER TABLE Projects DROP INDEX Projects_ibfk_1;

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
(4,11), (11,11),
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

DELETE FROM Projects WHERE ProjectID = 10;
DELETE FROM Projects WHERE ProjectID = 11;
DELETE FROM Projects WHERE ProjectID = 14;

SET foreign_key_checks = 1;
