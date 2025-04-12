--ANALYSIS QUESTIONS
USE project;


SELECT * FROM [dbo].[ZomatoData1]



--ROLLING/MOVING COUNT OF RESTAURANTS IN INDIAN CITIES
SELECT [COUNTRY_NAME],[City],[Locality],COUNT([Locality]) TOTAL_REST,
SUM(COUNT([Locality])) OVER(PARTITION BY [City] ORDER BY [Locality] DESC)
FROM [dbo].[ZomatoData1]
WHERE [COUNTRY_NAME] = 'INDIA'
GROUP BY  [COUNTRY_NAME],[City],[Locality]



--SEARCHING FOR PERCENTAGE OF RESTAURANTS IN ALL THE COUNTRIES
CREATE OR ALTER VIEW TOTAL_COUNT
AS
(
SELECT DISTINCT([COUNTRY_NAME]),COUNT(CAST([RestaurantID]AS NUMERIC)) OVER() TOTAL_REST
FROM [dbo].[ZomatoData1]
--ORDER BY 1
)
SELECT * FROM TOTAL_COUNT

FINAL QUERY AFTER CREATING VIEW
WITH CT1 AS
(
SELECT [COUNTRY_NAME], COUNT(CAST([RestaurantID]AS NUMERIC)) REST_COUNT
FROM [dbo].[ZomatoData1]
GROUP BY [COUNTRY_NAME]
)
SELECT A.[COUNTRY_NAME],A.[REST_COUNT] ,ROUND(CAST(A.[REST_COUNT] AS DECIMAL)/CAST(B.[TOTAL_REST]AS DECIMAL)*100,2)
FROM CT1 A JOIN TOTAL_COUNT B
ON A.[COUNTRY_NAME] = B.[COUNTRY_NAME]
ORDER BY 3 DESC



--WHICH COUNTRIES AND HOW MANY RESTAURANTS WITH PERCENTAGE PROVIDES ONLINE DELIVERY OPTION
CREATE OR ALTER VIEW COUNTRY_REST
AS(
SELECT [COUNTRY_NAME], COUNT(CAST([RestaurantID]AS NUMERIC)) REST_COUNT
FROM [dbo].[ZomatoData1]
GROUP BY [COUNTRY_NAME]
)
SELECT * FROM COUNTRY_REST
ORDER BY 2 DESC

SELECT A.[COUNTRY_NAME],COUNT(A.[RestaurantID]) TOTAL_REST, 
ROUND(COUNT(CAST(A.[RestaurantID] AS DECIMAL))/CAST(B.[REST_COUNT] AS DECIMAL)*100, 2)
FROM [dbo].[ZomatoData1] A JOIN COUNTRY_REST B
ON A.[COUNTRY_NAME] = B.[COUNTRY_NAME]
WHERE A.[Has_Online_delivery] = 'YES'
GROUP BY A.[COUNTRY_NAME],B.REST_COUNT
ORDER BY 2 DESC



--FINDING FROM WHICH CITY AND LOCALITY IN INDIA WHERE THE MAX RESTAURANTS ARE LISTED IN ZOMATO
WITH CT1
AS
(
SELECT [City],[Locality],COUNT([RestaurantID]) REST_COUNT
FROM [dbo].[ZomatoData1]
WHERE [COUNTRY_NAME] = 'INDIA'
GROUP BY CITY,LOCALITY
--ORDER BY 3 DESC
)
SELECT [Locality],REST_COUNT FROM CT1 WHERE REST_COUNT = (SELECT MAX(REST_COUNT) FROM CT1)



--TYPES OF FOODS ARE AVAILABLE IN INDIA WHERE THE MAX RESTAURANTS ARE LISTED IN ZOMATO
WITH CT1
AS
(
SELECT [City],[Locality],COUNT([RestaurantID]) REST_COUNT
FROM [dbo].[ZomatoData1]
WHERE [COUNTRY_NAME] = 'INDIA'
GROUP BY CITY,LOCALITY
--ORDER BY 3 DESC
),
CT2 AS (
SELECT [Locality],REST_COUNT FROM CT1 WHERE REST_COUNT = (SELECT MAX(REST_COUNT) FROM CT1)
),
CT3 AS (
SELECT [Locality],[Cuisines] FROM [dbo].[ZomatoData1]
)
SELECT  A.[Locality], B.[Cuisines]
FROM  CT2 A JOIN CT3 B
ON A.Locality = B.[Locality]



--MOST POPULAR FOOD IN INDIA WHERE THE MAX RESTAURANTS ARE LISTED IN ZOMATO
CREATE VIEW VF 
AS
(
SELECT [COUNTRY_NAME],[City],[Locality],N.[Cuisines] FROM [dbo].[ZomatoData1]
CROSS APPLY (SELECT VALUE AS [Cuisines] FROM string_split([Cuisines],'|')) N
)

