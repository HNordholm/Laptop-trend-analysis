
#Welcome to this SQL datacleansing part, data imported using "import wizard".
#I will explain each part of the syntax so you can follow along, enjoy. 

#creating DB 
CREATE DATABASE laptopanalysis;

#use DB 
USE laptopanalysis; 

#creating new table laptopdatacleansing to manipulate data, saving raw file as backup. 
CREATE TABLE `ltclean` (
  `Unnamed: 0` int DEFAULT NULL,
  `Company` text,
  `TypeName` text,
  `Inches` double DEFAULT NULL,
  `ScreenResolution` text,
  `Cpu` text,
  `Ram` text,
  `Memory` text,
  `Gpu` text,
  `OpSys` text,
  `Weight` text,
  `Price` double DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

#Insert values 
INSERT INTO ltclean
SELECT * FROM laptopdataraw;

#Let's find out if there is any duplicates 

# creating CTE
WITH dup_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company,typename,inches,screenresolution,`cpu`,ram,`memory`,gpu,opsys,weight,price) AS rownum
FROM ltclean
)
SELECT COUNT(*) FROM dup_cte
WHERE rownum > 1 ; 

#29 duplicates in total. Creating a new table with rownum column and deleting rows with rownum > 1 

CREATE TABLE `ltclean2` (
  `Unnamed: 0` int DEFAULT NULL,
  `Company` text,
  `TypeName` text,
  `Inches` double DEFAULT NULL,
  `ScreenResolution` text,
  `Cpu` text,
  `Ram` text,
  `Memory` text,
  `Gpu` text,
  `OpSys` text,
  `Weight` text,
  `Price` double DEFAULT NULL,
  `rownum` INT 
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO ltclean2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company,typename,inches,screenresolution,`cpu`,ram,`memory`,gpu,opsys,weight,price) AS rownum
FROM ltclean;

DELETE FROM ltclean2 
WHERE rownum > 1; 

SELECT COUNT(*) FROM ltclean2; 
#Duplicates deleted, 1243 rows left. 

#Keep cleansing column by column, starting with company: 
SELECT DISTINCT(company) FROM ltclean2;
SELECT COUNT(*) FROM ltclean2
WHERE company IS NULL;
SELECT COUNT(*) FROM ltclean2
WHERE company ='';

#Column company is clean, lets take a look at typename:
SELECT DISTINCT(typename) FROM ltclean2;

SELECT COUNT(*) FROM ltclean2
WHERE typename IS NULL; 

SELECT COUNT(*) FROM ltclean2
WHERE typename =''; 

#Typename clean, next inches: 

SELECT DISTINCT inches FROM ltclean2; 

SELECT COUNT(*) FROM ltclean2
WHERE inches IS NULL; 

SELECT COUNT(*) FROM ltclean2
WHERE inches =''; 

#Inches clean, next screenresolution:

SELECT DISTINCT screenresolution FROM ltclean2; 

SELECT COUNT(*) FROM ltclean2
WHERE inches IS NULL; 

SELECT COUNT(*) FROM ltclean2
WHERE inches =''; 

#clean, column has many interesting features for predictive modeling and further analysis
#I will extract binary/categorial information of interest into new columns:

#Binary IPS panel 
ALTER TABLE ltclean2 ADD COLUMN ips_panel VARCHAR(3);
UPDATE ltclean2
SET ips_panel = IF(screenresolution LIKE '%IPS Panel%','yes','no');

#Binary touchscreen 
ALTER TABLE ltclean2 ADD COLUMN touchscreen VARCHAR(3);
UPDATE ltclean2
SET touchscreen = IF(screenresolution LIKE '%Touchscreen%', 'Yes', 'No');

SELECT DISTINCT(screenresolution) FROM ltclean2
WHERE screenresolution LIKE '%HD%'
ORDER BY screenresolution ASC; 

#UltraHD,fullHD,quadHD

#Creating new column resolution_category

ALTER TABLE ltclean2 ADD COLUMN resolution_category VARCHAR(20);

#Extracting HD info and insert into resolution_category:

UPDATE ltclean2
SET resolution_category =
CASE
WHEN screenresolution LIKE '%UltraHD%' THEN 'UltraHD'
WHEN screenresolution LIKE '%Quad HD%' THEN 'QuadHD'
WHEN screenresolution LIKE '%Full HD%' THEN 'FullHD'
ELSE 'No-HD'
END;

#Column manipulated, lets check CPU: 
SELECT DISTINCT cpu FROM ltclean2; 

SELECT COUNT(*) FROM ltclean2
WHERE cpu IS NULL; 

SELECT COUNT(*) FROM ltclean2
WHERE cpu =''; 

#3 brands, INTEL,AMD,SAMSUNG 

#Extracting CPUbrands into new column: 

ALTER TABLE ltclean2 ADD COLUMN CPUbrand VARCHAR(20);

UPDATE ltclean2
SET CPUbrand =
CASE
WHEN cpu LIKE '%intel%' THEN 'Intel'
WHEN cpu LIKE '%AMD%' THEN 'AMD'
WHEN cpu LIKE '%Samsung%' THEN 'Samsung'
END;

SELECT DISTINCT cpubrand FROM ltclean2; 

#Column done, next ram:

SELECT DISTINCT ram FROM ltclean2; 

SELECT COUNT(*) FROM ltclean2
WHERE ram IS NULL; 

SELECT COUNT(*) FROM ltclean2
WHERE ram =''; 

#Remove GB
UPDATE ltclean2
SET ram = REPLACE(ram, 'GB', '');

#change columnname to ramGB 
ALTER TABLE ltclean2 CHANGE COLUMN ram ramGB INT;

