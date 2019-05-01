SET foreign_key_checks = 0;

DELETE FROM Role WHERE RoleID = 139;
DELETE FROM Role WHERE RoleID = 140;
DELETE FROM Role WHERE RoleID = 141;
DELETE FROM Members WHERE MemberID = 139;
DELETE FROM Members WHERE MemberID = 140;
DELETE FROM Members WHERE MemberID = 141;

SET foreign_key_checks = 1;
