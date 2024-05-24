CREATE DATABASE  IF NOT EXISTS `unifun_test` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `unifun_test`;
-- MySQL dump 10.13  Distrib 8.0.36, for Win64 (x86_64)
--
-- Host: localhost    Database: unifun_test
-- ------------------------------------------------------
-- Server version	8.0.37

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `car_makes`
--

DROP TABLE IF EXISTS `car_makes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `car_makes` (
  `make_id` int NOT NULL AUTO_INCREMENT,
  `make` varchar(40) NOT NULL,
  PRIMARY KEY (`make_id`),
  UNIQUE KEY `make` (`make`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `car_makes`
--

LOCK TABLES `car_makes` WRITE;
/*!40000 ALTER TABLE `car_makes` DISABLE KEYS */;
INSERT INTO `car_makes` VALUES (0,'BMW'),(1,'Mercedes');
/*!40000 ALTER TABLE `car_makes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `car_models`
--

DROP TABLE IF EXISTS `car_models`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `car_models` (
  `model_id` int NOT NULL AUTO_INCREMENT,
  `model` varchar(40) NOT NULL,
  `make_id` int DEFAULT NULL,
  PRIMARY KEY (`model_id`),
  UNIQUE KEY `model` (`model`),
  KEY `make_id` (`make_id`),
  CONSTRAINT `car_models_ibfk_1` FOREIGN KEY (`make_id`) REFERENCES `car_makes` (`make_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `car_models`
--

LOCK TABLES `car_models` WRITE;
/*!40000 ALTER TABLE `car_models` DISABLE KEYS */;
INSERT INTO `car_models` VALUES (0,'M3',0),(10,'M5',0),(11,'M34',0),(12,'M340',0),(13,'M349',0),(14,'340',0),(15,'GLC',1),(16,'GLE',1);
/*!40000 ALTER TABLE `car_models` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cars`
--

DROP TABLE IF EXISTS `cars`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cars` (
  `car_id` int NOT NULL AUTO_INCREMENT,
  `car_plate` varchar(7) NOT NULL,
  `registration_year` year NOT NULL,
  `engine_capacity` varchar(4) NOT NULL,
  `model_id` int DEFAULT NULL,
  PRIMARY KEY (`car_id`),
  UNIQUE KEY `car_plate` (`car_plate`),
  KEY `model_id` (`model_id`),
  CONSTRAINT `cars_ibfk_1` FOREIGN KEY (`model_id`) REFERENCES `car_models` (`model_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cars`
--

LOCK TABLES `cars` WRITE;
/*!40000 ALTER TABLE `cars` DISABLE KEYS */;
INSERT INTO `cars` VALUES (1,'SSS 433',2020,'3.0',15),(2,'RER 434',2022,'5.0',0),(3,'FER 400',2000,'2.0',16);
/*!40000 ALTER TABLE `cars` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'unifun_test'
--
/*!50003 DROP PROCEDURE IF EXISTS `addCar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `addCar`(
	IN inserted_car_plate VARCHAR(7),
    IN inserted_registration_year VARCHAR(4),
    IN inserted_engine_capacity VARCHAR(4),
    IN inserted_make VARCHAR(40),
    IN inserted_model VARCHAR(40))
BEGIN
		DECLARE tmpVar_make_id INT;
        DECLARE tmpVar_model_id INT;
        
        -- insert new make
        SELECT make_id INTO tmpVar_make_id FROM car_makes WHERE make = inserted_make;
        IF tmpVar_make_id IS NULL
        THEN 
			INSERT INTO car_makes(make)
            VALUES(inserted_make);
            SET tmpVar_make_id = LAST_INSERT_ID();
        END IF;
        
        -- insert new model 
        SELECT model_id INTO tmpVar_model_id FROM car_models WHERE model = inserted_model;
		IF tmpVar_model_id IS NULL
		THEN 
			INSERT INTO car_models(model, make_id)
            VALUES(inserted_model, tmpVar_make_id);
            SET tmpVar_model_id = LAST_INSERT_ID();
			
		ELSEIF (SELECT make_id FROM car_models WHERE model_id = tmpVar_model_id) != tmpVar_make_id
		THEN
			SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'This model does not bloeng to this make';
		END IF;
        
		-- insert new car
        IF (SELECT COUNT(*) FROM cars WHERE car_plate = inserted_car_plate)=0
		THEN 
			INSERT INTO cars(car_plate, registration_year, engine_capacity, model_id)
            VALUES (inserted_car_plate, inserted_registration_year, inserted_engine_capacity, tmpVar_model_id);
		ELSE 
			SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Car with this plate number already exists';
		END IF;
    END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `deleteAllCars` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteAllCars`()
BEGIN
	DELETE FROM cars where car_id > 0;
    DELETE FROM car_makes WHERE make_id > 0;
    ALTER TABLE cars AUTO_INCREMENT = 1;
    ALTER TABLE car_makes AUTO_INCREMENT = 1;
    ALTER TABLE car_models AUTO_INCREMENT = 1;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `deleteCar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteCar`(
	IN carPlate VARCHAR(7))
BEGIN
	DELETE FROM cars WHERE car_plate = carPlate;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `getCars` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `getCars`()
BEGIN
	SELECT cars.car_plate, car_makes.make, car_models.model, cars.registration_year, cars.engine_capacity
	FROM cars
	LEFT JOIN car_models USING (model_id)
	LEFT JOIN car_makes USING (make_id);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `updateCar` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateCar`(
	IN inserted_car_plate VARCHAR(7),
    IN inserted_registration_year VARCHAR(4),
    IN inserted_engine_capacity VARCHAR(4),
    IN inserted_make VARCHAR(40),
    IN inserted_model VARCHAR(40),
	IN inserted_car_plate_new VARCHAR(7),
    IN inserted_registration_year_new VARCHAR(4),
    IN inserted_engine_capacity_new VARCHAR(4),
    IN inserted_make_new VARCHAR(40),
    IN inserted_model_new VARCHAR(40)
)
BEGIN
	DECLARE tmpVar_car_id INT;
    DECLARE tmpVar_model_id INT;
    DECLARE tmpVar_model_id_new INT;
	DECLARE tmpVar_make_id INT;
    DECLARE tmpVar_make_id_new INT;
    
    SELECT car_id INTO tmpVar_car_id FROM cars WHERE car_plate = inserted_car_plate;

	-- CHANGE CAR PLATE
    IF inserted_car_plate != inserted_car_plate_new
    THEN 
		UPDATE cars
        SET car_plate = inserted_car_plate_new
        WHERE car_id = tmpVar_car_id;
    END IF;
    -- CHANGE REGISTRATION YEAR
	IF inserted_registration_year != inserted_registration_year_new
    THEN 
		UPDATE cars
        SET registration_year = inserted_registration_year_new
        WHERE car_id = tmpVar_car_id;
    END IF;
    -- CHANGE ENGINE CAPACITY
    	IF inserted_engine_capacity != inserted_engine_capacity_new
    THEN 
		UPDATE cars
        SET engine_capacity = inserted_engine_capacity_new
        WHERE car_id = tmpVar_car_id;
    END IF;
    
        -- CHANGE MAKE
    SELECT make_id INTO tmpVar_make_id FROM car_makes WHERE make = inserted_make;
    IF inserted_make != inserted_make_new
    THEN
		SELECT make_id INTO tmpVar_make_id_new FROM car_makes WHERE make = inserted_make_new;
        IF tmpVar_make_id_new IS NULL
        THEN
			INSERT INTO car_makes(make)
            VALUES(inserted_make_new);
            SET tmpVar_make_id =  LAST_INSERT_ID();
            UPDATE car_models
            SET make_id = tmpVar_make_id
            WHERE model_id = tmpVar_model_id;
		ELSE
			UPDATE car_models
            SET make_id = tmpVar_make_id_new
            WHERE model_id = tmpVar_model_id;
        END IF;
	END IF;
    
    -- CHANGE MODEL
    SELECT model_id INTO tmpVar_model_id FROM car_models WHERE model = inserted_model;
    IF inserted_model != inserted_model_new
    THEN
		SELECT model_id INTO tmpVar_model_id_new FROM car_models WHERE model = inserted_model_new;
        IF tmpVar_model_id_new IS NULL
        THEN
			INSERT INTO car_models(model, make_id)
            VALUES(inserted_model_new, tmpVar_make_id);
            SET tmpVar_model_id = LAST_INSERT_ID();
            UPDATE cars
            SET model_id = tmpVar_model_id
            WHERE car_id = tmpVar_car_id;
		ELSE 
			IF (SELECT make_id FROM car_models WHERE model_id = tmpVar_model_id_new) = tmpVar_make_id
            THEN
			UPDATE cars
            SET model_id = tmpVar_model_id_new
            WHERE car_id = tmpVar_car_id;
            ELSE
				SIGNAL SQLSTATE '45000'
				SET MESSAGE_TEXT = 'This model does not bloeng to this make';
            END IF;
        END IF;
    END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-05-24 14:24:58
