SET foreign_key_checks = 0;

ALTER TABLE Members
ADD COLUMN PhoneNum VARCHAR(15) AFTER WorkEmail;

SET foreign_key_checks = 1;