#Ram finished, next memory: 

SELECT DISTINCT(memory) FROM ltclean2; 

SELECT * FROM ltclean2 
WHERE memory = '?';

#Laptop with memory unknown, Il see if I can find something on internet to impute. 
# -> 512GB SSD

UPDATE ltclean2
SET memory = '512GB SSD'
WHERE memory = '?';

SELECT COUNT(*) FROM ltclean2
WHERE memory IS NULL; 

SELECT COUNT(*) FROM ltclean2
WHERE memory =''; 

SELECT DISTINCT(memory) FROM ltclean2; 

#Extracting memory to memoryGBcolumn: 
ALTER TABLE ltclean2 ADD COLUMN memoryGB INT;

UPDATE ltclean2
SET memorygb = 
CASE 
WHEN memory LIKE '%TB%' THEN CAST(REGEXP_REPLACE(memory, '[^0-9]+', '') AS UNSIGNED) * 1024
ELSE CAST(REGEXP_REPLACE(memory, '[^0-9]+', '') AS UNSIGNED)
END;

SELECT DISTINCT memory FROM ltclean2
WHERE memory LIKE '%+%'
ORDER BY memory DESC; 

UPDATE ltclean2
SET memorygb =
CASE 
	WHEN memory ='64GB Flash Storage +  1TB HDD' THEN '1088'
	WHEN memory ='512GB SSD +  512GB SSD' THEN '1024'
    WHEN memory ='512GB SSD +  2TB HDD' THEN '2560'
    WHEN memory ='512GB SSD +  256GB SSD'THEN '768'
    WHEN memory ='512GB SSD +  1TB HDD' THEN '1536'
    WHEN memory ='512GB SSD +  1.0TB Hybrid' THEN '1536'
    WHEN memory ='256GB SSD +  500GB HDD' THEN '756'
    WHEN memory ='256GB SSD +  2TB HDD' THEN '2304'
    WHEN memory ='256GB SSD +  256GB SSD' THEN '512'
    WHEN memory ='256GB SSD +  1TB HDD' THEN '1280'
    WHEN memory ='256GB SSD +  1.0TB Hybrid' THEN '1280'
    WHEN memory ='1TB SSD +  1TB HDD' THEN '2048'
    WHEN memory ='1TB HDD +  1TB HDD' THEN '2048'
    WHEN memory ='128GB SSD +  2TB HDD' THEN '2176'
    WHEN memory ='128GB SSD +  1TB HDD' THEN '1156'
    ELSE `memorygb`
    END;
    
SELECT DISTINCT memoryGB FROM ltclean2; 

#Finished, let's take a look into GPU:
SELECT DISTINCT gpu FROM ltclean2; 

SELECT COUNT(*) FROM ltclean2
WHERE gpu IS NULL; 

SELECT COUNT(*) FROM ltclean2
WHERE gpu =''; 

#Column clean, Il leave the column as it is, next opSYS:

SELECT DISTINCT opsys FROM ltclean2; 

SELECT COUNT(*) FROM ltclean2
WHERE opsys IS NULL; 

SELECT COUNT(*) FROM ltclean2
WHERE opsys =''; 

#Clean, lets check weight:

SELECT DISTINCT weight FROM ltclean2
ORDER BY weight; 

# 2 suspect entrys, "?" and '0.0002kg'
SELECT * FROM ltclean2
WHERE weight = '?'; 

#Searching info on internet for weight.
#2.96LBS -> 1.34kg

UPDATE ltclean2
SET weight = '1.34kg'
WHERE weight = '?';

# 0.0002kg
SELECT * FROM ltclean2
WHERE weight = '0.0002kg'; 

#Correct: 1.22kg 

UPDATE ltclean2
SET weight = '1.22kg'
WHERE weight = '0.0002kg';

#manipulate column 
UPDATE ltclean2
SET weight = CAST(REPLACE(weight, 'kg', '') AS DECIMAL(10, 2));

ALTER TABLE ltclean2
CHANGE COLUMN weight weightKG DECIMAL(10, 2);

#Checking nulls 

SELECT COUNT(*) FROM ltclean2
WHERE weightKG IS NULL; 

SELECT COUNT(*) FROM ltclean2
WHERE weightKG =''; 

#Column finished, taking a look into price: 

SELECT DISTINCT price FROM ltclean2
ORDER BY price DESC; 

#prices in indian rupees, converting into USD: 

ALTER TABLE ltclean2 ADD COLUMN priceUSD DECIMAL(10, 2);

SET @exchange_rate = 0.012;

UPDATE ltclean2
SET priceUSD = ROUND(price * @exchange_rate, 2);

#Columns finished, lets take a look:
SELECT * FROM ltclean2
LIMIT 5; 

# Deleting columns price,rownum
ALTER TABLE ltclean2 DROP COLUMN rownum;
ALTER TABLE ltclean2 DROP COLUMN price;

#lower touchscreen
UPDATE ltclean2
SET touchscreen = LOWER(touchscreen);

#checking columntypes 
DESCRIBE ltclean2; 

#Ordering columns
ALTER TABLE ltclean2
MODIFY COLUMN `Unnamed: 0` INT FIRST,
MODIFY COLUMN touchscreen varchar(3) AFTER screenresolution,
MODIFY COLUMN cpubrand varchar(20) AFTER cpu,
MODIFY COLUMN ips_panel varchar(3) AFTER touchscreen,
MODIFY COLUMN resolution_category varchar(20) AFTER screenresolution;

#Data cleaning done for now, you could of course extract more information from the CPU but I'll leave that
#information intact for now, thanks for getting through this process,
#in the next part I will analyze the data with SQL, followed by visualization and statistical methods in R. thanks!

















