SET foreign_key_checks = 0;

DELETE FROM Role WHERE RoleID = 142;
DELETE FROM Members WHERE MemberID = 142;
DELETE FROM Role WHERE RoleID = 143;
DELETE FROM Members WHERE MemberID = 143;

SET foreign_key_checks = 1;
