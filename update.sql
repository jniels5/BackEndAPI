SET foreign_key_checks = 0;

DELETE FROM Role WHERE MemberID = 114;
DELETE FROM Role WHERE MemberID = 93;
DELETE FROM Role WHERE MemberID = 123;
DELETE FROM Role WHERE MemberID = 112;

DELETE FROM Members WHERE MemberID = 114;
DELETE FROM Members WHERE MemberID = 93;
DELETE FROM Members WHERE MemberID = 123;
DELETE FROM Members WHERE MemberID = 112;

SET foreign_key_checks = 1;
