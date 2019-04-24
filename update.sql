SET foreign_key_checks = 0;

INSERT INTO TeamProjects (TeamID, ProjectID) VALUES
(4,4), (11,4);

DELETE TeamProjects WHERE ProjectID = 11 AND TeamID = 4;
DELETE TeamProjects WHERE ProjectID = 11 AND TeamID = 11;

SET foreign_key_checks = 1;
