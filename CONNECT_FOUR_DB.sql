-- MySQL dump 10.13  Distrib 8.0.22, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: CONNECT_FOUR_DB
-- ------------------------------------------------------
-- Server version	5.5.5-10.1.47-MariaDB-0+deb9u1

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
-- Table structure for table `board`
--

DROP TABLE IF EXISTS `board`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `board` (
  `x` tinyint(4) NOT NULL,
  `y` tinyint(4) NOT NULL,
  `color` enum('B','R') NOT NULL,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `board`
--

LOCK TABLES `board` WRITE;
/*!40000 ALTER TABLE `board` DISABLE KEYS */;
/*!40000 ALTER TABLE `board` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `game_status`
--

DROP TABLE IF EXISTS `game_status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `game_status` (
  `status` enum('not active','initialized','started','ended','aborded') NOT NULL DEFAULT 'not active',
  `p_turn` enum('R','B') DEFAULT NULL,
  `result` enum('B','R','D') DEFAULT NULL,
  `last_change` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `game_status`
--

LOCK TABLES `game_status` WRITE;
/*!40000 ALTER TABLE `game_status` DISABLE KEYS */;
/*!40000 ALTER TABLE `game_status` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER game_status_update BEFORE UPDATE
	ON game_status
	FOR EACH ROW BEGIN
	SET NEW.last_change = NOW();
	END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `players`
--

DROP TABLE IF EXISTS `players`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `players` (
  `username` varchar(20) DEFAULT NULL,
  `color` enum('B','R') NOT NULL,
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `token` varchar(32) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_color` (`color`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `players`
--

LOCK TABLES `players` WRITE;
/*!40000 ALTER TABLE `players` DISABLE KEYS */;
INSERT INTO `players` VALUES ('Leonarda','B',1,'ccf989dbd1c9e0588000056d9fded7bf');
/*!40000 ALTER TABLE `players` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'CONNECT_FOUR_DB'
--
/*!50003 DROP PROCEDURE IF EXISTS `check_winner` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `check_winner`()
check_winner:
	BEGIN
		DECLARE status, last_color TEXT;
        DECLARE last_x, last_y, marks TINYINT;
        
        SELECT status INTO status
        FROM game_status LIMIT 1;
        
        IF status != started THEN
        LEAVE check_winner;
        END IF;
        
        SELECT x,y,color INTO last_x,last_y,last_color
        FROM board 
        ORDER BY id DESC LIMIT 1;
        
        SELECT COUNT(id) INTO marks
		FROM board
		WHERE x = last_x
			AND MAX(y) - MIN(y) = 3
			AND color = last_color
		GROUP BY x;
        
        IF marks != 4 THEN 
			SELECT COUNT(id) INTO marks
			FROM board
			WHERE y = last_y
				AND MAX(x) - MIN(x) = 3
				AND color = last_color
			GROUP BY y;
		END IF;

		IF marks != 4 THEN 
			SELECT COUNT(id) INTO marks
			FROM board
			WHERE color = last_color
				AND MAX(x) - MIN(x) = 3
				AND MAX(y) - MIN(y) = 3
			GROUP BY (x - y);
		END IF;

		IF marks != 4 THEN 
			SELECT COUNT(id) INTO marks
			FROM board
			WHERE color = last_color
				AND MAX(x) - MIN(x) = 3
				AND MAX(y) - MIN(y) = 3
			GROUP BY (x + y);
		END IF;
	
        /*an den yparxei kamia 4ada*/
		IF marks != 4 THEN 
			/*GIA PERIPTOSI ISOPALIAS*/
			SELECT COUNT(id) INTO marks 
			FROM board;
			
			IF marks = 42 THEN 
				UPDATE game_status SET result = 'D',status='ended';
				LEAVE check_winner;
			END IF;
            
			IF last_color = 'B' THEN 
				UPDATE game_status SET p_turn = 'R';
			ELSE
				UPDATE game_status SET p_turn = 'B';
			END IF;
			LEAVE check_winner;
		END IF;
        
        /*yparxei nikitis*/
        UPDATE game_status SET result = last_color ,status='ended';
        
	END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `clean_board` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `clean_board`()
BEGIN
		DELETE FROM board;
        DELETE FROM players;
        DELETE FROM game_status;
        
        INSERT INTO game_status(status) VALUES('not active');
        
	END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `players_movement` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `players_movement`(x TINYINT, id INT)
players_movement:
	BEGIN
		DECLARE max_y tinyint;
		DECLARE color, turn, status TEXT;
        
		IF x<1 OR x>7 THEN 
        LEAVE players_movement;
        END IF;

        /*metrima markwn stilis*/
        SELECT max(y) INTO max_y 
        FROM board 
        WHERE board.x=x;
        
        /*elegxos an max_y < 6 */
        IF max_y = 6 THEN 
        LEAVE players_movement;
        END IF;
        
        /*Pairnw apo to 1 row tis metablites p_turn kai status*/
        SELECT p_turn, status INTO turn, status  
        FROM game_status LIMIT 1;
        
        IF status !='started' THEN
        LEAVE players_movement;
        END IF;
        
	    SELECT color INTO color
        FROM players
        WHERE players.id=id;
        
		IF color != turn THEN 
        LEAVE players_movement;
        END IF;
        
        INSERT INTO board(x,y,color) VALUES (x,max_y+1,color);
			
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

-- Dump completed on 2020-12-31 16:10:12
