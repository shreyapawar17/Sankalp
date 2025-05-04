-- MySQL dump 10.13  Distrib 8.0.40, for Win64 (x86_64)
--
-- Host: localhost    Database: disaster_management_db
-- ------------------------------------------------------
-- Server version	8.0.40

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `disasterresources`
--

DROP TABLE IF EXISTS `disasterresources`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `disasterresources` (
  `disaster_id` int NOT NULL,
  `resource_id` int NOT NULL,
  `quantity_needed` int NOT NULL,
  `quantity_allocated` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`disaster_id`,`resource_id`),
  KEY `resource_id` (`resource_id`),
  CONSTRAINT `disasterresources_ibfk_1` FOREIGN KEY (`disaster_id`) REFERENCES `disasters` (`disaster_id`),
  CONSTRAINT `disasterresources_ibfk_2` FOREIGN KEY (`resource_id`) REFERENCES `resources` (`resource_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `disasterresources`
--

LOCK TABLES `disasterresources` WRITE;
/*!40000 ALTER TABLE `disasterresources` DISABLE KEYS */;
INSERT INTO `disasterresources` VALUES (1,10,20,20),(2,9,4,0),(3,2,30,30),(4,1,30,0),(6,14,100,100),(8,1,1,0),(9,1,40,40);
/*!40000 ALTER TABLE `disasterresources` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `disasters`
--

DROP TABLE IF EXISTS `disasters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `disasters` (
  `disaster_id` int NOT NULL AUTO_INCREMENT,
  `disaster_name` varchar(255) NOT NULL,
  `disaster_type` varchar(100) NOT NULL,
  `location` varchar(255) NOT NULL,
  `latitude` decimal(10,6) DEFAULT NULL,
  `longitude` decimal(10,6) DEFAULT NULL,
  `start_date` datetime DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`disaster_id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `disasters`
--

LOCK TABLES `disasters` WRITE;
/*!40000 ALTER TABLE `disasters` DISABLE KEYS */;
INSERT INTO `disasters` VALUES (1,'Heavy Rainfall and Flooding in Chennai','Flood','Adyar River Basin, Chennai, Chennai district, Tamil Nadu',13.082700,80.270700,'2025-04-25 08:00:00','Severe flooding due to unprecedented rainfall affecting low-lying areas.','2025-04-28 14:08:45','2025-04-28 14:08:45'),(2,'Cyclone Vayu - Coastal Impact','Cyclone','Veraval coast, Junagadh, Junagadh district, Gujarat',20.916700,70.366700,'2025-04-27 14:30:00','A category 2 cyclone making landfall, expected to bring high winds and heavy rainfall.','2025-04-28 14:08:45','2025-04-28 14:08:45'),(3,'Moderate Earthquake in Himachal Pradesh','Earthquake','Joginder Nagar, Mandi, Mandi district, Himachal Pradesh',31.893800,76.762500,'2025-04-28 02:15:00','An earthquake of magnitude 5.2 felt across the region, initial reports of minor damage.','2025-04-28 14:08:45','2025-04-28 14:08:45'),(4,'Landslide disrupts highway in Uttarakhand','Landslide','Near Joshimath, Chamoli, Chamoli district, Uttarakhand',30.567700,79.564300,'2025-04-27 20:00:00','A significant landslide blocked a major highway, disrupting transportation.','2025-04-28 14:08:45','2025-04-28 14:08:45'),(5,'Severe Heatwave in Rajasthan','Heatwave','Phalodi, Jodhpur, Jodhpur district, Rajasthan',26.466700,72.366700,'2025-04-26 10:00:00','Prolonged period of extreme heat, with temperatures exceeding 45 degrees Celsius.','2025-04-28 14:08:45','2025-04-28 14:08:45'),(6,'Flash Floods in Assam','Flood','Goalpara town, Goalpara, Goalpara district, Assam',26.166700,90.616700,'2025-04-28 06:45:00','Sudden and intense rainfall causing flash floods in urban and rural areas.','2025-04-28 14:08:45','2025-04-28 14:08:45'),(7,'Industrial Accident in Gujarat','Industrial Accident','Dahej, Bharuch, Bharuch district, Gujarat',21.700000,72.970000,'2025-04-29 11:00:00','A major chemical leak reported in an industrial area, requiring immediate response.','2025-04-28 14:08:45','2025-04-28 14:08:45'),(8,'Forest Fire in Odisha','Wildfire','Near Baliguda, Kandhamal, Kandhamal district, Odisha',20.166700,84.200000,'2025-04-28 14:00:00','A large forest fire spreading rapidly, posing a threat to nearby villages.','2025-04-28 14:08:45','2025-04-28 14:08:45'),(9,'Pest Attack in Punjab','Biological','Abohar town, Fazilka, Fazilka district, Punjab',30.147800,74.308900,'2025-04-29 09:30:00','A severe locust swarm damaging crops and impacting agricultural livelihoods.','2025-04-28 14:08:45','2025-04-28 14:08:45'),(10,'Urban Fire in Delhi','Man-Made','Chandni Chowk, Central Delhi, Central Delhi district, Delhi',28.650000,77.230000,'2025-04-28 18:00:00','A major fire incident in a densely populated market area, causing significant damage.','2025-04-28 14:08:45','2025-04-28 14:08:45'),(11,'Cyclone Tauktae','Cyclone','Diu Gujarat',23.210411,72.653507,'2025-02-04 23:44:00','Cyclone Tauktae, a very severe cyclonic storm','2025-04-28 18:14:47','2025-04-28 18:14:47');
/*!40000 ALTER TABLE `disasters` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `disastershelters`
--

DROP TABLE IF EXISTS `disastershelters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `disastershelters` (
  `disaster_id` int NOT NULL,
  `shelter_id` int NOT NULL,
  PRIMARY KEY (`disaster_id`,`shelter_id`),
  KEY `shelter_id` (`shelter_id`),
  CONSTRAINT `disastershelters_ibfk_1` FOREIGN KEY (`disaster_id`) REFERENCES `disasters` (`disaster_id`),
  CONSTRAINT `disastershelters_ibfk_2` FOREIGN KEY (`shelter_id`) REFERENCES `shelters` (`shelter_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `disastershelters`
--

LOCK TABLES `disastershelters` WRITE;
/*!40000 ALTER TABLE `disastershelters` DISABLE KEYS */;
INSERT INTO `disastershelters` VALUES (2,2),(4,4),(6,6),(6,11);
/*!40000 ALTER TABLE `disastershelters` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `disasterupdates`
--

DROP TABLE IF EXISTS `disasterupdates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `disasterupdates` (
  `update_id` int NOT NULL AUTO_INCREMENT,
  `disaster_id` int DEFAULT NULL,
  `update_timestamp` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `total_affected` int unsigned DEFAULT '0',
  `dead` int unsigned DEFAULT '0',
  `injured` int unsigned DEFAULT '0',
  `homeless` int unsigned DEFAULT '0',
  `livelihood_lost` int unsigned DEFAULT '0',
  PRIMARY KEY (`update_id`),
  KEY `disaster_id` (`disaster_id`),
  CONSTRAINT `disasterupdates_ibfk_1` FOREIGN KEY (`disaster_id`) REFERENCES `disasters` (`disaster_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `disasterupdates`
--

LOCK TABLES `disasterupdates` WRITE;
/*!40000 ALTER TABLE `disasterupdates` DISABLE KEYS */;
INSERT INTO `disasterupdates` VALUES (1,1,'2025-04-28 07:40:01',8,5,2,1,1),(2,1,'2025-04-28 07:40:52',9,5,2,1,1),(3,6,'2025-05-04 08:19:50',80,5,10,25,40);
/*!40000 ALTER TABLE `disasterupdates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `disastervolunteers`
--

DROP TABLE IF EXISTS `disastervolunteers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `disastervolunteers` (
  `disaster_id` int NOT NULL,
  `volunteer_id` int NOT NULL,
  `type` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`disaster_id`,`volunteer_id`),
  KEY `volunteer_id` (`volunteer_id`),
  CONSTRAINT `disastervolunteers_ibfk_1` FOREIGN KEY (`disaster_id`) REFERENCES `disasters` (`disaster_id`),
  CONSTRAINT `disastervolunteers_ibfk_2` FOREIGN KEY (`volunteer_id`) REFERENCES `volunteers` (`volunteer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `disastervolunteers`
--

LOCK TABLES `disastervolunteers` WRITE;
/*!40000 ALTER TABLE `disastervolunteers` DISABLE KEYS */;
INSERT INTO `disastervolunteers` VALUES (4,21,NULL),(5,23,NULL),(5,25,NULL),(6,26,NULL),(6,47,NULL);
/*!40000 ALTER TABLE `disastervolunteers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `employees`
--

DROP TABLE IF EXISTS `employees`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employees` (
  `employee_id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `role` varchar(50) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`employee_id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employees`
--

LOCK TABLES `employees` WRITE;
/*!40000 ALTER TABLE `employees` DISABLE KEYS */;
INSERT INTO `employees` VALUES (1,'amit.sharma','$2b$12$fjNBu48oNFLBkEh.IrJGyeBlGUoY4WyS/8NXe2b3CE5BxHilIMPR2','Amit Sharma','Team Leader - Rescue Operations','2025-04-28 14:12:54','2025-04-28 14:12:54'),(2,'priya.verma','$2b$12$x5eJU5Gvo87wFn3QKckOTeVTZ0.UioXSec8KtokXTn7lodjCELOR2','Priya Verma','Team Leader - Medical Response','2025-04-28 14:12:54','2025-04-28 14:12:54'),(3,'rajesh.pillai','$2b$12$kXE6ucHJzA0a4UJ7p1r.cefQxavik8uAL0oKX3yKzCuJtfhQqBAAq','Rajesh Pillai','Operations Coordinator','2025-04-28 14:12:54','2025-04-28 14:12:54'),(4,'sneha.patel','$2b$12$h55lqnZRXVUs68Nx/jo.Y.PZ9moUcDHGlaWGVq3xcZiXEIP.l81Le','Sneha Patel','Logistics Coordinator','2025-04-28 14:12:54','2025-04-28 14:12:54'),(5,'vikram.singh','$2b$12$vDIF3QmaVaeF30GzkeQ6zu2vPnsShmVlj6nto5Gs4fjgK2rzRi.mW','Vikram Singh','Field Officer - North Zone','2025-04-28 14:12:54','2025-04-28 14:12:54'),(6,'ananya.rao','$2b$12$RdTaN0sL01r.LkgjC/U7xOxnMk/ISe9OEbV/SrfN/2ujh0vWXzD3i','Ananya Rao','Field Officer - South Zone','2025-04-28 14:12:54','2025-04-28 14:12:54'),(7,'manish.gupta','$2b$12$6Rbsp8PjdwZgvPKcty0rkuOpBFiQ9SUlK2nkXwIZiQsSBKiCiRojq','Manish Gupta','Field Officer - East Zone','2025-04-28 14:12:54','2025-04-28 14:12:54'),(8,'deepika.joshi','$2b$12$XpajBX7uk3h4M.RSB0.Z6e.Q/7PpXtNEHd0bYAZUSBXXEt4Mo5NRK','Deepika Joshi','Field Officer - West Zone','2025-04-28 14:12:54','2025-04-28 14:12:54'),(9,'suresh.kumar','$2b$12$1cUD.3NOhcvxW1lWj2a0QOVT7H2N90QzMAGm1hXUCxUOZOU91vxPe','Suresh Kumar','Resource Manager','2025-04-28 14:12:54','2025-04-28 14:12:54'),(10,'ashima.sen','$2b$12$tEjEXwhheOzcj8J3C0lpIOGJReJrVHndkXPHQqbsPhYdj41sVx1Nm','Ashima Sen','Inventory Specialist','2025-04-28 14:12:54','2025-04-28 14:12:54'),(11,'karan.mehta','$2b$12$7ncuiAWX4t/ZGiLb4n1fi.ERVTxS36gwKgT2teFBGkEkFOwPmZAGy','Karan Mehta','Volunteer Coordinator','2025-04-28 14:12:54','2025-04-28 14:12:54'),(12,'nisha.yadav','$2b$12$EaFi.mcWomONMxrRoJnzsevNQ9xS1Z6DyZmNrJLLgjcW.4q4FoBfm','Nisha Yadav','Volunteer Recruitment Officer','2025-04-28 14:12:54','2025-04-28 14:12:54'),(13,'govind.murthy','$2b$12$iH14t0x.WmFYpfj3/vg1J.QxiV6hi2m/bhiqWny.JyWEJ2PUSMMXK','Govind Murthy','Senior Administrator','2025-04-28 14:12:54','2025-04-28 14:12:54'),(14,'shalini.mishra','$2b$12$.Jhe3ju6KZi1pJIVkOE9F.BX4S8LfuZxGEFZmAANfRZA5moMMB5HS','Shalini Mishra','Director - Operations','2025-04-28 14:12:54','2025-04-28 14:12:54'),(15,'neerja.sen','$2b$12$3Ab7verUoOSBnMyZD8ihbuGKuecEo/W5d1T1D01kzeGkzrSmEkF.q','Neerja Name','Director - Operations','2025-05-04 08:04:34','2025-05-04 08:04:34');
/*!40000 ALTER TABLE `employees` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `resources`
--

DROP TABLE IF EXISTS `resources`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `resources` (
  `resource_id` int NOT NULL AUTO_INCREMENT,
  `resource_name` varchar(100) NOT NULL,
  `resource_type` varchar(50) NOT NULL,
  `quantity` int NOT NULL,
  `unit` varchar(50) DEFAULT NULL,
  `location` varchar(255) DEFAULT NULL,
  `latitude` decimal(10,6) DEFAULT NULL,
  `longitude` decimal(10,6) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`resource_id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `resources`
--

LOCK TABLES `resources` WRITE;
/*!40000 ALTER TABLE `resources` DISABLE KEYS */;
INSERT INTO `resources` VALUES (1,'Rice','Food',460,'kg',NULL,NULL,NULL,'2025-04-28 14:09:51','2025-04-28 17:51:09'),(2,'Lentils','Food',270,'kg',NULL,NULL,NULL,'2025-04-28 14:09:51','2025-05-03 21:11:00'),(3,'Bottled Water','Food',1000,'liters',NULL,NULL,NULL,'2025-04-28 14:09:51','2025-04-28 14:09:51'),(4,'Paracetamol','Medicine',2000,'tablets',NULL,NULL,NULL,'2025-04-28 14:09:51','2025-04-28 14:09:51'),(5,'Antiseptic Cream','Medicine',500,'tubes',NULL,NULL,NULL,'2025-04-28 14:09:51','2025-04-28 14:09:51'),(6,'Hand Sanitizer','Sanitation Kit',800,'bottles',NULL,NULL,NULL,'2025-04-28 14:09:51','2025-04-28 14:09:51'),(7,'Soap','Sanitation Kit',1200,'bars',NULL,NULL,NULL,'2025-04-28 14:09:51','2025-04-28 14:09:51'),(8,'Toothbrushes','Sanitation Kit',1500,'pieces',NULL,NULL,NULL,'2025-04-28 14:09:51','2025-04-28 14:09:51'),(9,'Blankets (Single)','Blankets',600,'pieces',NULL,NULL,NULL,'2025-04-28 14:09:51','2025-04-28 14:09:51'),(10,'Blankets (Double)','Blankets',280,'pieces',NULL,NULL,NULL,'2025-04-28 14:09:51','2025-05-03 19:43:02'),(11,'T-shirts (Adult)','Clothes',1000,'pieces',NULL,NULL,NULL,'2025-04-28 14:09:51','2025-04-28 14:09:51'),(12,'Pants (Adult)','Clothes',800,'pieces',NULL,NULL,NULL,'2025-04-28 14:09:51','2025-04-28 14:09:51'),(13,'Sarees','Clothes',500,'pieces',NULL,NULL,NULL,'2025-04-28 14:09:51','2025-04-28 14:09:51'),(14,'ORS Packets','Medicine',1400,'packets',NULL,NULL,NULL,'2025-04-28 14:09:51','2025-05-04 08:47:50');
/*!40000 ALTER TABLE `resources` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `shelters`
--

DROP TABLE IF EXISTS `shelters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shelters` (
  `shelter_id` int NOT NULL AUTO_INCREMENT,
  `shelter_name` varchar(255) NOT NULL,
  `location` varchar(255) NOT NULL,
  `latitude` decimal(10,6) DEFAULT NULL,
  `longitude` decimal(10,6) DEFAULT NULL,
  `capacity` int DEFAULT NULL,
  `available_capacity` int DEFAULT NULL,
  `contact_person` varchar(100) DEFAULT NULL,
  `contact_number` varchar(20) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`shelter_id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shelters`
--

LOCK TABLES `shelters` WRITE;
/*!40000 ALTER TABLE `shelters` DISABLE KEYS */;
INSERT INTO `shelters` VALUES (1,'St. Thomas High School','Adyar River Basin, Chennai, Tamil Nadu',13.083000,80.270500,300,270,'Anita Krishnan','9876543210','2025-04-28 17:02:07','2025-04-28 17:02:07'),(2,'Veraval Municipal Community Hall','Veraval coast, Junagadh, Gujarat',20.915000,70.370000,200,170,'Rahul Desai','9123456789','2025-04-28 17:02:07','2025-04-28 17:02:07'),(3,'Joginder Nagar Civil Hospital','Joginder Nagar, Mandi, Himachal Pradesh',31.894000,76.762000,100,85,'Preeti Sharma','9988776655','2025-04-28 17:02:07','2025-04-28 17:02:07'),(4,'Joshimath Town Primary School','Near Joshimath, Chamoli, Uttarakhand',30.568000,79.565000,120,100,'Arun Rawat','9871234560','2025-04-28 17:02:07','2025-04-28 17:02:07'),(5,'Phalodi District Hospital Shelter','Phalodi, Jodhpur, Rajasthan',26.467000,72.366000,150,140,'Meera Rathore','9765432109','2025-04-28 17:02:07','2025-04-28 17:02:07'),(6,'Goalpara Public School','Goalpara town, Goalpara, Assam',26.167000,90.617000,180,160,'Debashish Das','7896541230','2025-04-28 17:02:07','2025-04-28 17:02:07'),(7,'Dahej Community Health Center','Dahej, Bharuch, Gujarat',21.700500,72.970500,100,90,'Nilesh Patel','8796543210','2025-04-28 17:02:07','2025-04-28 17:02:07'),(8,'Baliguda Block High School','Near Baliguda, Kandhamal, Odisha',20.167000,84.200500,150,130,'Sasmita Rout','7891234567','2025-04-28 17:02:07','2025-04-28 17:02:07'),(9,'Abohar Community Hall','Abohar town, Fazilka, Punjab',30.148000,74.309000,120,100,'Harpreet Singh','7654321890','2025-04-28 17:02:07','2025-04-28 17:02:07'),(10,'Hindu College Auditorium Shelter','Chandni Chowk, Central Delhi, Delhi',28.650500,77.230500,250,220,'Sunita Verma','8123456789','2025-04-28 17:02:07','2025-04-28 17:02:07'),(11,'Krishnai Community Hall','Krishnai, Goalpara, Assam',26.032077,90.667999,150,NULL,'7896501177','','2025-05-04 08:43:58','2025-05-04 08:43:58');
/*!40000 ALTER TABLE `shelters` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `volunteers`
--

DROP TABLE IF EXISTS `volunteers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `volunteers` (
  `volunteer_id` int NOT NULL AUTO_INCREMENT,
  `first_name` varchar(100) NOT NULL,
  `last_name` varchar(100) NOT NULL,
  `contact_number` varchar(20) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `volunteer_type` varchar(50) NOT NULL,
  `is_active` tinyint(1) DEFAULT NULL,
  `current_location` varchar(255) DEFAULT NULL,
  `latitude` decimal(10,6) DEFAULT NULL,
  `longitude` decimal(10,6) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `secondary_contact_number` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`volunteer_id`)
) ENGINE=InnoDB AUTO_INCREMENT=52 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `volunteers`
--

LOCK TABLES `volunteers` WRITE;
/*!40000 ALTER TABLE `volunteers` DISABLE KEYS */;
INSERT INTO `volunteers` VALUES (1,'Ravi','Kumar','9840111111','ravi.k@example.com','rescue',1,'Adyar, Chennai',13.070000,80.260000,'2025-04-28 14:11:55','2025-05-01 15:22:18','9876543210'),(2,'Sangeetha','Devi','9840222222','sangeetha.d@example.com','medical',1,'T. Nagar, Chennai',13.040000,80.240000,'2025-04-28 14:11:55','2025-05-01 15:23:00','1122334455'),(3,'Arun','Raj','9840333333','arun.r@example.com','logistics',1,'Velachery, Chennai',12.980000,80.200000,'2025-04-28 14:11:55','2025-05-01 15:23:00','6677889900'),(4,'Priya','Menon','9840444444','priya.m@example.com','medical',1,'Anna Nagar, Chennai',13.080000,80.220000,'2025-04-28 14:11:55','2025-05-01 15:32:26','9477294407'),(5,'Vikram','Singh','9840555555','vikram.s@example.com','logistics',1,'Saidapet, Chennai',13.020000,80.210000,'2025-04-28 14:11:55','2025-05-01 15:22:18','9876543210'),(6,'Deepika','Verma','9840666666','deepika.v@example.com','medical',1,'Nungambakkam, Chennai',13.060000,80.250000,'2025-04-28 14:11:55','2025-05-01 15:32:26','9928006022'),(7,'Suresh','Babu','9840777777','suresh.b@example.com','logistics',1,'Mylapore, Chennai',13.030000,80.270000,'2025-04-28 14:11:55','2025-05-01 15:32:26','9208146919'),(8,'Anita','Reddy','9840888888','anita.r@example.com','medical',1,'Guindy, Chennai',13.000000,80.220000,'2025-04-28 14:11:55','2025-05-01 15:32:26','9256716562'),(9,'Karthik','Rao','9840999999','karthik.r@example.com','logistics',1,'Chromepet, Chennai',12.950000,80.150000,'2025-04-28 14:11:55','2025-05-01 15:32:26','9659142085'),(10,'Lakshmi','Nair','9003111111','lakshmi.n@example.com','medical',1,'Tambaram, Chennai',12.920000,80.130000,'2025-04-28 14:11:55','2025-05-01 15:22:18','9876543210'),(11,'Jayesh','Patel','9998111111','jayesh.p@example.com','logistics',1,'Veraval',20.920000,70.370000,'2025-04-28 14:11:55','2025-05-01 15:32:26','9525560767'),(12,'Pooja','Shah','9998222222','pooja.s@example.com','medical',1,'Somnath',20.880000,70.400000,'2025-04-28 14:11:55','2025-05-01 15:32:26','9650377615'),(13,'Rajesh','Joshi','9998333333','rajesh.j@example.com','logistics',1,'Malia Hatina',21.000000,70.450000,'2025-04-28 14:11:55','2025-05-01 15:32:26','9675205802'),(14,'Seema','Gandhi','9998444444','seema.g@example.com','medical',1,'Chorvad',20.850000,70.300000,'2025-04-28 14:11:55','2025-05-01 15:32:26','9424896196'),(15,'Amit','Bhatt','9998555555','amit.b@example.com','logistics',1,'Una',20.800000,70.350000,'2025-04-28 14:11:55','2025-05-01 15:22:18','8765432109'),(16,'Vikram','Thakur','8894111111','vikram.t@example.com','rescue',1,'Joginder Nagar',31.890000,76.760000,'2025-04-28 14:11:55','2025-05-01 15:32:26','9098863608'),(17,'Shalini','Sharma','8894222222','shalini.s@example.com','medical',1,'Mandi',31.720000,76.920000,'2025-04-28 14:11:55','2025-05-01 15:32:26','9219629481'),(18,'Rajeev','Kumar','8894333333','rajeev.k@example.com','logistics',1,'Sundar Nagar',31.530000,76.740000,'2025-04-28 14:11:55','2025-05-01 15:32:26','9801556614'),(19,'Pooja','Rani','8894444444','pooja.r@example.com','medical',1,'Palampur',32.110000,76.530000,'2025-04-28 14:11:55','2025-05-01 15:32:26','9348894656'),(20,'Sunil','Rawat','9756111111','sunil.r@example.com','logistics',1,'Joshimath',30.570000,79.570000,'2025-04-28 14:11:55','2025-05-01 15:22:18','8765432109'),(21,'Geeta','Negi','9756222222','geeta.n@example.com','medical',1,'Chamoli',30.400000,79.560000,'2025-04-28 14:11:55','2025-05-01 15:32:26','9339803468'),(22,'Ankit','Singh','9756333333','ankit.s@example.com','logistics',1,'Pipalkoti',30.450000,79.400000,'2025-04-28 14:11:55','2025-05-01 15:32:26','9652333406'),(23,'Rajesh','Meena','8003111111','rajesh.m@example.com','logistics',1,'Phalodi',26.470000,72.370000,'2025-04-28 14:11:55','2025-05-01 15:32:26','9242256656'),(24,'Kavita','Verma','8003222222','kavita.v@example.com','medical',1,'Jodhpur',26.230000,73.020000,'2025-04-28 14:11:55','2025-05-01 15:32:26','9254283094'),(25,'Suresh','Choudhary','8003333333','suresh.c@example.com','logistics',1,'Osian',26.500000,72.210000,'2025-04-28 14:11:55','2025-05-01 15:22:20','8765432109'),(26,'Babul','Ali','9577111111','babul.a@example.com','logistics',1,'Goalpara',26.170000,90.620000,'2025-04-28 14:11:55','2025-05-01 15:32:26','9544645531'),(27,'Deepa','Das','9577222222','deepa.d@example.com','medical',1,'Bongaigaon',26.480000,90.560000,'2025-04-28 14:11:55','2025-05-01 15:32:26','9960378406'),(28,'Raju','Sarkar','9577333333','raju.s@example.com','logistics',1,'Dhubri',26.020000,90.000000,'2025-04-28 14:11:55','2025-05-01 15:32:26','9167955468'),(29,'Sunil','Gupta','9825111111','sunil.g@example.com','logistics',1,'Dahej',21.710000,72.980000,'2025-04-28 14:11:55','2025-05-01 15:32:26','9958642153'),(30,'Shalini','Patel','9825222222','shalini.p@example.com','medical',1,'Bharuch',21.700000,72.970000,'2025-04-28 14:11:55','2025-05-01 15:32:26','9289344394'),(31,'Vikash','Yadav','9825333333','vikash.y@example.com','logistics',1,'Ankleshwar',21.630000,73.020000,'2025-04-28 14:11:55','2025-05-01 15:32:26','9570795543'),(32,'Suresh','Majhi','9437111111','suresh.m@example.com','rescue',1,'Baliguda',20.170000,84.210000,'2025-04-28 14:11:55','2025-05-01 15:32:26','9985944561'),(33,'Debu','Pradhan','9437333333','debu.p@example.com','logistics',1,'Phulbani',20.370000,84.140000,'2025-04-28 14:11:55','2025-05-01 15:32:26','9217336209'),(34,'Gurpreet','Singh','9872111111','gurpreet.s@example.com','logistics',1,'Abohar',30.150000,74.310000,'2025-04-28 14:11:55','2025-05-01 15:32:26','9128847394'),(35,'Harpreet','Kaur','9872222222','harpreet.k@example.com','logistics',1,'Fazilka',30.400000,74.300000,'2025-04-28 14:11:55','2025-05-01 15:32:26','9992228372'),(36,'Jaswinder','Brar','9872333333','jaswinder.b@example.com','logistics',1,'Malout',30.190000,74.480000,'2025-04-28 14:11:55','2025-05-01 15:32:26','9574599712'),(37,'Rajesh','Pillai','9003222222','rajesh.p@example.com','logistics',0,'Adyar, Chennai',13.075000,80.265000,'2025-04-28 14:11:55','2025-05-01 15:32:26','9896313475'),(38,'Divya','Krishnan','9003333333','divya.k@example.com','medical',0,'T. Nagar, Chennai',13.045000,80.245000,'2025-04-28 14:11:55','2025-05-01 15:32:26','9757768269'),(39,'Meera','Solanki','8866111111','meera.s@example.com','logistics',0,'Veraval',20.915000,70.365000,'2025-04-28 14:11:55','2025-05-01 15:32:26','9099900951'),(40,'Kunal','Rana','8866222222','kunal.r@example.com','medical',0,'Somnath',20.875000,70.405000,'2025-04-28 14:11:55','2025-05-01 15:32:26','9226199981'),(41,'Ajay','Sharma','7700111111','ajay.s@example.com','logistics',0,'Mandi',31.725000,76.925000,'2025-04-28 14:11:55','2025-05-01 15:32:28','9831297080'),(42,'Priya','Sharma','7890123456','priya.s@example.com','medical',1,'Near Adyar',13.050000,80.250000,'2025-05-01 15:34:09','2025-05-01 15:34:09','9876543210'),(43,'Karthik','Verma','6789012345','karthik.v@example.com','rescue',1,'Close to Veraval',20.950000,70.350000,'2025-05-01 15:34:09','2025-05-01 15:34:09','8765432109'),(44,'Anjali','Thakur','5678901234','anjali.t@example.com','logistics',1,'Joginder Nagar Area',31.900000,76.750000,'2025-05-01 15:34:09','2025-05-01 15:34:09','7654321098'),(45,'Rohan','Rawat','9012345678','rohan.r@example.com','rescue',1,'Around Joshimath',30.550000,79.550000,'2025-05-01 15:34:09','2025-05-01 15:34:09','6543210987'),(46,'Deepika','Singh','0123456789','deepika.s@example.com','medical',1,'Phalodi Region',26.450000,72.350000,'2025-05-01 15:34:09','2025-05-01 15:34:09','5432109876'),(47,'Biplab','Das','8901234567','biplab.d@example.com','logistics',1,'Goalpara Town Area',26.150000,90.600000,'2025-05-01 15:34:09','2025-05-01 15:34:09','4321098765'),(48,'Sneha','Patel','7654321098','sneha.p@example.com','medical',1,'Dahej Industrial Zone',21.750000,72.950000,'2025-05-01 15:34:09','2025-05-01 15:34:09','3210987654'),(49,'Aryan','Naik','6543210987','aryan.n@example.com','rescue',1,'Baliguda Vicinity',20.200000,84.250000,'2025-05-01 15:34:09','2025-05-01 15:34:09','2109876543'),(50,'Jasleen','Kaur','5432109876','jasleen.k@example.com','logistics',1,'Abohar City',30.150000,74.350000,'2025-05-01 15:34:09','2025-05-01 15:34:09','1098765432'),(51,'Vineet','Gupta','4321098765','vineet.g@example.com','medical',1,'Chandni Chowk Area',28.600000,77.250000,'2025-05-01 15:34:09','2025-05-01 15:34:09','9988776655');
/*!40000 ALTER TABLE `volunteers` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-05-04 15:44:56
