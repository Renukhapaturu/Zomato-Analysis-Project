create database Zomato_DB;
use Zomato_DB;

Create table Zomato (
			RestaurantID varchar(50),
            RestaurantName varchar(55),
            CountryCode int,
            City varchar(100),
            Locality varchar(100),
            State varchar(50),
            Longitute decimal(10,7),
            Latitude decimal(10,7),
            Cusines varchar(255),
            Currency varchar(50),
            Has_Table_Booking Varchar(10),
            Has_Online_Delivery Varchar(10),
            Is_Online_Delivery_Now varchar(10),
            Switch_To_order_Menu Varchar(10),
            Price_Range int,
            Votes int,
            Average_Cost_For_Two int,
            Rating int,
            Datekey_Opening Date);

Desc Zomato;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Zomato.csv' into table Zomato
FIELDS TERMINATED by ','
optionally  enclosed by '"'
lines terminated by '\r\n'
IGNORE 1 rows;

Select * from Zomato;

-- Q1. -- 
CREATE TABLE country_map (
    CountryCode INT PRIMARY KEY,
    CountryName VARCHAR(50));
INSERT INTO country_map VALUES
(1,'India'),
(14,'Australia'),
(30,'Brazil'),
(37,'Canada'),
(94,'Indonesia'),
(148,'New Zealand'),
(162,'Philippines'),
(166,'Qatar'),
(184,'Singapore'),
(189,'South Africa'),
(191,'Sri Lanka'),
(208,'Turkey'),
(214,'UAE'),
(215,'United Kingdom'),
(216,'United States');
SELECT * FROM COUNTRY_MAP;

-- Q2. --
CREATE TABLE calendar (
    Datekey DATE PRIMARY KEY,
    Year INT,
    MonthNo INT,
    MonthFullName VARCHAR(20),
    Quarter VARCHAR(2),
    YearMonth VARCHAR(10),
    WeekdayNo INT,
    WeekdayName VARCHAR(20),
    FinancialMonth VARCHAR(5),
    FinancialQuarter VARCHAR(5));
INSERT INTO calendar
SELECT DISTINCT
    Datekey_Opening AS Datekey,
    YEAR(Datekey_Opening) AS Year,
    MONTH(Datekey_Opening) AS MonthNo,
    MONTHNAME(Datekey_Opening) AS MonthFullName,
    CONCAT('Q', QUARTER(Datekey_Opening)) AS Quarter,
    DATE_FORMAT(Datekey_Opening, '%Y-%b') AS YearMonth,
    WEEKDAY(Datekey_Opening) + 1 AS WeekdayNo,
    DAYNAME(Datekey_Opening) AS WeekdayName,
    CONCAT('FM', CASE WHEN MONTH(Datekey_Opening) >= 4 THEN MONTH(Datekey_Opening) - 3
            ELSE MONTH(Datekey_Opening) + 9
        END
    ) AS FinancialMonth,
    CASE
        WHEN MONTH(Datekey_Opening) BETWEEN 4 AND 6 THEN 'FQ1'
        WHEN MONTH(Datekey_Opening) BETWEEN 7 AND 9 THEN 'FQ2'
        WHEN MONTH(Datekey_Opening) BETWEEN 10 AND 12 THEN 'FQ3'
        ELSE 'FQ4'
    END AS FinancialQuarter FROM zomato;
SELECT * FROM CALENDAR;

-- Q3. --
SELECT c.CountryName, z.City, COUNT(DISTINCT z.RestaurantID) AS Total_Restaurants FROM zomato z
  JOIN country_map c
    ON z.CountryCode = c.CountryCode
GROUP BY c.CountryName, z.City
ORDER BY Total_Restaurants DESC;

SELECT COUNT(DISTINCT RestaurantID) AS Total_Restaurants FROM zomato;

-- Q4. -- 
SELECT cal.Year, cal.Quarter, cal.MonthFullName, COUNT(*) AS Restaurants_Opened
FROM zomato z JOIN calendar cal ON z.Datekey_Opening = cal.Datekey
GROUP BY cal.Year, cal.Quarter, cal.MonthFullName
ORDER BY cal.Year, cal.Quarter;

-- Q5. -- 
SELECT Rating, COUNT(*) AS Restaurant_Count FROM zomato GROUP BY Rating ORDER BY Rating DESC;

-- Q6. --
SELECT
    CASE
        WHEN Average_Cost_for_two < 500 THEN 'Low Cost'
        WHEN Average_Cost_for_two BETWEEN 500 AND 1500 THEN 'Medium Cost'
        WHEN Average_Cost_for_two BETWEEN 1501 AND 3000 THEN 'High Cost'
        ELSE 'Luxury'
    END AS Price_Bucket,
    COUNT(*) AS Restaurant_Count FROM zomato GROUP BY Price_Bucket;
    
-- Q7. -- 
SELECT Has_Table_booking, ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM zomato), 2) AS Percentage FROM zomato GROUP BY Has_Table_booking;

-- Q8. -- 
SELECT Has_Online_delivery, ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM zomato), 2) AS Percentage
		FROM zomato GROUP BY Has_Online_delivery;






