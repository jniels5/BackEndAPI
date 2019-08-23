-- MySQL dump 10.13  Distrib 5.7.27, for Linux (x86_64)
--
-- Host: team11-database.cpfq5d1i5xkj.us-east-2.rds.amazonaws.com    Database: ebdb
-- ------------------------------------------------------
-- Server version	5.6.10

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `AccountLabs`
--

DROP TABLE IF EXISTS `AccountLabs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `AccountLabs` (
  `AcctID` int(11) NOT NULL,
  `LabID` int(11) NOT NULL,
  UNIQUE KEY `AcctID` (`AcctID`,`LabID`),
  KEY `LabID` (`LabID`),
  CONSTRAINT `AccountLabs_ibfk_1` FOREIGN KEY (`AcctID`) REFERENCES `Accounts` (`AcctID`),
  CONSTRAINT `AccountLabs_ibfk_2` FOREIGN KEY (`LabID`) REFERENCES `Labs` (`LabID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `AccountLabs`
--

LOCK TABLES `AccountLabs` WRITE;
/*!40000 ALTER TABLE `AccountLabs` DISABLE KEYS */;
INSERT INTO `AccountLabs` VALUES (1,1);
/*!40000 ALTER TABLE `AccountLabs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Accounts`
--

DROP TABLE IF EXISTS `Accounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Accounts` (
  `AcctID` int(11) NOT NULL AUTO_INCREMENT,
  `Username` varchar(128) DEFAULT NULL,
  `Password` varchar(128) DEFAULT NULL,
  `FirstName` varchar(25) DEFAULT NULL,
  `LastName` varchar(25) DEFAULT NULL,
  `Role` varchar(5) DEFAULT NULL,
  PRIMARY KEY (`AcctID`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Accounts`
--

LOCK TABLES `Accounts` WRITE;
/*!40000 ALTER TABLE `Accounts` DISABLE KEYS */;
INSERT INTO `Accounts` VALUES (1,'mbrenner2','password','Mike','Brenner','Write');
/*!40000 ALTER TABLE `Accounts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Applications`
--

DROP TABLE IF EXISTS `Applications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Applications` (
  `AppID` varchar(16) NOT NULL,
  `AppName` varchar(50) NOT NULL,
  `AccessLevel` int(11) DEFAULT '0',
  `Note` varchar(255) DEFAULT NULL,
  `Created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`AppID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Applications`
--

LOCK TABLES `Applications` WRITE;
/*!40000 ALTER TABLE `Applications` DISABLE KEYS */;
INSERT INTO `Applications` VALUES ('eekgmcfROcx2qMXs','Goddard chat bot',2,'c_o 2019 Summer Team 4','2019-07-29 20:15:10'),('r2OFejNfmGx7SfVw','code_orange website',4,'c_o 2019 Summer Team 7','2019-07-29 20:12:23'),('wXbRFjtqFF2PvjMf','code_orange manager app',4,'c_o Jeremy Nielson','2019-07-29 20:14:00');
/*!40000 ALTER TABLE `Applications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ApprovalsHistory`
--

DROP TABLE IF EXISTS `ApprovalsHistory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ApprovalsHistory` (
  `ApprovalID` int(11) NOT NULL AUTO_INCREMENT,
  `Email` varchar(320) DEFAULT NULL,
  `FullName` mediumtext,
  `Service` varchar(512) DEFAULT NULL,
  `Description` varchar(255) DEFAULT NULL,
  `RequestedBy` mediumtext,
  `RequestDate` date DEFAULT NULL,
  `CloseDate` date DEFAULT NULL,
  `Status` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`ApprovalID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ApprovalsHistory`
--

LOCK TABLES `ApprovalsHistory` WRITE;
/*!40000 ALTER TABLE `ApprovalsHistory` DISABLE KEYS */;
/*!40000 ALTER TABLE `ApprovalsHistory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Assets`
--

DROP TABLE IF EXISTS `Assets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Assets` (
  `AssetID` int(11) NOT NULL,
  `Type` varchar(25) DEFAULT NULL,
  `Description` varchar(50) DEFAULT NULL,
  `IsImaged` tinyint(1) DEFAULT NULL,
  `LabID` int(11) DEFAULT NULL,
  PRIMARY KEY (`AssetID`),
  KEY `LabID` (`LabID`),
  CONSTRAINT `Assets_ibfk_1` FOREIGN KEY (`LabID`) REFERENCES `Labs` (`LabID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Assets`
--

LOCK TABLES `Assets` WRITE;
/*!40000 ALTER TABLE `Assets` DISABLE KEYS */;
INSERT INTO `Assets` VALUES (0,'MobileDevice','',0,NULL),(10000000,'N/A','N/a',0,1),(10000001,'Mobile Device','Samsung Galaxy Note 10.1',1,1),(20082954,'Mobile Device','iPad',1,1),(20100180,'Laptop','Apple MacBook Pro',1,1),(20100181,'Laptop','Apple MacBook Pro',1,1),(20100182,'Laptop','Apple MacBook Pro',1,1),(20100183,'Laptop','Apple MacBook Pro',1,1),(20100184,'Laptop','Apple MacBook Pro',1,1),(20100186,'Laptop','Apple MacBook Pro',1,1),(20100187,'Laptop','Apple MacBook Pro',1,1),(20100188,'Laptop','Apple MacBook Pro',1,1),(20100189,'Laptop','Apple MacBook Pro',1,1),(20100190,'Laptop','Apple MacBook Pro',1,1),(20100191,'Laptop','Apple MacBook Pro',1,1),(20100192,'Laptop','Apple MacBook Pro',1,1),(20100193,'Laptop','Apple MacBook Pro',1,1),(20100194,'Laptop','Apple MacBook Pro',1,1),(20100195,'Laptop','Apple MacBook Pro',1,1),(20100196,'Laptop','Apple MacBook Pro',1,1),(20100197,'Laptop','Apple MacBook Pro',1,1),(20100198,'Laptop','Apple MacBook Pro',1,1),(20100199,'Laptop','Apple MacBook Pro',1,1),(20100200,'Laptop','Apple MacBook Pro',1,1),(20100201,'Laptop','Apple MacBook Pro',1,1),(20100202,'Laptop','Apple MacBook Pro',1,1),(20100203,'Laptop','Apple MacBook Pro',1,1),(20100204,'Laptop','Apple MacBook Pro',1,1),(20100205,'Laptop','Apple MacBook Pro',1,1),(20100206,'Laptop','Apple MacBook Pro',1,1),(20100207,'Laptop','Apple MacBook Pro',1,1),(20100208,'Laptop','Apple MacBook Pro',1,1),(20100209,'Laptop','Apple MacBook Pro',1,1),(20100210,'Laptop','Apple MacBook Pro',1,1),(20100211,'Laptop','Apple MacBook Pro',1,1),(20100212,'Laptop','Apple MacBook Pro',1,1),(20100213,'Laptop','Apple MacBook Pro',1,1),(20100214,'Laptop','Apple MacBook Pro',1,1),(20100215,'Laptop','Apple MacBook Pro',1,1),(20100216,'Laptop','Apple MacBook Pro',1,1),(20100217,'Laptop','Apple MacBook Pro',1,1),(20100219,'Laptop','Apple MacBook Pro',1,1),(20100464,'Laptop','Apple MacBook Pro',1,1),(20100465,'Laptop','Apple MacBook Pro',1,1),(20108549,'Laptop','Apple MacBook Pro',1,1),(20108938,'Laptop','Apple MacBook Pro',1,1),(20108939,'Laptop','Apple MacBook Pro',1,1),(20108940,'Laptop','Apple MacBook Pro',1,1),(20108941,'Laptop','Apple MacBook Pro',1,1),(20108942,'Laptop','Apple MacBook Pro',1,1),(20108943,'Laptop','Apple MacBook Pro',1,1),(20108944,'Laptop','Apple MacBook Pro',1,1),(20108945,'Laptop','Apple MacBook Pro',1,1),(20108946,'Laptop','Apple MacBook Pro',1,1),(20108947,'Laptop','Apple MacBook Pro',1,1),(20108948,'Laptop','Apple MacBook Pro',1,1),(20108949,'Laptop','Apple MacBook Pro',1,1),(20108950,'Laptop','Apple MacBook Pro',1,1),(20108951,'Laptop','Apple MacBook Pro',1,1),(20108953,'Laptop','Apple MacBook Pro',1,1),(20108955,'Laptop','Apple MacBook Pro',1,1),(20108956,'Laptop','Apple MacBook Pro',1,1),(20108957,'Laptop','Apple MacBook Pro',1,1),(20108958,'Laptop','Apple MacBook Pro',1,1),(20108959,'Laptop','Apple MacBook Pro',1,1),(20108960,'Laptop','Apple MacBook Pro',1,1),(20108961,'Laptop','Apple MacBook Pro',1,1),(20108963,'Laptop','Apple MacBook Pro',1,1),(20108964,'Laptop','Apple MacBook Pro',1,1),(20108966,'Laptop','Apple MacBook Pro',1,1),(20108968,'Laptop','Apple MacBook Pro',1,1),(20108969,'Laptop','Apple MacBook Pro',1,1),(20108971,'Laptop','Apple MacBook Pro',1,1),(20108972,'Laptop','Apple MacBook Pro',1,1),(20108973,'Laptop','Apple MacBook Pro',1,1),(20108974,'Laptop','Apple MacBook Pro',1,1),(20108975,'Laptop','Apple MacBook Pro',1,1),(20108976,'Laptop','Apple MacBook Pro',1,1),(20108977,'Laptop','Apple MacBook Pro',1,1),(20110944,'Laptop','Apple MacBook Pro',1,1),(20110985,'Mobile Device','Samsung Galaxy Tab A',1,1),(20110998,'Mobile Device','iPad',1,1),(21119990,'Mobile Device','',0,1),(50005573,'Mobile Device','Samsung Galaxy S8',1,1),(50005574,'Mobile Device','Samsung Galaxy S8',1,1),(50005575,'Mobile Device','Samsung Galaxy S8',1,1),(50005576,'Mobile Device','iPhone 8',1,1),(50005577,'Mobile Device','iPhone 8',1,1),(50005578,'Mobile Device','iPhone 8',1,1),(98765431,'Laptop','test 2',0,1),(98765432,'Laptop','test',0,1),(98765433,'Laptop','test 3',0,1),(200000000,'MobileDevice','',0,1),(999999999,'Mobile Device','Samsung Galaxy Note 10.1',0,1);
/*!40000 ALTER TABLE `Assets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Delegations`
--

DROP TABLE IF EXISTS `Delegations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Delegations` (
  `DelegationID` int(11) NOT NULL AUTO_INCREMENT,
  `Delegator` mediumtext,
  `Email` varchar(320) DEFAULT NULL,
  `Delegatee` mediumtext,
  `StartDate` date DEFAULT NULL,
  `EndDate` date DEFAULT NULL,
  `Description` varchar(255) DEFAULT NULL,
  `State` int(11) DEFAULT NULL,
  `Status` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`DelegationID`)
) ENGINE=InnoDB AUTO_INCREMENT=503 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Delegations`
--

LOCK TABLES `Delegations` WRITE;
/*!40000 ALTER TABLE `Delegations` DISABLE KEYS */;
/*!40000 ALTER TABLE `Delegations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Labs`
--

DROP TABLE IF EXISTS `Labs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Labs` (
  `LabID` int(11) NOT NULL AUTO_INCREMENT,
  `Abbrev` varchar(5) DEFAULT NULL,
  `School` varchar(50) DEFAULT NULL,
  `City` varchar(50) DEFAULT NULL,
  `State` varchar(2) DEFAULT NULL,
  PRIMARY KEY (`LabID`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Labs`
--

LOCK TABLES `Labs` WRITE;
/*!40000 ALTER TABLE `Labs` DISABLE KEYS */;
INSERT INTO `Labs` VALUES (1,'NIU','Northern Illinois University','Dekalb','IL');
/*!40000 ALTER TABLE `Labs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `LoginAttempts`
--

DROP TABLE IF EXISTS `LoginAttempts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `LoginAttempts` (
  `MemberID` int(11) NOT NULL,
  `Attempts` int(11) NOT NULL,
  PRIMARY KEY (`MemberID`),
  CONSTRAINT `LoginAttempts_ibfk_1` FOREIGN KEY (`MemberID`) REFERENCES `Members` (`MemberID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `LoginAttempts`
--

LOCK TABLES `LoginAttempts` WRITE;
/*!40000 ALTER TABLE `LoginAttempts` DISABLE KEYS */;
INSERT INTO `LoginAttempts` VALUES (5,0),(38,0),(58,0),(65,0),(66,0),(68,0),(69,0),(80,0),(146,0),(147,0),(148,0),(151,5),(174,0),(176,0);
/*!40000 ALTER TABLE `LoginAttempts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Members`
--

DROP TABLE IF EXISTS `Members`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Members` (
  `MemberID` int(11) NOT NULL AUTO_INCREMENT,
  `FirstName` varchar(20) DEFAULT NULL,
  `LastName` varchar(20) DEFAULT NULL,
  `Gender` varchar(15) DEFAULT NULL,
  `GradSemester` varchar(6) DEFAULT NULL,
  `GradYear` int(11) DEFAULT NULL,
  `Email` varchar(320) DEFAULT NULL,
  `WorkEmail` varchar(320) DEFAULT NULL,
  `PhoneNum` varchar(15) DEFAULT NULL,
  `Major` varchar(75) DEFAULT NULL,
  `AssetID` int(11) DEFAULT NULL,
  `LabID` int(11) DEFAULT NULL,
  `PhotoPath` varchar(255) DEFAULT NULL,
  `SuperUser` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`MemberID`),
  KEY `AssetID` (`AssetID`),
  KEY `LabID` (`LabID`),
  CONSTRAINT `Members_ibfk_1` FOREIGN KEY (`AssetID`) REFERENCES `Assets` (`AssetID`),
  CONSTRAINT `Members_ibfk_2` FOREIGN KEY (`LabID`) REFERENCES `Labs` (`LabID`)
) ENGINE=InnoDB AUTO_INCREMENT=187 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Members`
--

LOCK TABLES `Members` WRITE;
/*!40000 ALTER TABLE `Members` DISABLE KEYS */;
INSERT INTO `Members` VALUES (1,'Jeremy','Nielson','Male','Spring',2019,'saktirshinu@gmail.com','jeremynielson@discover.com','6309268650',NULL,20100206,1,'https://innovatorphotos.s3.us-east-2.amazonaws.com/innovators/JeremyNielson.jpg',1),(2,'Brady','Goldsworthy','Male','Spring',2019,'goldsworthybrady@gmail.com','bradygoldsworthy@discover.com',NULL,NULL,20100189,1,'https://innovatorphotos.s3.us-east-2.amazonaws.com/innovators/BradyGoldsworthy.jpg',0),(3,'Justin','Dupre','Male','Fall',2020,'jdupre@niu.edu','justindupre@discover.com',NULL,NULL,20100187,1,'https://innovatorphotos.s3.us-east-2.amazonaws.com/innovators/JustinDupre.jpg',0),(4,'Bradley','Protano','Male','Fall',2018,NULL,'bradleyprotano@discover.com',NULL,NULL,10000000,1,'https://innovatorphotos.s3.us-east-2.amazonaws.com/innovators/BradleyProtano.jpg',0),(5,'Katie','Berendt','Female','Fall',2019,'kber0167@gmail.com','katieberendt@discover.com',NULL,NULL,20100183,1,'https://innovatorphotos.s3.us-east-2.amazonaws.com/innovators/KatieBerendt.jpg',0),(6,'Jackie','Salim','Female','Spring',2019,'z1761458@students.niu.edu','jacquelinesalim@discover.com',NULL,NULL,20100207,1,'https://innovatorphotos.s3.us-east-2.amazonaws.com/innovators/JackieSalim.jpg',0),(7,'Nahom','Gebremichael','Male',NULL,NULL,'nahomgm@live.com','nahomgebremichael@discover.com',NULL,NULL,20100197,1,'https://innovatorphotos.s3.us-east-2.amazonaws.com/innovators/NahomGebremichael.jpg',0),(8,'Thomas','Franczak','Male','Spring',2019,'tfranczak@niu.edu','thomasfranczak@discover.com',NULL,NULL,20100199,1,'https://innovatorphotos.s3.us-east-2.amazonaws.com/innovators/ThomasFranczak.jpg',0),(9,'Kyle','Wilson','Male',NULL,NULL,NULL,'kylewilson@discover.com',NULL,NULL,10000000,1,'https://innovatorphotos.s3.us-east-2.amazonaws.com/innovators/KyleWilson.jpg',0),(10,'Sean','Wallace','Male','Spring',2020,'walis846@gmail.com','seanwallace@discover.com',NULL,NULL,20100464,1,'https://innovatorphotos.s3.us-east-2.amazonaws.com/innovators/SeanWallace.jpg',0),(11,'Ben','Lane','Male','Spring',2019,'LiftPort@gmail.com','benlane@discover.com',NULL,NULL,20100203,1,'https://innovatorphotos.s3.us-east-2.amazonaws.com/innovators/BenLane.jpg',0),(12,'Kevin','Miyata','Male','Spring',2019,'kjm015@yahoo.com','kevinmiyata@discover.com',NULL,NULL,20100208,1,'https://innovatorphotos.s3.us-east-2.amazonaws.com/innovators/KevinMiyata.jpg',0),(13,'James','Bonasera','Male','Spring',2019,'jabonasera@gmail.com','jamesbonasera@discover.com',NULL,NULL,20100200,1,'https://innovatorphotos.s3.us-east-2.amazonaws.com/innovators/JamesBonasera.jpg',0),(14,'Kris','Schrader','Female',NULL,NULL,'krissschrader@gmail.com','krisschrader@discover.com',NULL,NULL,20100182,1,'https://innovatorphotos.s3.us-east-2.amazonaws.com/innovators/KrisSchrader.jpg',0),(15,'Samuel','Rutledge','Male',NULL,NULL,NULL,'samuelrutledge@discover.com',NULL,NULL,10000000,1,'https://innovatorphotos.s3.us-east-2.amazonaws.com/innovators/SamuelRutledge.jpg',0),(16,'Nicholas','Swanson','Male',NULL,NULL,NULL,'nicholasswanson@discover.com',NULL,NULL,10000000,1,'https://innovatorphotos.s3.us-east-2.amazonaws.com/innovators/NicholasSwanson.jpg',0),(17,'Alex','Boyle','Male','Spring',2019,'aboyle75@gmail.com','alexboyle@discover.com',NULL,NULL,20100214,1,'https://innovatorphotos.s3.us-east-2.amazonaws.com/innovators/AlexBoyle.jpg',0),(18,'Amy','Jakopin','Female',NULL,NULL,'amyjakopin@gmail.com','amyjakopin@discover.com',NULL,NULL,20100191,1,'https://innovatorphotos.s3.us-east-2.amazonaws.com/innovators/AmyJakopin.jpg',0),(19,'Andrew','Slade','Male','Fall',2023,'aslade7921@yahoo.com','andrewslade@discover.com',NULL,NULL,10000000,1,'https://innovatorphotos.s3.us-east-2.amazonaws.com/innovators/AndrewSlade.jpg',0),(20,'Kristen','Arms','Female',NULL,NULL,'kristena.etruscan@gmail.com','kristenarms@discover.com',NULL,NULL,20100204,1,'https://innovatorphotos.s3.us-east-2.amazonaws.com/innovators/KristenArms.jpg',0),(21,'Shiva','Singh','Male',NULL,NULL,'shivasingh@outlook.com','shivasingh@discover.com',NULL,NULL,20100193,1,'https://innovatorphotos.s3.us-east-2.amazonaws.com/innovators/ShivaSingh.jpg',0),(22,'Dylan','Drake','Male',NULL,NULL,'dyldrake21@gmail.com','dylandrake@discover.com',NULL,NULL,20100198,1,'https://innovatorphotos.s3.us-east-2.amazonaws.com/innovators/DylanDrake.jpg',0),(23,'Jane','Swift','Female',NULL,NULL,'j.e.swift711@gmail.com','janeswift@discover.com',NULL,NULL,20100212,1,'https://innovatorphotos.s3.us-east-2.amazonaws.com/innovators/JaneSwift.jpg',0),(24,'Kwaku','Agyemang','Male',NULL,NULL,'mynhiz@gmail.com','kwakuagyemang@discover.com',NULL,NULL,20100188,1,'https://innovatorphotos.s3.us-east-2.amazonaws.com/innovators/KwakuAgyemang.jpg',0),(25,'Nathanael','Isola','Male',NULL,NULL,NULL,'nathanaelisola@discover.com',NULL,NULL,10000000,1,'https://innovatorphotos.s3.us-east-2.amazonaws.com/innovators/NathanaelIsola.jpg',0),(26,'Quinton','Lee','Male',NULL,NULL,'quivistis@gmail.com','quintonlee@discover.com',NULL,NULL,20100213,1,'https://innovatorphotos.s3.us-east-2.amazonaws.com/innovators/QuintonLee.jpg',0),(27,'Adam','Remes','Male','Spring',2019,'adam.j.remes@gmail.com','adamremes@discover.com',NULL,NULL,20100202,1,'https://innovatorphotos.s3.us-east-2.amazonaws.com/innovators/AdamRemes.jpg',0),(28,'Elly','Jdaidany','Male','Fall',2019,'ellyjda@gmail.com','ellyjdaidany@discover.com',NULL,NULL,20100201,1,'https://innovatorphotos.s3.us-east-2.amazonaws.com/innovators/EllyJdaidany.jpg',0),(29,'Jessica','Guenther','Female','Spring',2019,'jessica.h.guenther@gmail.com','jessicaguenther@discover.com',NULL,NULL,20100184,1,'https://innovatorphotos.s3.us-east-2.amazonaws.com/innovators/JessicaGuenther.jpg',0),(30,'Spencer','Yoder','Male','Fall',2018,NULL,'spenceryoder@discover.com',NULL,NULL,10000000,1,'https://innovatorphotos.s3.us-east-2.amazonaws.com/innovators/SpencerYoder.jpg',0),(31,'Vishy','Singh','Male',NULL,NULL,'vishysingh@outlook.com','vishysingh@discover.com',NULL,NULL,20100215,1,'https://innovatorphotos.s3.us-east-2.amazonaws.com/innovators/VishySingh.jpg',0),(32,'Nicholas','Glaviano','Male',NULL,NULL,NULL,'nicholasglaviano@discover.com',NULL,NULL,10000000,1,'https://innovatorphotos.s3.us-east-2.amazonaws.com/innovators/NicholasGlaviano.jpg',0),(33,'Javier','Gomez','Male',NULL,NULL,NULL,'javiergomez@discover.com',NULL,NULL,10000000,1,'https://innovatorphotos.s3.us-east-2.amazonaws.com/innovators/JavierGomez.jpg',0),(34,'Cameron','Badenoch','Male','Spring',2019,'cam_badenoch10@live.com','cameronbadenoch@discover.com',NULL,NULL,20100210,1,'https://innovatorphotos.s3.us-east-2.amazonaws.com/innovators/CameronBadenoch.jpg',0),(35,'Krystal','McIntyre-Miller','Female',NULL,NULL,'z1779194@students.niu.edu','krystalmcintyremiller@discover.com',NULL,NULL,20100195,1,'https://innovatorphotos.s3.us-east-2.amazonaws.com/innovators/KrystalMcIntyre-Miller.jpg',0),(36,'Nicholas','Rosso','Male',NULL,NULL,'nicholasrosso@comcast.net','nicholasrosso@discover.com',NULL,NULL,20100216,1,'https://innovatorphotos.s3.us-east-2.amazonaws.com/innovators/NicholasRosso.jpg',0),(37,'Tyler','Havener','Male',NULL,NULL,NULL,'tylerhavener@discover.com',NULL,NULL,10000000,1,'https://innovatorphotos.s3.us-east-2.amazonaws.com/innovators/TylerHavener.jpg',0),(38,'Alan','Fikar','Male','Summer',2019,'alan.fikar@gmail.com','alanfikar@discover.com',NULL,NULL,20100186,1,'https://innovatorphotos.s3.us-east-2.amazonaws.com/innovators/AlanFikar.jpg',0),(39,'Matt','Blauw','Male',NULL,NULL,'matthewjblauw@gmail.com','mattblauw@discover.com',NULL,NULL,20100205,1,'https://innovatorphotos.s3.us-east-2.amazonaws.com/innovators/MattBlauw.jpg',0),(40,'Patrick','Klesyk','Male',NULL,NULL,'pklesyk@gmail.com','patrickklesyk@discover.com',NULL,NULL,20108944,1,'https://innovatorphotos.s3.us-east-2.amazonaws.com/innovators/PatrickKlesyk.jpg',0),(41,'Lucas','Damler','Male',NULL,NULL,'ldamler@gmail.com','lucasdamler@discover.com',NULL,NULL,20100465,1,'https://innovatorphotos.s3.us-east-2.amazonaws.com/innovators/LucasDamler.jpg',0),(42,'Purvin','Patel','Male',NULL,NULL,'purvin08@ieee.org','purvinpatel@discover.com',NULL,NULL,20108947,1,'https://innovatorphotos.s3.us-east-2.amazonaws.com/innovators/PurvinPatel.jpg',0),(43,'Smit','Patel','Male',NULL,NULL,'mrsmitp16@gmail.com','smitpatel@discover.com',NULL,NULL,20108940,1,'https://innovatorphotos.s3.us-east-2.amazonaws.com/innovators/SmitPatel.jpg',0),(44,'Connor','Petruzzi','Male',NULL,NULL,'connor61095@comcast.net','connorpetruzzi@discover.com',NULL,NULL,20108942,1,'https://innovatorphotos.s3.us-east-2.amazonaws.com/innovators/ConnorPetruzzi.jpg',0),(45,'Connor','Pekovic','Male',NULL,NULL,'connorpekovic1@gmail.com','connorpekovic@discover.com',NULL,NULL,10000000,1,'https://innovatorphotos.s3.us-east-2.amazonaws.com/innovators/ConnorPekovic.jpg',0),(46,'Jennifer','Ho','Female',NULL,NULL,'jennifer.ho30@gmail.com','jenniferho@discover.com',NULL,NULL,20108971,1,'https://innovatorphotos.s3.us-east-2.amazonaws.com/innovators/JenniferHo.jpg',0),(47,'Akshay','Patel','Male',NULL,NULL,'ap95@ieee.org','akshaypatel@discover.com',NULL,NULL,20108946,1,'https://innovatorphotos.s3.us-east-2.amazonaws.com/innovators/AkshayPatel.jpg',0),(48,'Cody','Farrey','Male',NULL,NULL,'codyfarrey@gmail.com','codyfarrey@discover.com',NULL,NULL,20110994,1,'https://innovatorphotos.s3.us-east-2.amazonaws.com/innovators/CodyFarrey.jpg',0),(49,'Noah','Miller','Male',NULL,NULL,'nmillercontact@gmail.com','noahmiller@discover.com',NULL,NULL,20100219,1,'https://innovatorphotos.s3.us-east-2.amazonaws.com/innovators/NoahMiller.jpg',0),(50,'Kevin','Kang','Male','Spring',2019,'kevinfkang@gmail.com','kevinkang@discover.com',NULL,NULL,20108938,1,'https://innovatorphotos.s3.us-east-2.amazonaws.com/innovators/KevinKang.jpg',0),(51,'Marco','Martinez','Male',NULL,NULL,'marco.antoni.martinez@gmail.com','marcomartinez@discover.com',NULL,NULL,20108941,1,'https://innovatorphotos.s3.us-east-2.amazonaws.com/innovators/MarcoMartinez.jpg',0),(52,'Eduardo','Leanos','Male','Spring',2020,'edleanos@gmail.com','eduardoleanos@discover.com',NULL,NULL,20108959,1,'https://innovatorphotos.s3.us-east-2.amazonaws.com/innovators/EduardoLeanos.jpg',0),(53,'Cody','McAntire','Male',NULL,NULL,'z1859456@students.niu.edu','codymcantire@discover.com',NULL,NULL,10000000,1,'https://innovatorphotos.s3.us-east-2.amazonaws.com/innovators/CodyMcAntire.jpg',0),(54,'Axil','Patel','Male',NULL,NULL,'axil95@gmail.com','axilpatel@discover.com',NULL,NULL,20108945,1,'https://innovatorphotos.s3.us-east-2.amazonaws.com/innovators/AxilPatel.jpg',0),(55,'Philip','Boffa','Male',NULL,NULL,'phillipboffa@gmail.com','phillipboffa@discover.com',NULL,NULL,10000000,1,'https://innovatorphotos.s3.us-east-2.amazonaws.com/innovators/PhillipBoffa.jpg',0),(56,'Aaron','Jones','Male',NULL,NULL,'aaroncjones17@gmail.com','aaronjones@discover.com',NULL,NULL,20108973,1,'https://innovatorphotos.s3.us-east-2.amazonaws.com/innovators/AaronJones.jpg',0),(57,'Anthony','Calcagno','Male','Summer',2019,'z1829706@students.niu.edu','anthonycalcagno@discover.com',NULL,NULL,20108972,1,'https://innovatorphotos.s3.us-east-2.amazonaws.com/innovators/AnthonyCalcagno.jpg',0),(58,'Zachary','Hueneke','Male',NULL,NULL,'zhueneke@gmail.com','zachhueneke@discover.com',NULL,NULL,20100181,1,'https://innovatorphotos.s3.us-east-2.amazonaws.com/innovators/ZacharyHueneke.jpg',0),(59,'Crystal','Ritchey','Female',NULL,NULL,'crystalmritchey@gmail.com','crystalritchey@discover.com',NULL,NULL,20100194,1,'https://innovatorphotos.s3.us-east-2.amazonaws.com/innovators/CrystalRitchey.jpg',0),(60,'Dean','LaBarbera','Male',NULL,NULL,'deanmichaellabarbera@hotmail.com','deanbarbera@discover.com',NULL,NULL,20108948,1,'https://innovatorphotos.s3.us-east-2.amazonaws.com/innovators/DeanLaBarbera.jpg',0),(61,'Josh','Ruge','Male',NULL,NULL,'joshruge@gmail.com','joshruge@discover.com',NULL,NULL,20108960,1,'https://innovatorphotos.s3.us-east-2.amazonaws.com/innovators/JoshRuge.jpg',0),(62,'Jeremy','Torossian','Male','Summer',2019,'jtorossiananimation@gmail.com','jeremytorossian@discover.com',NULL,NULL,20108950,1,'https://innovatorphotos.s3.us-east-2.amazonaws.com/innovators/JeremyTorossian.jpg',0),(63,'Tanner','Martin','Male',NULL,NULL,'z1800126@students.niu.edu','tannermartin@discover.com',NULL,NULL,20108977,1,'https://innovatorphotos.s3.us-east-2.amazonaws.com/innovators/TannerMartin.jpg',0),(64,'Aleena','Ahmad','Female',NULL,NULL,'aleenaahmed85@gmail.com','aleenaahmed@discover.com',NULL,NULL,20108968,1,'https://innovatorphotos.s3.us-east-2.amazonaws.com/innovators/AleenaAhmad.jpg',0),(65,'Daniel','O\'Malley','Male','Spring',2020,'daniel.omalley@live.com','danielomalley@discover.com',NULL,NULL,20108958,1,'https://innovatorphotos.s3.us-east-2.amazonaws.com/innovators/DanielO\'Malley.jpg',1),(66,'Byron','Hogan','Male',NULL,NULL,'Z1825194@students.niu.edu','byronhogan@discover.com',NULL,NULL,20108953,1,'https://innovatorphotos.s3.us-east-2.amazonaws.com/innovators/ByronHogan.jpg',0),(67,'Charles','Dawes','Male','Fall',2020,'charliedawes@yahoo.com','charlesdawes@discover.com',NULL,NULL,20100180,1,'https://innovatorphotos.s3.us-east-2.amazonaws.com/innovators/CharlesDawes.jpg',0),(68,'Samuel','Piecz','Male','Spring',2020,'samuel.piecz@gmail.com','samuelpiecz@discover.com',NULL,NULL,20108957,1,'https://innovatorphotos.s3.us-east-2.amazonaws.com/innovators/SamuelPiecz.jpg',0),(69,'Adelaide','Adams','Female','Fall',2020,'adelaide527@gmail.com','adelaideadams@discover.com',NULL,NULL,20108976,1,'https://innovatorphotos.s3.us-east-2.amazonaws.com/innovators/AdelaideAdams.jpg',0),(70,'Kevin','Pallikunnel','Male','Fall',2019,'oapallikunnel@gmail.com','kevinpallikunnel@discover.com',NULL,NULL,20108964,1,'https://innovatorphotos.s3.us-east-2.amazonaws.com/innovators/KevinPallikunnel.jpg',0),(71,'Henry','Pelesh','Male',NULL,NULL,'hjpelesh@gmail.com','henrypelesh@discover.com',NULL,NULL,20108956,1,'https://innovatorphotos.s3.us-east-2.amazonaws.com/innovators/HenryPelesh.jpg',0),(72,'Daniel','Facundo','Male',NULL,NULL,'daniel8facundo@gmail.com','danielfacundo@discover.com',NULL,NULL,20100190,1,'https://innovatorphotos.s3.us-east-2.amazonaws.com/innovators/DanielFacundo.jpg',0),(73,'Angelo','Cruz','Male','Spring',2020,'angelo.t.cruz1@gmail.com','angelocruz@discover.com',NULL,NULL,20108955,1,'https://innovatorphotos.s3.us-east-2.amazonaws.com/innovators/AngeloCruz.jpg',0),(74,'Haley','Nuber','Male',NULL,NULL,'haleynuber@gmail.com','haleynuber@discover.com',NULL,NULL,20108961,1,'https://innovatorphotos.s3.us-east-2.amazonaws.com/innovators/HaleyNuber.jpg',0),(75,'Uzair','Ahmed','Male','Spring',2020,'uzairmasood92@hotmail.com','uzairahmed@discover.com',NULL,NULL,20100192,1,'https://innovatorphotos.s3.us-east-2.amazonaws.com/innovators/UzairAhmed.jpg',0),(76,'Yousef','Saigh','Male',NULL,NULL,'yousefsaigh@gmail.com','yousefsaigh@discover.com',NULL,NULL,20108974,1,'https://innovatorphotos.s3.us-east-2.amazonaws.com/innovators/YousefSaigh.jpg',0),(77,'Payton','Suchomel','Male',NULL,NULL,'suchomelpayton@gmail.com','paytonsuchomel@discover.com',NULL,NULL,20108594,1,'https://innovatorphotos.s3.us-east-2.amazonaws.com/innovators/PaytonSuchomel.jpg',0),(78,'Cole','Braswell','Male','Spring',2020,'braswellcole@outlook.com','colebraswell@discover.com',NULL,NULL,20100217,1,'https://innovatorphotos.s3.us-east-2.amazonaws.com/innovators/ColeBraswell.jpg',0),(79,'Cody','Knight','Male','Spring',2019,'pulse14@live.com','codyknight@discover.com',NULL,NULL,20108969,1,'https://innovatorphotos.s3.us-east-2.amazonaws.com/innovators/CodyKnight.jpg',0),(80,'Michael','Pacyga','Male','Fall',2020,'michagy@gmail.com','michaelpacyga@discover.com',NULL,NULL,20108939,1,'https://innovatorphotos.s3.us-east-2.amazonaws.com/innovators/MichaelPacyga.jpg',0),(81,'Kenneth','Nguyen','Male',NULL,NULL,'kennethtringuyen@gmail.com','kennethnguyen@discover.com',NULL,NULL,20100196,1,'https://innovatorphotos.s3.us-east-2.amazonaws.com/innovators/KennethNguyen.jpg',0),(82,'Dishant','Patel','Male',NULL,NULL,'pateldishant17@gmail.com','dishantpatel@discover.com',NULL,NULL,20108963,1,'https://innovatorphotos.s3.us-east-2.amazonaws.com/innovators/DishantPatel.jpg',0),(83,'Edgar','Villafuerte','Male',NULL,NULL,'edgar.villafuente96@gmail.com','edgarvillafuente@discover.com',NULL,NULL,20100209,1,'https://innovatorphotos.s3.us-east-2.amazonaws.com/innovators/EdgarVillafuente.jpg',0),(84,'Aivree','Gomez','Male','Spring',2021,'aivree@live.com','aivreegomez@discover.com',NULL,NULL,20100211,1,'https://innovatorphotos.s3.us-east-2.amazonaws.com/innovators/AivreeGomez.jpg',0),(85,'Mohammad','Khan','Male',NULL,NULL,'z1819675@students.niu.edu','mohammadkhan@discover.com',NULL,NULL,20108966,1,'https://innovatorphotos.s3.us-east-2.amazonaws.com/innovators/MohammadKhan.jpg',0),(86,'Harshita','Kothamasu','Female',NULL,NULL,'harshitakoth11@gmail.com','harshitakothamasu@discover.com',NULL,NULL,20108943,1,'https://innovatorphotos.s3.us-east-2.amazonaws.com/innovators/HarshitaKothamasu.jpg',0),(87,'Gonzalo','Pantoja','Male',NULL,NULL,'gonzalopantoja@ieee.org','gonzalopantoja@discover.com',NULL,NULL,20108949,1,'https://innovatorphotos.s3.us-east-2.amazonaws.com/innovators/GonzaloPantoja.jpg',0),(88,'Adithya','Attavane','Male',NULL,NULL,'aattavane1@niu.edu','adithyaattavane@discover.com',NULL,NULL,20108951,1,'https://innovatorphotos.s3.us-east-2.amazonaws.com/innovators/AdithyaAttavane.jpg',0),(89,'Mike','Brenner','Male',NULL,NULL,NULL,'michaelbrenner@discover.com',NULL,NULL,10000000,1,'https://innovatorphotos.s3.us-east-2.amazonaws.com/innovators/MikeBrenner.jpg',1),(90,'Austin','Healy','','',2020,'z1794472@students.niu.edu','',NULL,'computer science',10000000,1,'',0),(91,'Corbin','Lutsch','','',2019,'corbinlutsch@gmail.com','corbinlutsch@discover.com',NULL,'Computer Science',10000000,1,'',0),(92,'matthew','lord','','',2020,'lordmatthew0@gmail.com','',NULL,'comp sci',10000000,1,'',0),(94,'Michael','Orsay','','',2019,'morsay2@gmail.com','',NULL,'CSCI',10000000,1,'',0),(95,'SAM','VI','','',2019,'samvi.sv@gmail.com','',NULL,'computer science',10000000,1,'',0),(96,'Joshua','Flores','','',2019,'joshuaaaronflores@gmail.com','',NULL,'Computer Science',10000000,1,'',0),(97,'sridivya','pagadala','','',2020,'sridivya.pagadala@gmail.com','',NULL,'computer science',10000000,1,'',0),(98,'Robert','Oury','','',2020,'fastmax97@me.com','',NULL,'CompSci',10000000,1,'',0),(99,'Elizabeth','Korbut','','',2019,'z1825074@students.niu.edu','',NULL,'Political Science ',10000000,1,'',0),(100,'Samuel','Thomas','','',2021,'thomas.samuel415@gmail.com','',NULL,'Computer Science',10000000,1,'',0),(101,'Balaji Naidu ','Sadhu','','',2019,'z1860906@students.niu.edu','',NULL,'computer science',10000000,1,'',0),(102,'Marjo','Feliciano','','',2020,'marjofeliciano@gmail.com','',NULL,'Computer Science',10000000,1,'',0),(103,'Abdallah','Alishah','','',2020,'z1859969@students.niu.edu','',NULL,'Computer Science',10000000,1,'',0),(104,'Cory','Stojan','','',2020,'z1804761@students.niu.edu','',NULL,'Computer Science',10000000,1,'',0),(105,'Josh','Arms','','',2021,'z1841083@students.niu.edu','',NULL,'Computer Science',10000000,1,'',0),(106,'Joseph','Crase','','',2020,'joecrase@gmail.com','',NULL,'Computer Science',10000000,1,'',0),(107,'Hasnain','Attarwala','Male','Spring',2020,'hasnainclub@gmail.com','',NULL,'computer science',10000000,1,'',0),(108,'Emily','Ducatte','','',2020,'brightemma6@gmail.com','',NULL,'Computer Science',10000000,1,'',0),(109,'Jess','Grosshandler','','',2025,'jessegrosshandler@gmail.com','',NULL,'Computer Science ',10000000,1,'',0),(110,'Jacobs','Nava','','',2019,'jacobnava53@gmail.com','',NULL,'OMIS',10000000,1,'',0),(111,'Abigail','Burke','','',2019,'abby.burke20@yahoo.com','',NULL,'OMIS',10000000,1,'',0),(113,'Evan','Cinkovich','','',2020,'z1788690@students.niu.edu','',NULL,'Computer sciece',10000000,1,'',0),(115,'Kaylee','Rosenberger','','',2021,'kayleejorose@gmail.com','',NULL,'Biology',10000000,1,'',0),(116,'Aviraj ','Parmar ','','',2020,'avirajparmar74@gmail.com','',NULL,'Computer Science',10000000,1,'',0),(117,'Branden','Hidalgo','','',2020,'z1663752@students.niu.edu','',NULL,'Computer Sci/Psych',10000000,1,'',0),(118,'Darin','Brockmann','','Spring',2020,'darinbrockmann@gmail.com','',NULL,'Computer Science',10000000,1,'',0),(119,'Dominic','Onoh','','',2022,'z1842529@students.niu.edu','',NULL,'Computer Science ',10000000,1,'',0),(120,'zahra','abbas','','',2020,'z1816176@students.niu.edu','',NULL,'ElectricalEngineerin',10000000,1,'',0),(121,'Darius','Uscinaviciusd','','',2020,'uscinaviciusd@gmail.com','',NULL,'Computer Science',10000000,1,'',0),(122,'Adam','Olderr','','',2019,'Z1753651@students.niu.edu','',NULL,'Computer Science',10000000,1,'',0),(124,'Brooke','Marshall','Female','',2020,'z1794929@students.niu.edu','',NULL,'computer science',10000000,1,'',0),(125,'Alyssa','Anderson','','',2022,'z1855807@students.niu.edu','',NULL,'Computer Science',10000000,1,'',0),(126,'Donald','Adamczyk','','',2021,'dadamczyk@niu.edu','',NULL,'Computer Science ',10000000,1,'',0),(127,'Susanna','Eschbach','','',2021,'Z1855798@students.niu.edu','',NULL,'ELE Engineering',10000000,1,'',0),(128,'Laurette','Cornwell','2020','Spring',2020,'z1793184@students.niu.edu','',NULL,'OM&IS',10000000,1,'',0),(129,'Kalvin','Hill','','',2019,'z1690097@students.niu.edu','',NULL,'Kinesiology ',10000000,1,'',0),(130,'Harry','Chieng','','',2021,'harrychieng@gmail.com','',NULL,'Biology/Computer Sci',10000000,1,'',0),(131,'Jake','Driskell','Male','Spring',2020,'Driskelljc@gmail.com','',NULL,'OM&IS',10000000,1,'',0),(132,'Frank','Garcia','','',2020,'z1796265@students.niu.edu','',NULL,'Computer Science',10000000,1,'',0),(133,'srinidhi','vaddempudi','','',2020,'Z1861958@students.niu.edu','',NULL,'Computer Science',10000000,1,'',0),(134,'Christopher','Zamora','Male','',2020,'chrisjzamora8@gmail.com','',NULL,'OM&IS',10000000,1,'',0),(135,'Martin','Morales','Male','Spring',2020,'moralesmartin2797@gmail.com','',NULL,'Accountacy and OM&IS',10000000,1,'',0),(136,'Russ ','Devereaux','','',2020,'rdevereaux2@niu.edu','',NULL,'OMIS',10000000,1,'',0),(137,'shaharyar','tammimi','','',2020,'Tammimi.shaharyar@gmail.com','',NULL,'computer science',10000000,1,'',0),(138,'Christopher','Demkovich','Male',NULL,NULL,NULL,NULL,NULL,NULL,10000000,1,'https://innovatorphotos.s3.us-east-2.amazonaws.com/innovators/ChristopherDemkovich.jpg',0),(142,'test','test','male','Spring',2018,'test@test','test@test',NULL,'',10000000,1,'',0),(143,'test','test','female','Summer',2019,'test@test','test@test','1234567890','',10000000,1,'',0),(144,'Test','PostCody','Female','Fall',2021,'test','test','1234567890','',10000000,1,'',0),(145,'John','Smith','male','FA',20,'johnsmith20@discover.com','johnsmith20@discover.com','1234567890','',10000000,1,'https://innovatorphotos.s3.us-east-2.amazonaws.com/innovators/JohnSmith.jpg',0),(146,'Jacob','Drzewiecki','Male','Spring',2019,'jake.drzewiecki@gmail.com','jacobdrzewiecki@discover.com',NULL,'Electrical Engineering',20108945,1,NULL,0),(147,'Andy','Nguyen','Male','Fall',2019,'andre_n_nguyen@yahoo.com','andynguyen@discover.com',NULL,'Computer Science',20108947,1,NULL,0),(148,'Michael','Burstein','Male','Spring',2020,'todaymrb@gmail.com','michaelburstein@discover.com',NULL,'Computer Science',20108942,1,NULL,0),(149,NULL,NULL,'','',NULL,NULL,'',NULL,NULL,10000000,1,NULL,0),(150,NULL,NULL,'','',NULL,NULL,'',NULL,NULL,10000000,1,NULL,0),(151,'Rogerr','Oliva','Male','Fall',2020,'roliva75@yahoo.com','rogerroliva@discover.com',NULL,'OM&IS',20108951,1,NULL,0),(152,NULL,NULL,'','',NULL,NULL,'',NULL,NULL,10000000,1,NULL,0),(153,'Mohammed','Al Qaysi',NULL,NULL,NULL,NULL,'mohammedalqaysi@discover.com',NULL,NULL,NULL,1,NULL,0),(155,'Manan','Amin','Male','Spring',2020,NULL,'mananamin@discover.com',NULL,NULL,NULL,1,NULL,0),(156,'Michael','Arnold',NULL,NULL,NULL,NULL,'michaelarnold@discover.com',NULL,NULL,NULL,1,NULL,0),(157,'Jesus','Barajas',NULL,NULL,NULL,NULL,'jesusbarajas@discover.com',NULL,NULL,NULL,1,NULL,0),(158,'Dora','Cervantes',NULL,NULL,NULL,NULL,'doracervantes@discover.com',NULL,NULL,NULL,1,NULL,0),(159,'Karol','Dyrkacz','Male','Spring',2020,NULL,'karoldyrkacz@discover.com',NULL,NULL,NULL,1,NULL,0),(160,'Emily','Frost',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,NULL,0),(161,'Abdalla','Hafez',NULL,NULL,NULL,NULL,'abdallahafez@discover.com',NULL,NULL,NULL,1,NULL,0),(162,'Carlton','Hunt',NULL,NULL,NULL,NULL,'carltonhunt@discover.com',NULL,NULL,NULL,1,NULL,0),(163,'Chris','Jurrens',NULL,NULL,NULL,NULL,'chrisjurrens@discover.com',NULL,NULL,NULL,1,NULL,0),(164,'Ryan','Llamas',NULL,NULL,NULL,NULL,'ryanllamas@discover.com',NULL,NULL,NULL,1,NULL,0),(165,'Travis','Memishofski',NULL,NULL,NULL,NULL,'travismemishofski@discover.com',NULL,NULL,NULL,1,NULL,0),(166,'Akhila','Oommen',NULL,NULL,NULL,NULL,'akhilaoommen@discover.com',NULL,NULL,NULL,1,NULL,0),(167,'Manan','Patel',NULL,NULL,NULL,NULL,'mananpatel@discover.com',NULL,NULL,NULL,1,NULL,0),(168,'Utkarsh','Patel',NULL,NULL,NULL,NULL,'utkarshpatel@discover.com',NULL,NULL,NULL,1,NULL,0),(169,'Devin','Ratcliffe',NULL,NULL,NULL,NULL,'devinratcliffe@discover.com',NULL,NULL,NULL,1,NULL,0),(170,'Rachael','Richardson',NULL,NULL,NULL,NULL,'rachaelrichardson@discover.com',NULL,NULL,NULL,1,NULL,0),(171,'Alex','Rojas',NULL,'Spring',2021,NULL,'alexrojas@discover.com',NULL,NULL,NULL,1,NULL,0),(172,'Salman','Sattar',NULL,NULL,NULL,NULL,'salmansattar@discover.com',NULL,NULL,NULL,1,NULL,0),(173,'Tim','Schartman',NULL,NULL,NULL,NULL,'timschartman@discover.com',NULL,NULL,NULL,1,NULL,0),(174,'Aneesha','Varma','Female','Spring',2020,NULL,'aneeshavarma@discover.com',NULL,NULL,NULL,1,NULL,0),(175,'Pierce','Connors',NULL,NULL,NULL,NULL,'pierceconnors@discover.com',NULL,NULL,NULL,1,NULL,0),(176,'Joel','Suchomel',NULL,NULL,NULL,NULL,'joelsuchomel@discover.com',NULL,NULL,NULL,1,NULL,1),(177,'John','Smith','','',2019,'PleaseDeleteThisEntry@discover.com','',NULL,'Test',10000000,1,NULL,0),(178,'John','Smith','male','Fall',20,'johnsmith20@discover.com','johnsmith20@discover.com','1234567890','',10000000,1,NULL,0),(179,NULL,NULL,'','',NULL,NULL,'',NULL,NULL,10000000,1,NULL,0),(180,NULL,NULL,'','',NULL,NULL,'',NULL,NULL,10000000,1,NULL,0),(181,NULL,NULL,'','',NULL,NULL,'',NULL,NULL,10000000,1,NULL,0),(182,NULL,NULL,'','',NULL,NULL,'',NULL,NULL,10000000,1,NULL,0),(183,'John',NULL,'','',NULL,NULL,'',NULL,NULL,10000000,1,NULL,0),(184,'John','Smith','','',20,'johnsmith20@gmail.com','',NULL,'Computer Science',10000000,1,NULL,0),(185,'John','Smith','','',20,'johnsmith20@gmail.com','',NULL,'Computer Science',10000000,1,NULL,0),(186,'Andy','Nguyen','','',2019,'dfnafn@dfgnadnf.cpm','',NULL,'cs',10000000,1,NULL,0);
/*!40000 ALTER TABLE `Members` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Metrics`
--

DROP TABLE IF EXISTS `Metrics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Metrics` (
  `MetID` int(11) NOT NULL AUTO_INCREMENT,
  `Type` varchar(25) DEFAULT NULL,
  `Description` varchar(50) DEFAULT NULL,
  `IsActive` tinyint(1) DEFAULT NULL,
  `PrefID` int(11) DEFAULT NULL,
  PRIMARY KEY (`MetID`),
  KEY `PrefID` (`PrefID`),
  CONSTRAINT `Metrics_ibfk_1` FOREIGN KEY (`PrefID`) REFERENCES `Preferences` (`PrefID`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Metrics`
--

LOCK TABLES `Metrics` WRITE;
/*!40000 ALTER TABLE `Metrics` DISABLE KEYS */;
INSERT INTO `Metrics` VALUES (1,'Total','Number of students',1,1);
/*!40000 ALTER TABLE `Metrics` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Notifications`
--

DROP TABLE IF EXISTS `Notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Notifications` (
  `NotifyID` int(11) NOT NULL AUTO_INCREMENT,
  `Type` varchar(25) DEFAULT NULL,
  `Description` varchar(255) DEFAULT NULL,
  `Name` varchar(40) DEFAULT NULL,
  `Date` date DEFAULT NULL,
  `IsRead` tinyint(1) DEFAULT NULL,
  `AcctID` int(11) DEFAULT NULL,
  PRIMARY KEY (`NotifyID`),
  KEY `AcctID` (`AcctID`),
  CONSTRAINT `Notifications_ibfk_1` FOREIGN KEY (`AcctID`) REFERENCES `Accounts` (`AcctID`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Notifications`
--

LOCK TABLES `Notifications` WRITE;
/*!40000 ALTER TABLE `Notifications` DISABLE KEYS */;
INSERT INTO `Notifications` VALUES (1,'Alert','Updated Graduation Date','Jeremy Nielson','2019-02-12',0,1),(2,'Alert','Added Phone Number','Sean Wallace','2020-02-17',1,1);
/*!40000 ALTER TABLE `Notifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Preferences`
--

DROP TABLE IF EXISTS `Preferences`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Preferences` (
  `PrefID` int(11) NOT NULL AUTO_INCREMENT,
  `NavColor` varchar(7) DEFAULT NULL,
  `AcctID` int(11) DEFAULT NULL,
  PRIMARY KEY (`PrefID`),
  KEY `AcctID` (`AcctID`),
  CONSTRAINT `Preferences_ibfk_1` FOREIGN KEY (`AcctID`) REFERENCES `Accounts` (`AcctID`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Preferences`
--

LOCK TABLES `Preferences` WRITE;
/*!40000 ALTER TABLE `Preferences` DISABLE KEYS */;
INSERT INTO `Preferences` VALUES (1,'#008000',1);
/*!40000 ALTER TABLE `Preferences` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Projects`
--

DROP TABLE IF EXISTS `Projects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Projects` (
  `ProjectID` int(11) NOT NULL AUTO_INCREMENT,
  `Name` varchar(50) DEFAULT NULL,
  `Type` varchar(20) DEFAULT NULL,
  `Description` varchar(150) DEFAULT NULL,
  `Paragraph` varchar(500) DEFAULT NULL,
  `FrontEnd` varchar(50) DEFAULT NULL,
  `BackEnd` varchar(50) DEFAULT NULL,
  `RDS` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`ProjectID`)
) ENGINE=InnoDB AUTO_INCREMENT=45 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Projects`
--

LOCK TABLES `Projects` WRITE;
/*!40000 ALTER TABLE `Projects` DISABLE KEYS */;
INSERT INTO `Projects` VALUES (1,'code_orange Website','Website','Program Information: description, projects, employment, upcoming events, etc','The code_orange website is designed to be the face of the lab as it is outward facing. Anyone can check out the website and learn about the lab, ongoing projects, and how to apply to the program. We built everything you see right now!','React','Node.JS','MySQL'),(2,'Feedback Bubbles','Mobile App','App to allow feedback for meeting attendees','This app is intended to be used in conjunction with conferences. Users will have the app on their phone and connect to the specific conference via iBeacon. Here users can submit feedback bubbles (context dependent).','React-Native','Node.JS','MySQL'),(3,'Talent Acquisition','Mobile App','Capture Candidate info (resume, etc) electronically, replacing paperwork','An app is currently being created to aid in Discover job fairs. Users will be able to essentially create a quick submission of their photo, some basic information, and their resume. This allows better electronic transmission of information and faster processing.','React','Node.JS','MySQL'),(4,'Vendor Contact History Website','Website','Tool to track/update vendor info across Discover','This application is intended to alleviate and aid in the management of vendor contact information. They are creating a better system in which this information is kept, managed, and updated.','Angular','Springboot','MySQL'),(5,'Mgmt Approal/Delegation Tool','Website','One site for management to get all todo items needing action/decision','A better tool for management is being developed to aid in tracking changes and important scheduling that requires manager approval. This will allow managers to operate and monitor these schedules in one place.','React','Node.JS','MySQL'),(6,'NIU Innovation App','Mobile App','Create app that allows students to connect within the space','The application is utilizing mobile phones to check-in to the lab using bluetooth. You will be able to see who is in the lab and get some basic information about them.','React-Native','Node.JS','MySQL'),(7,'Change log rewrite','Website','Create change log to improve tracking of production impacting projects','A rework is currently underway of an older piece of Discover software regarding change logs. This application will allow better management and scheduling changes and change log control.','React','Node.JS','MongoDB'),(8,'MAP/code_orange Website','Website','Manager Approval Tool and code_orange website completion.','A completion of the Manager Aproval Portal as well as maintaining/completing the code_orange website, and starting and running social media for the lab.','React','Node.JS','MySQL'),(9,'Feedback Radar/ Valkyrie','Mobile App','One stop shop application for intern information.','A mobile application that allows users to see who is currently in the lab, request help, display a map view where a user will be able to see where innovators are in the space, scan for the closest room or white board and connect to other individuals who are also close to that space. Allows feedback to be sent as well.','React-Native','Node.JS','MySQL'),(12,'VR Lab Tour','VR Application','A VR space that shows a tour of the code_orange lab.','A Virtual 360 image tour of the code_orange lab. Allows users to explore the code_orange space that Discover has provided for the interns to use.','React-360','Node.JS','MongoDB'),(13,'Discover Account Center','VR Application','A VR space that tracks spending and organizes transactions.','A Spend Analyzer application which allows users to track their spending and organize their transactions in a VR space.','Angular','Node.JS','MySQL'),(15,'360 Student Evaluation','Web Application','A website for constructive feedback for group projects.','A 360 review website allowing team members, mentors, PO, etc. to rate each other and give constructive criticism to those you’re working with in a project together','VueJS','Django','PostgreSQL'),(16,'VR: Brand Command Center','VR Application','Displays all information, feeds, and social media for any company.','VR center that displays all information including Discover and competitors in the tag. This can include feeds and social media from multiple plaforms.','React-360','Node.JS','MySQL'),(17,'Amazon DeepLens Facial Recognition','Amazon Deep Lens','Facial recognition and responses for users in the lab.','An Amazon DeepLens project that will recognize the faces of people in the lab that walk by the device and print a personalized message for them.','React','Lambda','N/A'),(18,'Applicant Tracking & Dashboard','Website','Keep track of all applicants, interns, and hires from the code_orange project','A website that is used to keep track of all potential, current, and former members of the code_orange program.','React','Node.JS','MySQL'),(19,'Cash Back Bonus Application','AR Application','AR app that allows users to access stores with information about the Discover Cash Back Bonus Program','An AR mobile application allowing users to view their favorite stores through their device in real time with information about the Discover Cash Back Bonus program.','React-Native','Node.JS','DynamoDB'),(20,'AR DMS/Huddle board application','AR Application','AR platform that allows users to explore information regarding team projects.','An AR experience for teams that use the Customer Engagement Platform (CEP) room at Riverwoods. Users will receive additional information, documentation, and any relevant external links when viewing a project card.','React','Unity','Vuforia'),(21,'Cole Test','Website','Test stuff',NULL,'Test front','Test back','Test RDS'),(22,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(23,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(24,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(25,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(26,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(27,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(28,'testPostCody','Mobile','test and stuff',NULL,'test','test2','test3'),(29,'TestPost2','Mobile','test',NULL,'test','test','test'),(30,'','Website','',NULL,'','',''),(31,'Change Log: Production','Website','Continue on the Change log project to move it to production using PCF.','Continued on the Change log project to move it to production using PCF. In addition, field tested the application to ensure it meets the business need and made appropriate changes as needed.','React','Node.JS','MongoDB'),(32,'CEP VP360 AR','Mobile','CEP VP360 is a tool that allows sharing of progress on agreed upon work.','Continued development of the CEP Augmented Reality App for the Customer Engagement Platforms room. Uses Jira through APIs as the data store/source for project data. Supports a room tour feature as well as latest project status and detailed information on each card.','Unity','Node.JS','DynamoDB'),(33,'RRT Dashboard','Website','Create a responsive web application that appears as a dashboard of icons representing different teams needed on an RRT (support) call.','The owner of the support problem (e.g. system is down or slow) should be able to create a new dashboard, select the different teams involved from a list and create the dashboard. Each dashboard has a unique identifier that others use to monitor a specific dashboard.','React','Springboot','MySQL'),(34,'code_orange Chat Bot/ Echo','Chat Bot','Create a chatbot that can answer questions about the code_orange program. ','Integrate the chat bot using the APIs from the Brand Central command center to allow users to ask questions about Discover in social media. Also, use the APIs from the Campus Innovator DB to answer questions about Campus Innovators such as: “How many campus innovators are there?” and “What projects are being worked on?” etc.','React','Flask','MySQL'),(35,'Brand Central: Unity','Virtual Reality','Restructure original project to also include social media with competitors and rewrite it for Unity.','Created a VR app for the Oculus Go that allows a user to input a brand name (such as Discover or Nike) and search the social media world to determine what the world is saying right now. Search Twitter, youtube, facebook, news feeds, etc.','Unity','Node.JS',NULL),(36,'Campus Innovator API Service','API','Further develop the API and credential service originally developed for the code_orange Manager Application',NULL,'React','Node.JS','MySQL'),(37,'Spend Analyzer Rewrite','Website','Rewrite the Spend Analyzer product, currently written in Flash, from the production Discover Account Center on Discover.com in React.','The Spend Analyzer product from the Discover Account Center on Discover.com will be rewritten in React. The functionality and look & feel should remain consistent with current design. The interface for data will also remain the same. When complete, the intention is this will be released on Discover.com for use by Discover customers!','React',NULL,NULL),(38,'Sanity Check','API','Checks for Sanity',NULL,'React.JS','Node.JS','MySQL'),(39,'code_orange website','Website','Create API to manipulate data on Campus Innovators for use by other code_orange applications. Also, finalize code_orange website for production.','Leveraged the database created last semester (code_orange manager application) and used our API to contain and manipulate data on Campus Innovators for use by other code_orange applications. Other apps will use our API to authenticate and retrieve info on the campus innovators instead of each group duplicating functionality. The API is documented with SwaggerDocs to allow others to learn about our API and test it. We are also responsible for maintaining and publishing the code_orange website!','React','Node.JS','MySQL'),(40,'Vendor Central','Website','Create an application to collect all vendor touchpoints and store them in one location.','Discover works with many vendors. These vendor engagements include contractual agreements, potential agreements, general fact-finding conversations, and even speaking with vendors at conferences. With so many areas speaking with vendors, often these conversations are not documented for other employees who may also be looking to speak with the vendor. This application will allow others to search vendors to determine Discover’s previous engagement with the vendor.','Angular','Node.JS','MySQL'),(41,'Discover AR Viewer','AR Application','Create an augmented-reality app for a mobile phone that displays flags for selected addresses with other associated information.','When an address is detected in the view of the phone, a flag will display over the establishment with relevant and current information on the building. Functionality to switch between a 2D overhead map and the AR view will give a reference point to where the user is.','Unity','Stitch','MongoDB'),(42,'Discover Employee Mobile App','Mobile','Consolidate the functionality of the mobile apps created in previous semesters into a single Discover mobile app for employees.','The app include the Proximity Feedback function as well as Employee Locator. Worked with the CEP AR App team to include their functionality into the single mobile app. The functions of the app are exposed through APIs for other teams to also use.','React','Node.JS','MySQL'),(44,'code_orange website','Website','Maintaining the website',NULL,'React','Node.js','MySQL');
/*!40000 ALTER TABLE `Projects` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Reservations`
--

DROP TABLE IF EXISTS `Reservations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Reservations` (
  `ReserveID` int(11) NOT NULL AUTO_INCREMENT,
  `Description` varchar(255) DEFAULT NULL,
  `Email` varchar(320) DEFAULT NULL,
  `Start` time DEFAULT NULL,
  `End` time DEFAULT NULL,
  `Date` date DEFAULT NULL,
  `RoomID` int(11) DEFAULT NULL,
  `TeamID` int(11) DEFAULT NULL,
  PRIMARY KEY (`ReserveID`),
  KEY `TeamID` (`TeamID`),
  CONSTRAINT `Reservations_ibfk_1` FOREIGN KEY (`TeamID`) REFERENCES `Teams` (`TeamID`)
) ENGINE=InnoDB AUTO_INCREMENT=1312 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Reservations`
--

LOCK TABLES `Reservations` WRITE;
/*!40000 ALTER TABLE `Reservations` DISABLE KEYS */;
INSERT INTO `Reservations` VALUES (219,'atlas work day','ldamler@discover.com','07:00:00','09:00:00','2019-04-18',1,1),(221,'atlas meeting','ldamler@discover.com','07:30:00','09:30:00','2019-04-18',3,1),(224,'team 3 meeting','mattblauw@discover.com','12:00:00','14:00:00','2019-04-18',5,3),(229,'Atlas Meeting and such','pklesyk@discover.com','14:00:00','16:00:00','2019-04-25',3,NULL),(230,'Atlas meeting cont.','pklesyk@discover.com','16:00:00','17:00:00','2019-04-25',3,NULL),(236,'Team 1 Meeting','mattblauw@discover.com','12:00:00','14:00:00','2019-04-26',1,1),(237,'AWS Meeting','mattblauw@discover.com','14:00:00','16:00:00','2019-04-26',2,1),(238,'Team 1/11 Meeting','mattblauw@discover.com','11:00:00','12:30:00','2019-04-26',3,1),(243,'Demo Practice','pklesyk@discover.com','07:30:00','09:30:00','2019-04-25',5,NULL),(248,'7','adelaideadams@discover.com','12:00:00','14:00:00','2019-06-06',1,7),(249,'','adelaideadams@discover.com','14:30:00','16:30:00','2019-06-06',3,7),(251,'Scrumptious 2','andynguyen@discover.com','10:00:00','14:00:00','2019-06-07',4,NULL),(277,'Changed via API','jacobdrzewiecki@discover.com','14:30:00','15:00:00','2019-06-10',2,4),(288,'yoyoy',NULL,'14:00:00','15:30:00','2019-06-11',3,NULL),(295,'lol',NULL,'16:00:00','18:00:00','2019-06-11',3,NULL),(301,'lolol',NULL,'16:00:00','18:00:00','2019-06-11',4,NULL),(306,'gfgfg',NULL,'18:30:00','20:30:00','2019-06-12',2,NULL),(308,'Team 1 PO Meeting','johnsmith20@discover.com','07:00:00','10:00:00','2019-07-19',4,1),(309,'top','michaelpacyga@discover.com','07:00:00','09:00:00','2019-06-12',2,11),(311,'pastopenhrs','andynguyen@discover.com','18:30:00','20:30:00','2019-06-12',4,NULL),(312,'pastopenhrs2','andynguyen@discover.com','19:00:00','20:30:00','2019-06-12',5,NULL),(313,'testbeforehrs','andynguyen@discover.com','07:00:00','08:30:00','2019-06-12',3,NULL),(314,'testbeforehrs2','andynguyen@discover.com','07:00:00','07:30:00','2019-06-12',4,NULL),(318,'fdgdsf','andynguyen@discover.com','07:00:00','08:30:00','2019-06-13',4,NULL),(319,'dasfad','andynguyen@discover.com','07:00:00','08:30:00','2019-06-13',3,NULL),(320,'cx xv','andynguyen@discover.com','17:30:00','19:00:00','2019-06-13',1,NULL),(321,'change','michaelpacyga@discover.com','16:00:00','17:30:00','2019-06-14',4,11),(322,';alkdj','adelaideadams@discover.com','15:30:00','17:30:00','2019-06-14',1,8),(323,'test','andynguyen@discover.com','08:30:00','10:00:00','2019-06-14',2,NULL),(325,'yes','michaelburstein@discover.com','08:30:00','10:00:00','2019-06-17',5,11),(334,'wds','michaelpacyga@discover.com','07:30:00','09:00:00','2019-06-17',3,11),(339,'Holla!','jacobdrzewiecki@discover.com','08:00:00','09:30:00','2019-06-17',4,11),(340,'Meeting with PO','michaelburstein@discover.com','07:00:00','09:00:00','2019-06-17',1,11),(342,'mobile test','andynguyen@discover.com','07:00:00','07:30:00','2019-06-18',1,NULL),(343,'mobiltest','andynguyen@discover.com','13:30:00','14:00:00','2019-06-18',2,NULL),(344,'resetest','andynguyen@discover.com','17:00:00','19:00:00','2019-06-18',3,NULL),(346,'','danielomalley@discover.com','11:00:00','11:30:00','2019-06-19',2,NULL),(349,'','danielomalley@discover.com','12:30:00','13:00:00','2019-06-19',3,NULL),(350,'','danielomalley@discover.com','12:30:00','13:00:00','2019-06-19',1,NULL),(351,'yeet','jacobdrzewiecki@discover.com','18:00:00','19:00:00','2019-06-19',1,11),(352,'','andynguyen@discover.com','07:00:00','09:00:00','2019-06-20',1,NULL),(354,'bepis','danielomalley@discover.com','08:00:00','10:00:00','2019-06-21',2,7),(355,'help','michaelpacyga@discover.com','07:00:00','09:00:00','2019-06-21',3,11),(367,'test','andynguyen@discover.com','07:00:00','09:00:00','2019-06-21',1,7),(370,'','andynguyen@discover.com','11:00:00','13:00:00','2019-06-21',1,NULL),(399,'works','andynguyen@discover.com','08:00:00','10:00:00','2019-06-24',1,5),(404,'','andynguyen@discover.com','09:00:00','09:30:00','2019-06-24',3,NULL),(405,'','andynguyen@discover.com','09:00:00','09:30:00','2019-06-24',4,NULL),(406,'time test','andynguyen@discover.com','16:00:00','16:30:00','2019-06-24',1,NULL),(414,'hello 1','jacobdrzewiecki@discover.com','11:00:00','12:00:00','2019-06-25',2,7),(415,'new description','jacobdrzewiecki@discover.com','09:30:00','11:00:00','2019-06-25',2,7),(416,'hi 3','jacobdrzewiecki@discover.com','12:30:00','13:30:00','2019-06-25',4,7),(417,'hi 4','jacobdrzewiecki@discover.com','12:30:00','13:30:00','2019-06-25',4,7),(418,'Hello from postman','jacobdrzewiecki@discover.com','09:00:00','15:00:00','2019-06-25',5,7),(424,'new descr','andynguyen@discover.com','00:00:00','00:00:00','2019-06-24',5,7),(434,'test','michaelburstein@discover.com','15:30:00','17:30:00','2019-06-25',2,7),(436,'delete','michaelburstein@discover.com','13:00:00','15:00:00','2019-06-25',2,11),(437,'ugh','michaelburstein@discover.com','11:30:00','13:30:00','2019-06-25',1,11),(438,'delete','michaelburstein@discover.com','13:30:00','15:30:00','2019-06-25',3,11),(440,'yes','michaelburstein@discover.com','14:00:00','16:00:00','2019-06-25',1,7),(445,'color','jacobdrzewiecki@discover.com','09:00:00','10:00:00','2019-06-26',5,7),(447,'hello','jacobdrzewiecki@discover.com','11:30:00','13:00:00','2019-06-26',2,7),(448,'hi','jacobdrzewiecki@discover.com','12:30:00','13:30:00','2019-06-26',1,7),(482,'','andynguyen@discover.com','00:00:00','00:00:00','2019-06-27',3,7),(487,'testing','jacobdrzewiecki@discover.com','00:00:00','00:00:00','2019-06-28',2,7),(493,'no.','adelaideadams@discover.com','13:00:00','14:30:00','2019-06-29',3,7),(494,'andy','danielomalley@discover.com','00:00:00','00:00:00','2019-06-28',2,7),(497,'dfsfsd','michaelpacyga@discover.com','08:30:00','10:30:00','2019-06-28',3,7),(499,'ITS A MONDAY','danielomalley@discover.com','09:30:00','11:30:00','2019-06-28',1,7),(514,'','andynguyen@discover.com','08:00:00','09:00:00','2019-07-01',2,7),(541,'IT IS WEDNESDAY MY DUDES        !!!!       IT IS WEDNESDAY MY DUDES','jacobdrzewiecki@discover.com','07:00:00','19:00:00','2019-07-03',3,7),(563,'hello','jacobdrzewiecki@discover.com','09:00:00','10:00:00','2019-07-01',3,7),(564,'fool','jacobdrzewiecki@discover.com','12:30:00','14:00:00','2019-07-01',2,7),(595,'','danielomalley@discover.com','09:00:00','11:00:00','2019-07-02',1,7),(599,'','andynguyen@discover.com','09:00:00','09:30:00','2019-07-01',5,7),(615,'description','andynguyen@discover.com','11:00:00','12:00:00','2019-07-03',2,7),(648,'Super user change other team','jacobdrzewiecki@discover.com','12:00:00','16:00:00','2019-07-09',4,50),(678,'','andynguyen@discover.com','07:00:00','09:00:00','2019-07-08',1,7),(681,'TEAM 7','jacobdrzewiecki@discover.com','13:00:00','14:30:00','2019-07-09',1,7),(688,'Email test','jacobdrzewiecki@discover.com','07:30:00','09:00:00','2019-07-09',1,7),(698,'final test','danielomalley@discover.com','07:00:00','09:00:00','2019-07-09',5,7),(717,'2nd','jacobdrzewiecki@discover.com','09:00:00','11:00:00','2019-07-10',1,7),(720,'','danielomalley@discover.com','11:30:00','13:00:00','2019-07-10',3,7),(721,'','danielomalley@discover.com','08:30:00','09:30:00','2019-07-10',3,7),(746,'','jacobdrzewiecki@discover.com','08:30:00','09:30:00','2019-07-11',3,7),(747,'','andynguyen@discover.com','08:00:00','10:00:00','2019-07-11',1,7),(748,'second','jacobdrzewiecki@discover.com','09:30:00','11:30:00','2019-07-11',3,7),(752,'change date correctly','andynguyen@discover.com','09:30:00','11:00:00','2019-07-13',1,7),(753,'not there','andynguyen@discover.com','09:00:00','11:00:00','2019-07-13',1,7),(758,'bruh','andynguyen@discover.com','09:00:00','11:00:00','2019-07-14',1,7),(759,'wrkkk','andynguyen@discover.com','09:00:00','11:00:00','2019-07-14',1,7),(761,'','danielomalley@discover.com','09:30:00','11:00:00','2019-07-13',3,7),(763,'','danielomalley@discover.com','07:00:00','07:30:00','2019-07-14',1,7),(775,'','andynguyen@discover.com','09:00:00','10:00:00','2019-07-12',1,7),(776,'2nd','andynguyen@discover.com','12:00:00','14:00:00','2019-07-12',3,7),(777,'3rd','jacobdrzewiecki@discover.com','10:30:00','11:30:00','2019-07-12',3,7),(779,'sprint','danielomalley@discover.com','07:00:00','09:00:00','2019-07-15',5,7),(781,'1st','rogerroliva@discover.com','07:00:00','08:30:00','2019-07-16',1,7),(782,'2nd','rogerroliva@discover.com','08:30:00','10:00:00','2019-07-16',1,7),(783,'Resthree','danielomalley@discover.com','07:00:00','08:30:00','2019-07-15',2,7),(786,'','andynguyen@discover.com','16:00:00','17:30:00','2019-07-15',1,7),(815,'No','samuelpiecz@discover.com','09:30:00','10:00:00','2019-07-17',3,10),(823,'new','andynguyen@discover.com','07:00:00','09:00:00','2019-07-19',1,7),(841,'','andynguyen@discover.com','08:30:00','09:00:00','2019-07-17',3,7),(842,'','andynguyen@discover.com','07:00:00','07:30:00','2019-07-18',2,7),(844,'','andynguyen@discover.com','09:00:00','09:30:00','2019-07-18',1,7),(845,'','andynguyen@discover.com','10:30:00','11:00:00','2019-07-17',3,7),(846,'test','andynguyen@discover.com','07:30:00','08:00:00','2019-07-17',3,7),(858,'Rogerr Testing','rogerroliva@discover.com','13:00:00','15:00:00','2019-07-19',3,7),(859,'new','andynguyen@discover.com','09:00:00','09:30:00','2019-07-19',2,7),(861,'hi','aneeshavarma@discover.com','12:00:00','14:00:00','2019-07-22',1,5),(884,'hey','andynguyen@discover.com','07:30:00','09:00:00','2019-07-23',2,7),(886,'','andynguyen@discover.com','08:30:00','10:30:00','2019-07-23',4,7),(889,'','michaelpacyga@discover.com','12:30:00','13:00:00','2019-07-22',3,7),(896,'new day','andynguyen@discover.com','07:00:00','08:00:00','2019-07-25',1,7),(905,'','danielomalley@discover.com','08:00:00','08:30:00','2019-07-24',3,7),(906,'','danielomalley@discover.com','10:00:00','10:30:00','2019-07-24',3,7),(911,'','michaelpacyga@discover.com','11:30:00','13:30:00','2019-07-25',3,7),(912,'','michaelpacyga@discover.com','16:30:00','17:00:00','2019-07-25',3,7),(950,'Team 1 PO Meeting','michaelpacyga@discover.com','07:00:00','09:00:00','2019-07-25',4,7),(979,'hello from postman','support@countrydonuts.com','12:00:00','14:00:00','0000-00-00',1,7),(980,'hello from postman','support@countrydonuts.com','12:00:00','14:00:00','0000-00-00',1,7),(1012,'','michaelpacyga@discover.com','09:00:00','11:00:00','2019-07-27',2,7),(1013,'','michaelpacyga@discover.com','12:30:00','14:30:00','2019-07-27',1,7),(1016,'','michaelpacyga@discover.com','14:30:00','16:30:00','2019-07-27',3,7),(1042,'hi','jacobdrzewiecki@discover.com','09:30:00','11:30:00','2019-07-29',3,7),(1047,'Team 1 PO Meeting','johnsmith20@discover.com','07:00:00','09:00:00','2019-08-19',4,1),(1052,'goovi smoovi','danielomalley@discover.com','08:30:00','10:00:00','2019-07-29',1,7),(1053,'testing','rogerroliva@discover.com','11:00:00','13:00:00','2019-07-29',1,7),(1091,'Team 7 PO Meeting','adelaideadams@discover.com','12:00:00','13:00:00','2019-07-19',4,7),(1152,'PO Meeting','michaelpacyga@discover.com','08:00:00','08:30:00','2208-01-15',2,7),(1154,'','rogerroliva@discover.com','09:30:00','11:00:00','2019-08-04',1,7),(1156,'','rogerroliva@discover.com','12:00:00','13:30:00','2019-08-04',1,7),(1237,'1','adelaideadams@discover.com','07:00:00','08:30:00','2019-08-03',1,7),(1239,'3','adelaideadams@discover.com','12:00:00','14:00:00','2019-08-03',3,7),(1256,'jho','michaelpacyga@discover.com','11:00:00','13:00:00','2019-07-30',4,7),(1258,'','andynguyen@discover.com','07:00:00','08:30:00','2019-07-30',1,7),(1259,'','andynguyen@discover.com','12:00:00','14:00:00','2019-07-30',1,7),(1262,'Test','adelaideadams@discover.com','09:00:00','11:00:00','2019-07-28',2,7),(1279,'','michaelpacyga@discover.com','10:30:00','12:30:00','2019-08-01',3,7),(1282,'Demonstration','andynguyen@discover.com','08:30:00','10:00:00','2019-08-01',4,7),(1290,'','rogerroliva@discover.com','09:00:00','11:00:00','2019-08-07',3,7),(1296,'','andynguyen@discover.com','10:30:00','12:30:00','2019-08-05',5,7),(1298,'Tuff Demo','samuelpiecz@discover.com','11:30:00','13:30:00','2019-08-06',4,10),(1299,'Chatbot Demo','jacobdrzewiecki@discover.com','10:30:00','12:30:00','2019-08-06',3,4),(1305,'meeting','katieberendt@discover.com','14:00:00','16:00:00','2019-08-06',1,3),(1306,'PO Meeting','katieberendt@discover.com','07:30:00','09:00:00','2019-08-06',5,3),(1307,'Team 7 PO Meeting','adelaideadams@discover.com','08:30:00','10:30:00','2019-08-06',2,7),(1308,'Demo Practice','adelaideadams@discover.com','13:00:00','15:00:00','2019-08-06',5,7),(1311,'Demo!','andynguyen@discover.com','13:00:00','15:00:00','2019-08-06',2,7);
/*!40000 ALTER TABLE `Reservations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Reservations_TEST`
--

DROP TABLE IF EXISTS `Reservations_TEST`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Reservations_TEST` (
  `ReserveID` int(11) NOT NULL AUTO_INCREMENT,
  `Description` varchar(255) DEFAULT NULL,
  `Email` varchar(320) DEFAULT NULL,
  `Start` time DEFAULT NULL,
  `End` time DEFAULT NULL,
  `Date` date DEFAULT NULL,
  `RoomID` int(11) DEFAULT NULL,
  `TeamID` int(11) DEFAULT NULL,
  PRIMARY KEY (`ReserveID`),
  KEY `TeamID` (`TeamID`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Reservations_TEST`
--

LOCK TABLES `Reservations_TEST` WRITE;
/*!40000 ALTER TABLE `Reservations_TEST` DISABLE KEYS */;
INSERT INTO `Reservations_TEST` VALUES (3,'Hello Team 4! Enjoy your test table.','jacobdrzewiecki@discover.com','07:00:00','08:30:00','2019-06-27',1,7),(4,'Hello from postman 2','jacobdrzewiecki@discover.com','15:00:00','16:00:00','2019-06-25',5,7),(5,'Team PO meeting','zachhueneke@discover.com','07:00:00','09:00:00','2019-06-25',5,7),(6,'Team PO meeting','zachhueneke@discover.com','07:00:00','09:00:00','2019-06-25',5,7),(7,'Team PO meeting','zachhueneke@discover.com','07:00:00','09:00:00','2019-06-25',5,7),(8,'Team PO meeting','zachhueneke@discover.com','07:00:00','09:00:00','2019-06-25',5,7);
/*!40000 ALTER TABLE `Reservations_TEST` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Role`
--

DROP TABLE IF EXISTS `Role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Role` (
  `RoleID` int(11) NOT NULL AUTO_INCREMENT,
  `Type` varchar(25) DEFAULT NULL,
  `Status` varchar(25) DEFAULT NULL,
  `Description` varchar(255) DEFAULT NULL,
  `Date` date DEFAULT NULL,
  `MemberID` int(11) NOT NULL,
  PRIMARY KEY (`RoleID`),
  KEY `MemberID` (`MemberID`),
  CONSTRAINT `Role_ibfk_1` FOREIGN KEY (`MemberID`) REFERENCES `Members` (`MemberID`)
) ENGINE=InnoDB AUTO_INCREMENT=178 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Role`
--

LOCK TABLES `Role` WRITE;
/*!40000 ALTER TABLE `Role` DISABLE KEYS */;
INSERT INTO `Role` VALUES (1,'Former Intern','Full-Time Hire','Working third semester at code_orange.','2019-06-24',1),(2,'Former Intern','Full Time Hire','Worked two semesters at code_orange. Full time Discover employee.','2019-06-07',2),(3,'Intern','Active','Third Semester at code_orange','2019-08-02',3),(4,'Former Intern','Full-time hire','Graduated and working full time for Discover Financial','2019-04-15',4),(5,'Intern','Active','Third semester at code_orange.','2019-06-07',5),(6,'Former Intern','Full Time Hire','Worked two semesters at code_orange. Full Time Discover Hire','2019-06-07',6),(7,'Former Intern','Inactive','Worked two semesters at code_orange','2019-06-07',7),(8,'Former Intern','Inactive','Worked two semesters at code_orange','2019-06-07',8),(9,'Former Intern','Unknown','N/A','2019-04-15',9),(10,'Former Intern','Active','Worked two semesters at code_orange. Riverwoods Intern','2019-06-07',10),(11,'Former Intern','Full Time Hire','Worked two semesters at code_orange. Full time Discover employee','2019-06-07',11),(12,'Former Intern','Full-time Hire','Worked two semesters at code_orange. Full time Discover employee.','2019-06-07',12),(13,'Former Intern','Full Time Hire','Worked two semesters at code_orange. Full time Discover employee.','2019-06-07',13),(14,'Former Intern','Inactive','Worked two semesters at code_orange.','2019-06-07',14),(15,'Former Intern','Unknown','Worked one semester','2019-04-15',15),(16,'Former Intern','Unknown','Worked one semester','2019-04-15',16),(17,'Former Intern','Inactive','Worked two semesters at code_orange. Hired at CME Group','2019-06-07',17),(18,'Former Intern','Inactive','Worked two semesters at code_orange.','2019-06-07',18),(19,'Former Intern','Graduate Student','Continuing grad program, Interest in continuing code_orange / working for Discover.','2019-06-11',19),(20,'Former Intern','Inactive','Worked two semesters at code_orange.','2019-06-07',20),(21,'Former Intern','Inactive','Worked two semesters at code_orange.','2019-06-07',21),(22,'Former Intern','Inactive','Worked two semesters at code_orange.','2019-06-07',22),(23,'Former Intern','Inactive','Worked two semesters at code_orange. Doing intern program elsewhere for summer.','2019-06-07',23),(24,'Intern','Active','Working third semester at code_orange','2019-06-07',24),(25,'Former Intern','Unknown','Worked one semester','2019-04-15',25),(26,'Former Intern','Inactive','Worked two semesters at code_orange.','2019-06-07',26),(27,'Former Intern','Graduated','Deployed to Guam','2019-06-07',27),(28,'Former Intern','Active','Worked two semesters at code_orange. Riverwoods Intern','2019-06-07',28),(29,'Former Intern','Inactive','Worked two semesters at code_orange.','2019-06-07',29),(30,'Former Intern','Full-time Hire','Graduated and working full time for Discover Financial','2019-06-07',30),(31,'Former Intern','Inactive','Worked two semesters at code_orange.','2019-06-07',31),(32,'Former Intern','Unknown','Worked one semester','2019-04-15',32),(33,'Former Intern','Unknown','Worked one semester','2019-04-15',33),(34,'Former Intern','Full Time Hire','Worked two semesters at code_orange. Full time Discover employee.','2019-06-07',34),(35,'Intern','Active','Working third semester at code_orange.','2019-06-07',35),(36,'Former Intern','Inactive','Worked two semesters at code_orange.','2019-06-07',36),(37,'Former Intern','Unknown','Worked one semester','2019-02-14',37),(38,'Intern','Active','Working second semester at code_orange','2019-06-07',38),(39,'Intern','Active','Working second semester at code_orange','2019-02-14',39),(40,'Former Intern','Inactive','Worked two semesters at code_orange.','2019-06-07',40),(41,'Former Intern','Inactive','Not brought back','2019-02-14',41),(42,'Former Intern','Inactive','Worked one semester','2019-06-07',42),(43,'Former Intern','Active','Worked one semester.','2019-06-07',43),(44,'Former Intern','Inactive','Worked one semester.','2019-06-07',44),(45,'Former Intern','Quit','Disruptive team member, quit','2019-02-14',45),(46,'Intern','Active','Working second semester at code_orange.','2019-06-07',46),(47,'Intern','Active','Working second semester at code_orange.','2019-06-07',47),(48,'Former Intern','Inactive','Worked one semester','2019-06-07',48),(49,'Former Intern','Active','Worked one semester','2019-06-07',49),(50,'Former Intern','Full Time Hire','Worked one semester. Full time Discover employee.','2019-06-07',50),(51,'Former Intern','Inactive','Worked one semester.','2019-06-07',51),(52,'Intern','Active','Working second semester at code_orange.','2019-07-19',52),(53,'Former Intern','Inactive','Worked one semester at code_orange.','2019-06-07',53),(54,'Former Intern','Inactive','Worked one semester at code_orange.','2019-06-07',54),(55,'Intern','Active','Working first semester at code_orange','2019-06-07',55),(56,'Former intern','Inactive','Worked one semester at code_orange.','2019-06-07',56),(57,'Intern','Active','Working second semester at code_orange.','2019-07-19',57),(58,'Intern','Active','Working second semester at code_orange.','2019-06-07',58),(59,'Intern','Active','Working second semester at code_orange.','2019-06-07',59),(60,'Intern','Active','Working second semester at code_orange.','2019-06-07',60),(61,'Former Intern','Inactive','Worked one semester.','2019-06-07',61),(62,'Intern','Active','Working second semester at code_orange.','2019-07-16',62),(63,'Intern','Active','Working second semester at code_orange.','2019-06-07',63),(64,'Former Intern','Quit','Worked one semester at code orange.','2019-06-07',64),(65,'Intern','Active','Working second semester at code_orange.','2019-07-19',65),(66,'Intern','Active','Working second semester at code_orange.','2019-06-07',66),(67,'Intern','Active','Working second semester at code_orange.','2019-07-19',67),(68,'Intern','Active','Working second semester at code_orange.','2019-07-19',68),(69,'Intern','Active','Working second semester at code_orange.','2019-07-19',69),(70,'Intern','Active','Working second semester at code_orange.','2019-07-19',70),(71,'Former Intern','Inactive','Worked one semester','2019-06-07',71),(72,'Intern','Active','Working second semester at code_orange.','2019-06-07',72),(73,'Intern','Active','Working second semester at code_orange.','2019-07-19',73),(74,'Former Intern','Inactive','Worked one semester at code_orange.','2019-06-07',74),(75,'Intern','Active','Working second semester at code_orange.','2019-07-19',75),(76,'Intern','Active','Working second semester at code_orange.','2019-06-07',76),(77,'Intern','Active','Working second semester at code_orange.','2019-06-07',77),(78,'Intern','Active','Working second semester at code_orange.','2019-06-07',78),(79,'Former Intern','Full Time Hire','Worked one semester at code_orange. Full time Discover employee.','2019-06-07',79),(80,'Intern','Active','Working second semester at code_orange.','2019-07-19',80),(81,'Intern','Active','Working second semester at code_orange.','2019-06-07',81),(82,'Former Intern','Inactive','Worked one semester at code_orange.','2019-06-07',82),(83,'Intern','Active','Working second semester at code_orange.','2019-06-07',83),(84,'Intern','Active','Working second semester at code_orange.','2019-07-19',84),(85,'Former Intern','Inactive','Worked one semester at code_orange.','2019-06-07',85),(86,'Former Intern','Inactive','Worked one semester at code_orange.','2019-06-07',86),(87,'Former Intern','Inactive','Worked one semester at code_orange.','2019-06-07',87),(88,'Former Intern','Inactive','Worked one semester at code_orange.','2019-06-07',88),(89,'Product Owner','Active','Manages Team 11 and the Lab','2019-02-15',89),(90,'Open House','Attendee','Spring code_orange open house','2019-03-28',90),(91,'Intern','Active','Working first semester at code_orange.','2019-07-22',91),(92,'Open House','Attendee','Spring code_orange open house','2019-03-28',92),(94,'Open House','Attendee','Spring code_orange open house','2019-03-28',94),(96,'Open House','Attendee','Spring code_orange open house','2019-03-28',96),(97,'Open House','Attendee','Spring code_orange open house','2019-03-28',97),(98,'Open House','Attendee','Spring code_orange open house','2019-03-28',98),(99,'Open House','Attendee','Spring code_orange open house','2019-03-28',99),(100,'Open House','Attendee','Spring code_orange open house','2019-03-28',100),(101,'Open House','Attendee','Spring code_orange open house','2019-03-28',101),(102,'Open House','Attendee','Spring code_orange open house','2019-03-28',102),(103,'Open House','Attendee','Spring code_orange open house','2019-03-28',103),(104,'Open House','Attendee','Spring code_orange open house','2019-03-28',104),(105,'Open House','Attendee','Spring code_orange open house','2019-03-28',105),(106,'Open House','Attendee','Spring code_orange open house','2019-03-28',106),(107,'Intern','Active','Working first semester at code_orange.','2019-07-19',107),(108,'Open House','Attendee','Spring code_orange open house','2019-03-28',108),(109,'Open House','Attendee','Spring code_orange open house','2019-03-28',109),(110,'Open House','Attendee','Spring code_orange open house','2019-03-28',110),(111,'Open House','Attendee','Spring code_orange open house','2019-03-28',111),(113,'Open House','Attendee','Spring code_orange open house','2019-03-28',113),(115,'Open House','Attendee','Spring code_orange open house','2019-03-28',115),(116,'Open House','Attendee','Spring code_orange open house','2019-03-28',116),(117,'Open House','Attendee','Spring code_orange open house','2019-03-28',117),(118,'Intern','Active','Working first semester at code orange.','2019-07-19',118),(119,'Open House','Attendee','Spring code_orange open house','2019-03-28',119),(120,'Open House','Attendee','Spring code_orange open house','2019-03-28',120),(121,'Open House','Attendee','Spring code_orange open house','2019-03-28',121),(122,'Open House','Attendee','Spring code_orange open house','2019-03-28',122),(123,'Open House','Attendee','Spring code_orange open house','2019-03-28',122),(124,'Intern','Active','Working first semester at code_orange.','2019-06-08',124),(125,'Open House','Attendee','Spring code_orange open house','2019-03-28',125),(126,'Open House','Attendee','Spring code_orange open house','2019-03-28',126),(127,'Open House','Attendee','Spring code_orange open house','2019-03-28',127),(128,'Open House','Attendee','Working first semester at code orange.','2019-07-19',128),(129,'Open House','Attendee','Spring code_orange open house','2019-03-28',129),(130,'Open House','Attendee','Spring code_orange open house','2019-03-28',130),(131,'Intern','Active','Working first semester at code_orange.','2019-07-19',131),(132,'Open House','Attendee','Spring code_orange open house','2019-03-28',132),(133,'Open House','Attendee','Spring code_orange open house','2019-03-28',133),(134,'Intern','Active','Working first semester at code_orange.','2019-06-08',134),(135,'Intern','Active','Working first semester at code_orange','2019-07-19',135),(136,'Open House','Attendee','Spring code_orange open house','2019-03-28',136),(137,'Open House','Attendee','Spring code_orange open house','2019-03-28',137),(138,'Former Intern','Quit','Stopped showing up to lab','2019-02-12',138),(142,'Open House','atteneded','test','2019-05-01',142),(143,'Applicant','test','test','2019-05-01',142),(144,'Intern','test','test, duh','2019-05-02',144),(145,'undefined','undefined','undefined','0000-00-00',145),(146,'Intern','Active','Working first semester at code_orange.','2019-06-24',146),(147,'Intern','Active','Working first semester at code_orange.','2019-06-24',147),(148,'Intern','Active','Working first semester at code_orange.','2019-06-27',148),(149,'Intern','Active','Working first semester at code_orange','2019-07-01',151),(150,'Intern','Active','Working first semester at code_orange.','2019-07-12',153),(151,'Intern','Active','Working first semester at code_orange.','2019-07-19',155),(152,'Intern','Active','Working first semester at code_orange.','2019-07-12',156),(153,'Intern','Active','Working first semester at code_orange.','2019-07-12',157),(154,'Intern','Active','Working first semester at code_orange.','2019-07-12',158),(155,'Intern','Active','Working first semester at code_orange.','2019-07-19',159),(156,'Former Intern','Quit','N/A','2019-07-12',160),(157,'Intern','Active','Working first semester at code_orange.','2019-07-12',161),(158,'Intern','Active','Working first semester at code_orange.','2019-07-12',162),(159,'Intern','Active','Working first semester at code_orange.','2019-07-12',163),(160,'Intern','Active','Working first semester at code_orange.','2019-07-12',164),(161,'Intern','Active','Working first semester at code_orange.','2019-07-12',165),(162,'Intern','Active','Working first semester at code_orange.','2019-07-12',166),(163,'Intern','Active','Working first semester at code_orange.','2019-07-12',167),(164,'Intern','Active','Working first semester at code_orange.','2019-07-12',168),(165,'Intern','Active','Working first semester at code_orange.','2019-07-12',169),(166,'Intern','Active','Working first semester at code_orange.','2019-07-12',170),(167,'Intern','Active','Working first semester at code_orange.','2019-07-16',171),(168,'Intern','Active','Working first semester at code_orange.','2019-07-12',172),(169,'Intern','Active','Working first semester at code_orange.','2019-07-12',173),(170,'Intern','Active','Working first semester at code_orange.','2019-07-19',174),(171,'Intern','Active','Working first semester at code_orange.','2019-07-12',175),(172,'Product Owner','Active','Directs the lab','2019-07-19',176),(173,'Open House','Attendee','Spring code_orange open house','2019-03-28',145),(174,'Intern','Active','Working first semester at code_orange','2019-06-24',145),(175,'Open House','Attendee','Spring code_orange open house','2019-03-28',145),(176,'Open House','Attendee','Spring code_orange open house','2019-03-28',145),(177,'Open House','Attendee','Spring code_orange open house','2019-03-28',147);
/*!40000 ALTER TABLE `Role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `TeamMembers`
--

DROP TABLE IF EXISTS `TeamMembers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `TeamMembers` (
  `TeamID` int(11) NOT NULL,
  `MemberID` int(11) NOT NULL,
  UNIQUE KEY `TeamID` (`TeamID`,`MemberID`),
  KEY `MemberID` (`MemberID`),
  CONSTRAINT `TeamMembers_ibfk_1` FOREIGN KEY (`TeamID`) REFERENCES `Teams` (`TeamID`),
  CONSTRAINT `TeamMembers_ibfk_2` FOREIGN KEY (`MemberID`) REFERENCES `Members` (`MemberID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `TeamMembers`
--

LOCK TABLES `TeamMembers` WRITE;
/*!40000 ALTER TABLE `TeamMembers` DISABLE KEYS */;
INSERT INTO `TeamMembers` VALUES (1,1),(18,1),(1,2),(17,2),(1,3),(16,3),(30,3),(1,4),(1,5),(15,5),(24,5),(2,6),(19,6),(2,7),(19,7),(2,8),(9,8),(2,9),(2,10),(18,10),(3,11),(10,11),(3,12),(10,12),(3,13),(12,13),(3,14),(16,14),(3,15),(3,16),(4,17),(13,17),(4,18),(12,18),(4,19),(4,20),(11,20),(4,21),(11,21),(5,22),(8,22),(5,23),(8,23),(5,24),(13,24),(23,24),(5,25),(5,26),(20,26),(6,27),(17,27),(6,28),(9,28),(6,29),(9,29),(6,30),(6,31),(20,31),(6,32),(7,33),(7,34),(14,34),(7,35),(14,35),(22,35),(7,36),(15,36),(7,37),(8,38),(26,38),(8,39),(27,39),(8,40),(28,40),(8,41),(9,42),(9,43),(9,44),(9,45),(10,46),(29,46),(10,47),(24,47),(10,48),(10,49),(11,50),(11,51),(11,52),(29,52),(11,53),(12,54),(12,55),(26,55),(12,56),(12,57),(30,57),(13,58),(25,58),(13,59),(28,59),(13,60),(27,60),(13,61),(14,62),(22,62),(14,63),(22,63),(14,64),(14,65),(21,65),(15,66),(28,66),(15,67),(24,67),(15,68),(30,68),(15,69),(21,69),(16,70),(30,70),(16,71),(16,72),(26,72),(16,73),(30,73),(17,74),(17,75),(23,75),(17,76),(27,76),(17,77),(25,77),(18,78),(29,78),(18,79),(18,80),(21,80),(19,81),(19,82),(19,83),(26,83),(19,84),(30,84),(20,85),(20,86),(20,87),(20,88),(18,89),(29,91),(23,107),(23,118),(27,124),(30,128),(23,131),(29,134),(25,135),(21,146),(21,147),(21,148),(21,151),(28,153),(27,155),(28,156),(24,157),(27,158),(25,159),(27,161),(24,162),(22,163),(25,164),(24,165),(28,166),(28,167),(26,168),(26,169),(25,170),(25,171),(23,172),(29,173),(26,174),(22,175);
/*!40000 ALTER TABLE `TeamMembers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `TeamProjects`
--

DROP TABLE IF EXISTS `TeamProjects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `TeamProjects` (
  `TeamID` int(11) NOT NULL,
  `ProjectID` int(11) NOT NULL,
  UNIQUE KEY `TeamID` (`TeamID`,`ProjectID`),
  KEY `ProjectID` (`ProjectID`),
  CONSTRAINT `TeamProjects_ibfk_1` FOREIGN KEY (`TeamID`) REFERENCES `Teams` (`TeamID`),
  CONSTRAINT `TeamProjects_ibfk_2` FOREIGN KEY (`ProjectID`) REFERENCES `Projects` (`ProjectID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `TeamProjects`
--

LOCK TABLES `TeamProjects` WRITE;
/*!40000 ALTER TABLE `TeamProjects` DISABLE KEYS */;
INSERT INTO `TeamProjects` VALUES (1,1),(2,2),(3,3),(10,3),(4,4),(11,4),(5,5),(6,6),(7,7),(14,7),(8,8),(9,9),(4,11),(11,11),(12,12),(13,13),(15,15),(16,16),(17,17),(18,18),(19,19),(20,20),(22,31),(23,32),(24,33),(25,34),(26,35),(30,37),(21,39),(29,40),(28,41),(27,42);
/*!40000 ALTER TABLE `TeamProjects` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Teams`
--

DROP TABLE IF EXISTS `Teams`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Teams` (
  `TeamID` int(11) NOT NULL,
  `TeamName` varchar(20) DEFAULT NULL,
  `TeamNumber` int(11) DEFAULT NULL,
  `Semester` varchar(4) DEFAULT NULL,
  `PhotoPath` varchar(100) DEFAULT NULL,
  `LabID` int(11) DEFAULT NULL,
  PRIMARY KEY (`TeamID`),
  KEY `LabID` (`LabID`),
  CONSTRAINT `Teams_ibfk_1` FOREIGN KEY (`LabID`) REFERENCES `Labs` (`LabID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Teams`
--

LOCK TABLES `Teams` WRITE;
/*!40000 ALTER TABLE `Teams` DISABLE KEYS */;
INSERT INTO `Teams` VALUES (1,'Scurvy',1,'FA18','Scurvy.jpg',1),(2,'Team X',2,'FA18','X.jpg',1),(3,'Triton',3,'FA18','Triton_FA18.jpg',1),(4,'aVendors',4,'FA18','aVendors_FA18.jpg',1),(5,'Wi-fiVe',5,'FA18','Wi-fiVe.jpg',1),(6,'Et Confusa Novum',6,'FA18','EtConfusaNovum.jpg',1),(7,'Team 777',7,'FA18','777_FA18.jpg',1),(8,'Atlas',1,'SP19','Atlas.jpg',1),(9,'Dragon Riders',2,'SP19','Dragon_Riders.jpg',1),(10,'Triton',3,'SP19','Triton_SP19.jpg',1),(11,'aVendors',4,'SP19','aVendors_SP19.jpg',1),(12,'Team Covrt',5,'SP19','Covrt.jpg',1),(13,'Team 6',6,'SP19','Six.jpg',1),(14,'Team 777',7,'SP19','777_SP19.jpg',1),(15,'Xbox_360',8,'SP19','Xbox_360.jpg',1),(16,'Team Pulse',9,'SP19','Pulse.jpg',1),(17,'Don Juan',10,'SP19','Don_Juan.jpg',1),(18,'Epic Gamerz',11,'SP19','EpicGamerz.jpg',1),(19,'12Bricks',12,'SP19','12_Bricks.jpg',1),(20,'Team AR Matey',13,'SP19','ARMatey.jpg',1),(21,'Scrumptious',7,'SU19','Team7_SU19.jpg',1),(22,'Access Denied',1,'SU19','Team1_SU19.jpg',1),(23,'Runtime_Error',2,'SU19','Team2_SU19.jpg',1),(24,'Trident',3,'SU19','Team3_SU19.jpg',1),(25,'Bot_interpreters',4,'SU19','Team4_SU19.jpg',1),(26,'Decible',5,'SU19','Team5_SU19.jpg',1),(27,'Appsolute',6,'SU19','Team6_SU19.jpg',1),(28,'Octopus',8,'SU19','Team8_SU19.jpg',1),(29,'Avendors',9,'SU19','Team9_SU19.jpg',1),(30,'Tuff',10,'SU19','Team10_SU19.jpg',1);
/*!40000 ALTER TABLE `Teams` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'ebdb'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-08-19 17:46:40