WITH CT1
AS
(
SELECT [City],[Locality],COUNT([RestaurantID]) REST_COUNT
FROM [dbo].[ZomatoData1]
WHERE [COUNTRY_NAME] = 'INDIA'
GROUP BY CITY,LOCALITY
--ORDER BY 3 DESC
),
CT2 AS (
SELECT [Locality],REST_COUNT FROM CT1 WHERE REST_COUNT = (SELECT MAX(REST_COUNT) FROM CT1)
)
SELECT A.[Cuisines], COUNT(A.[Cuisines])
FROM VF A JOIN CT2 B
ON A.Locality = B.[Locality]
GROUP BY B.[Locality],A.[Cuisines]
ORDER BY 2 DESC



--WHICH LOCALITIES IN INDIA HAS THE LOWEST RESTAURANTS LISTED IN ZOMATO
WITH CT1 AS
(
SELECT [City],[Locality], COUNT([RestaurantID]) REST_COUNT
FROM [dbo].[ZomatoData1]
WHERE [COUNTRY_NAME] = 'INDIA'
GROUP BY [City],[Locality]
-- ORDER BY 3 DESC
)
SELECT * FROM CT1 WHERE REST_COUNT = (SELECT MIN(REST_COUNT) FROM CT1) ORDER BY CITY



--HOW MANY RESTAURANTS OFFER TABLE BOOKING OPTION IN INDIA WHERE THE MAX RESTAURANTS ARE LISTED IN ZOMATO
WITH CT1 AS (
SELECT [City],[Locality],COUNT([RestaurantID]) REST_COUNT
FROM [dbo].[ZomatoData1]
WHERE [COUNTRY_NAME] = 'INDIA'
GROUP BY CITY,LOCALITY
--ORDER BY 3 DESC
),
CT2 AS (
SELECT [Locality],REST_COUNT FROM CT1 WHERE REST_COUNT = (SELECT MAX(REST_COUNT) FROM CT1)
),
CT3 AS (
SELECT [Locality],[Has_Table_booking] TABLE_BOOKING
FROM [dbo].[ZomatoData1]
)
SELECT A.[Locality], COUNT(A.TABLE_BOOKING) TABLE_BOOKING_OPTION
FROM CT3 A JOIN CT2 B
ON A.[Locality] = B.[Locality]
WHERE A.TABLE_BOOKING = 'YES'
GROUP BY A.[Locality]



-- HOW RATING AFFECTS IN MAX LISTED RESTAURANTS WITH AND WITHOUT TABLE BOOKING OPTION (Connaught Place)
SELECT 'WITH_TABLE' TABLE_BOOKING_OPT,COUNT([Has_Table_booking]) TOTAL_REST, ROUND(AVG([Rating]),2) AVG_RATING
FROM [dbo].[ZomatoData1]
WHERE [Has_Table_booking] = 'YES'
AND [Locality] = 'Connaught Place'
UNION
SELECT 'WITHOUT_TABLE' TABLE_BOOKING_OPT,COUNT([Has_Table_booking]) TOTAL_REST, ROUND(AVG([Rating]),2) AVG_RATING
FROM [dbo].[ZomatoData1]
WHERE [Has_Table_booking] = 'NO'
AND [Locality] = 'Connaught Place'



--AVG RATING OF RESTS LOCATION WISE
SELECT [COUNTRY_NAME],[City],[Locality], 
COUNT([RestaurantID]) TOTAL_REST ,ROUND(AVG(CAST([Rating] AS DECIMAL)),2) AVG_RATING
FROM [dbo].[ZomatoData1]
GROUP BY [COUNTRY_NAME],[City],[Locality]
ORDER BY 4 DESC



--FINDING THE BEST RESTAURANTS WITH MODRATE COST FOR TWO IN INDIA HAVING INDIAN CUISINES
SELECT *
FROM [dbo].[ZomatoData1]
WHERE [COUNTRY_NAME] = 'INDIA'
AND [Has_Table_booking] = 'YES'
AND [Has_Online_delivery] = 'YES'
AND [Price_range] <= 3
AND [Votes] > 1000
AND [Average_Cost_for_two] < 1000
AND [Rating] > 4
AND [Cuisines] LIKE '%INDIA%'



--FIND ALL THE RESTAURANTS THOSE WHO ARE OFFERING TABLE BOOKING OPTIONS WITH PRICE RANGE AND HAS HIGH RATING
SELECT [Price_range], COUNT([Has_Table_booking]) NO_OF_REST
FROM [dbo].[ZomatoData1]
WHERE [Rating] >= 4.5
AND [Has_Table_booking] = 'YES'
GROUP BY [Price_range] 

