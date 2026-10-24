/*
=========================================================
Project: Electronics Product Analysis Using SQL Server
Author: Ibrar Aman

Objectives:
1. Clean raw product data
2. Engineer analytical features
3. Perform exploratory data analysis
4. Apply statistical techniques
5. Generate business insights

Skills Demonstrated:
- SQL Server
- Data Cleaning
- Feature Engineering
- EDA
- Descriptive Statistics
- Outlier Detection
- Correlation Analysis
- Business Intelligence
=========================================================
*/

CREATE DATABASE CampusX2;

SELECT * FROM ElectronicsData;

EXEC sp_help 'ElectronicsData';


-------------------------------------------
-- Cleaning Of Data
-------------------------------------------

-- Sub_Category Column
-- No Need to clean Sub_Category Column
SELECT DISTINCT Sub_Category FROM ElectronicsData
---------------------------------------------------------------------------------------------

-- Cleaning OF Price Column
SELECT price FROM ElectronicsData

-- Remove $ and , from price
SELECT Price, 
	   REPLACE(REPLACE(Price, '$', ''), ',', '') 
FROM ElectronicsData

UPDATE ElectronicsData
SET Price = REPLACE(REPLACE(Price, '$', ''), ',', '')

-- Remove through and make ave of values before through and after through from price
SELECT Price,
       CAST(
           LEFT(Price, CHARINDEX('through-', Price) - 1)
           AS DECIMAL(10,2)
       ) AS StartPrice,

       CAST(
        SUBSTRING(
            Price,
            CHARINDEX('through-', Price) + LEN('through-'),
            LEN(Price)
        )
        AS DECIMAL(10,2)
    ) AS EndPrice,
   
    CAST(
(
    CAST(
        LEFT(Price, CHARINDEX('through-', Price) - 1)
        AS DECIMAL(10,2)
    )
    +
    CAST(
        SUBSTRING(
            Price,
            CHARINDEX('through-', Price) + LEN('through-'),
            LEN(Price)
        )
        AS DECIMAL(10,2)
    )
) / 2.0
AS DECIMAL(10,2)) AS AvgPrice
FROM ElectronicsData
WHERE Price LIKE '%through-%';


-- Update the price
UPDATE ElectronicsData
SET Price =
    CAST(
        (
            CAST(
                LEFT(Price, CHARINDEX('through-', Price) - 1)
                AS DECIMAL(10,2)
            )
            +
            CAST(
                SUBSTRING(
                    Price,
                    CHARINDEX('through-', Price) + LEN('through-'),
                    LEN(Price)
                )
                AS DECIMAL(10,2)
            )
        ) / 2.0
    AS DECIMAL(10,2))
WHERE Price LIKE '%through-%';

ALTER TABLE ElectronicsData
ALTER COLUMN Price DECIMAL(10,2);

EXEC sp_help 'ElectronicsData';

-----------------------------------------------------------------------------------------------------------

-- Cleaning Of Discount Column

SELECT DISTINCT Discount FROM ElectronicsData


-- Create new column name is_discount_given
ALTER TABLE ElectronicsData
ADD discount_given VARCHAR(3);



SELECT * FROM ElectronicsData


SELECT DISCOUNT,
    CASE
        WHEN Discount LIKE '%no discount%' THEN 'No'
        ELSE 'Yes'
    END AS discount_given
FROM ElectronicsData


-- Update or correct values of is_discount_given
UPDATE ElectronicsData 
SET is_discount_given = 
    CASE
        WHEN Discount LIKE '%no discount%' THEN 'No'
        ELSE 'Yes'
    END

SELECT * FROM ElectronicsData



-- Create new column MRP
ALTER TABLE ElectronicsData
ADD MRP DECIMAL(10, 2) 


-- Cleaning discount Column for MRP
SELECT
    Price,
    Discount,
    CASE
        WHEN LOWER(Discount) LIKE '%no discount%' THEN Price

        WHEN LOWER(Discount) LIKE '%off%' THEN
            Price +
            TRY_CAST(
                RIGHT(
                    LEFT(Discount, CHARINDEX('OFF', Discount) - 1),
                    CHARINDEX('$', REVERSE(LEFT(Discount, CHARINDEX('OFF', Discount) - 1))) - 1
                ) AS INT
            )

        ELSE NULL
    END AS OriginalPrice
FROM ElectronicsData;


-- Updating MRP Values
UPDATE ElectronicsData
SET MRP =
    CASE
        WHEN Discount LIKE '%no discount%' THEN Price

        WHEN Discount LIKE '%OFF%' THEN
            Price +
            TRY_CAST(
                RIGHT(
                    LEFT(Discount, CHARINDEX('OFF', Discount) - 1),
                    CHARINDEX('$', REVERSE(LEFT(Discount, CHARINDEX('OFF', Discount) - 1))) - 1
                ) AS INT
            )

        ELSE NULL
    END;

SELECT * FROM ElectronicsData;


-- Rename Discount To DiscountType
EXEC sp_rename
    'ElectronicsData.Discount',
    'DiscountType',
    'COLUMN';

SELECT DISTINCT DiscountType FROM ElectronicsData;


-- Changing DiscountType To categories
SELECT
    DiscountType,
    CASE
        WHEN DiscountType LIKE '%OFF%' THEN 'Amount Discount'
        WHEN DiscountType LIKE '%No Discount%' THEN 'No Discount'
        WHEN DiscountType LIKE '%Free Shipping%' THEN 'Free Shipping'
        WHEN DiscountType LIKE '%Price valid through%' THEN 'Validity Promotion'
        WHEN DiscountType LIKE '%Special Event%' THEN 'Special Event'
        WHEN DiscountType IS NULL THEN 'Missing'
        ELSE 'Other'
    END AS DiscountCategory
FROM ElectronicsData;


UPDATE ElectronicsData
SET DiscountType = CASE
        WHEN DiscountType LIKE '%OFF%' THEN 'Amount Discount'
        WHEN DiscountType LIKE '%No Discount%' THEN 'No Discount'
        WHEN DiscountType LIKE '%Free Shipping%' THEN 'Free Shipping'
        WHEN DiscountType LIKE '%Price valid through%' THEN 'Validity Promotion'
        WHEN DiscountType LIKE '%Special Event%' THEN 'Special Event'
        WHEN DiscountType IS NULL THEN 'Missing'
        ELSE 'Other'
    END

SELECT * FROM ElectronicsData WHERE DiscountType='Amount Discount'

-------------------------------------------------------------------------------------------------------------

-- Cleaning Of Rating Column

EXEC sp_help 'ElectronicsData';

SELECT * FROM ElectronicsData;


-- Extract 2 Things from Rating
-- 1- Rating
-- 2- Count Of Reviews

SELECT Rating FROM ElectronicsData


-- Create New Column for Rating 
ALTER TABLE ElectronicsData
ADD Average_Rating DECIMAL(3,1);


SELECT
    Rating,
    CAST(
        SUBSTRING(
            Rating,
            LEN('Rated ') + 1,
            CHARINDEX(' out of', Rating) - LEN('Rated ') - 1
        )
        AS DECIMAL(5,2)
    ) AS RatingValue
FROM ElectronicsData;


SELECT DISTINCT Rating FROM ElectronicsData 

SELECT * FROM ElectronicsData

SELECT
    Rating,
    CASE
        WHEN Rating LIKE 'Rated%out of%'
        THEN TRY_CAST(
                SUBSTRING(
                    Rating,
                    LEN('Rated ') + 1,
                    CHARINDEX(' out of', Rating) - LEN('Rated ') - 1
                )
                AS DECIMAL(5,1)
             )
        ELSE NULL
    END AS RatingValue
FROM ElectronicsData;


-- Update the Values of Average_Rating that has extracted from Rating.
UPDATE ElectronicsData
SET Average_Rating = 
    CASE
        WHEN Rating LIKE 'Rated%out of%'
        THEN TRY_CAST(
                SUBSTRING(
                    Rating,
                    LEN('Rated ') + 1,
                    CHARINDEX(' out of', Rating) - LEN('Rated ') - 1
                )
                AS DECIMAL(5,1)
             )
        ELSE NULL
    END


-- Creating a new Column for Rating Review Count
ALTER TABLE ElectronicsData
ADD Reviews_Count INT

-- Extract number of Reviews/
SELECT
    Rating,
    CASE
        WHEN Rating LIKE '%based on%reviews%'
        THEN TRY_CAST(
            SUBSTRING(
                Rating,
                CHARINDEX('based on ', Rating) + LEN('based on '),
                CHARINDEX(' reviews', Rating) -
                (CHARINDEX('based on ', Rating) + LEN('based on '))
            ) AS INT
        )
        ELSE NULL
    END AS Total_Reviews
FROM ElectronicsData;

-- Update new Column named Reviews_Count Values
UPDATE ElectronicsData
SET Reviews_Count = 
    CASE
        WHEN Rating LIKE '%based on%reviews%'
        THEN TRY_CAST(
            SUBSTRING(
                Rating,
                CHARINDEX('based on ', Rating) + LEN('based on '),
                CHARINDEX(' reviews', Rating) -
                (CHARINDEX('based on ', Rating) + LEN('based on '))
            ) AS INT
        )
        ELSE NULL
    END

--------------------------------------------------------------------------------------------------------

-- Now Drop Rating Column as we do not need that.
ALTER TABLE ElectronicsData
DROP COLUMN Rating

--------------------------------------------------------------------------------------------------------

-- Cleaning Of Title

SELECT DISTINCT Title FROM ElectronicsData


-- Create new column name brand, becuase the first word of title is brand name, Extract the first word and put in new col.
ALTER TABLE ElectronicsData
ADD Brand_Name VARCHAR(30)



SELECT Title
FROM ElectronicsData
WHERE Title LIKE '%MW%';

SELECT DISTINCT title FROM ElectronicsData


-- Extract Proper Brand_Names from title column
SELECT
    Title,
    CASE
        WHEN Title LIKE '%AirPods%' THEN 'Apple'
        WHEN Title LIKE '%MacBook%' THEN 'Apple'
        WHEN Title LIKE '%iPad%' THEN 'Apple'
        WHEN Title LIKE '%iMac%' THEN 'Apple'
        WHEN Title LIKE 'Mac %' OR Title LIKE 'Mac:%' OR Title LIKE 'Mac mini%' OR Title LIKE 'Mac Studio%' THEN 'Apple'
        WHEN Title LIKE '%HomePod%' THEN 'Apple'

        WHEN Title LIKE '%Chromecast%' THEN 'Google'

        WHEN Title LIKE '%Xbox%' THEN 'Microsoft'

        WHEN Title LIKE '%PlayStation%' THEN 'Sony'

        WHEN Title LIKE '%Powerbeats%' THEN 'Beats'

        WHEN Title LIKE 'CHARGE %' THEN 'JBL'

        WHEN Title LIKE 'Singing Machine%' THEN 'Singing Machine'

        WHEN Title LIKE 'MW Mounts%' THEN 'MW Mounts'

        WHEN Title LIKE '$% Nintendo%' THEN 'Nintendo'

        WHEN Title LIKE 'My Arcade%' THEN 'My Arcade'

        ELSE LEFT(Title, CHARINDEX(' ', Title + ' ') - 1)
    END AS Brand_Name
FROM ElectronicsData;


-- Update Brand_Name values to proper brand name extracted from title.
UPDATE ElectronicsData
SET Brand_Name = 
    CASE
        WHEN Title LIKE '%AirPods%' THEN 'Apple'
        WHEN Title LIKE '%MacBook%' THEN 'Apple'
        WHEN Title LIKE '%iPad%' THEN 'Apple'
        WHEN Title LIKE '%iMac%' THEN 'Apple'
        WHEN Title LIKE 'Mac %' OR Title LIKE 'Mac:%' OR Title LIKE 'Mac mini%' OR Title LIKE 'Mac Studio%' THEN 'Apple'
        WHEN Title LIKE '%HomePod%' THEN 'Apple'

        WHEN Title LIKE '%Chromecast%' THEN 'Google'

        WHEN Title LIKE '%Xbox%' THEN 'Microsoft'

        WHEN Title LIKE '%PlayStation%' THEN 'Sony'

        WHEN Title LIKE '%Powerbeats%' THEN 'Beats'

        WHEN Title LIKE 'CHARGE %' THEN 'JBL'

        WHEN Title LIKE 'Singing Machine%' THEN 'Singing Machine'

        WHEN Title LIKE 'MW Mounts%' THEN 'MW Mounts'

        WHEN Title LIKE '$% Nintendo%' THEN 'Nintendo'

        WHEN Title LIKE 'My Arcade%' THEN 'My Arcade'

        ELSE LEFT(Title, CHARINDEX(' ', Title + ' ') - 1)
    END



SELECT Brand_Name FROM ElectronicsData

SELECT DISTINCT Brand_Name
FROM ElectronicsData
ORDER BY Brand_Name;


SELECT * FROM ElectronicsData;
SELECT TOP 5 * FROM ElectronicsData ORDER BY NEWID();
--------------------------------------------------------------------------------------------------------------------

-- Cleaning Of Feature Column

SELECT DISTINCT Feature FROM ElectronicsData

UPDATE ElectronicsData
SET Feature = REPLACE(Feature,'®','');

UPDATE ElectronicsData
SET Feature = REPLACE(Feature,'™','');

UPDATE ElectronicsData
SET Feature = REPLACE(Feature,'’','''');


SELECT feature FROM ElectronicsData

SELECT COUNT(*)
FROM ElectronicsData
WHERE Feature IS NULL;



SELECT Feature, COUNT(*)
FROM ElectronicsData
GROUP BY Feature
HAVING COUNT(*) > 1;

---------------------------------------------------------------------------------------------------------------------------------

-- EDA Section
-- Univariate Analysis {Numerical Column}
-- On Price Column

-- 1- Check Null Values
SELECT COUNT(*) AS PriceNullValues FROM ElectronicsData WHERE Price IS NULL


-- 2- Find Min, Max, Avg and st ?
SELECT MIN(Price) AS MinPrice, MAX(Price) AS MaxPrice, AVG(Price) AS AvgPrice, STDEV(Price) StdPrice FROM ElectronicsData;

-- 3- Find Percentile of price ?
SELECT DISTINCT
    PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY Price) OVER () AS Q1,
    PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY Price) OVER () AS Median,
    PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY Price) OVER () AS Q3
FROM ElectronicsData;

-- 3- Find Percentile of each price ?

SELECT
        Title,
        Price,
        ROUND(PERCENT_RANK() OVER (ORDER BY Price), 2) AS Percentile_Rank
FROM ElectronicsData



SELECT Price, MAX(Percentile_Rank) FROM
(
    SELECT
        Title,
        Price,
        ROUND(PERCENT_RANK() OVER (ORDER BY Price), 2) AS Percentile_Rank
    FROM ElectronicsData
)k GROUP BY Price 




-- Get Price by percentile VALUE THROUGH STORE PROCEDURE
CREATE OR ALTER PROCEDURE GetPriceByPercentile 
    @percentileValue DECIMAL(3, 2), 
    @Price DECIMAL(10,2) OUTPUT
AS
BEGIN
    SELECT @price = MAX(Price) FROM
    (
        SELECT
            Title,
            Price,
            ROUND(PERCENT_RANK() OVER (ORDER BY Price), 2) AS Percentile_Rank
        FROM ElectronicsData
    )k
    WHERE percentile_Rank = @percentileValue
END

DECLARE
    @Q1 DECIMAL(10,2),
    @Q2 DECIMAL(10,2),
    @Q3 DECIMAL(10,2);

EXEC GetPriceByPercentile 0.25, @Q1 OUTPUT;
EXEC GetPriceByPercentile 0.50, @Q2 OUTPUT;
EXEC GetPriceByPercentile 0.73, @Q3 OUTPUT;


SELECT
    @Q1 AS Q1_Price,
    @Q2 AS Q2_Price,
    @Q3 AS Q3_Price
    


-- Now Finding Outliers
WITH Quartiles AS
(
    SELECT DISTINCT
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY Price) OVER () AS Q1,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY Price) OVER () AS Q3
    FROM ElectronicsData
)
SELECT *
FROM ElectronicsData e
CROSS JOIN Quartiles q
WHERE Price < (q.Q1 - 1.5 * (q.Q3 - q.Q1))
   OR Price > (q.Q3 + 1.5 * (q.Q3 - q.Q1));



-- Find Histogram
SELECT BUCKETS, COUNT(*) FROM
(
    SELECT price,
        CASE
            WHEN PRICE BETWEEN 0 AND 500 THEN '0-0.5K'
            WHEN PRICE BETWEEN 501 AND 1500 THEN '0.5K-1.5K'
            WHEN PRICE BETWEEN 1501 AND 3000 THEN '1.5K-3K'
            WHEN PRICE BETWEEN 3001 AND 6000 THEN '3K-6K'
            ELSE '>6K'
        END AS BUCKETS
    FROM ElectronicsData
)k
GROUP BY BUCKETS



--------------------------------------------------------------------------------------------------
-- EDA On Catgeorical Column

SELECT * FROM ElectronicsData;

-- Checking Distinct Values Of Sub Category
SELECT DISTINCT Sub_Category FROM ElectronicsData;

-- Checking null values in Sub_Category
SELECT COUNT(*) FROM ElectronicsData WHERE Sub_Category IS NULL;

-- Checking Counts of each Sub Category
SELECT Sub_Category, COUNT(Sub_Category) AS SubCategoryCount FROM ElectronicsData GROUP BY Sub_Category;

----------------------------------------------------------------------------------------------------

-- Bivariate Analysis
-- Numerical Columns

SELECT * FROM ElectronicsData;

SELECT Reviews_Count, Average_Rating FROM ElectronicsData;



-- Finding CoVariance
WITH Stats AS
(
    SELECT
        AVG(Average_Rating * 1.0) AS AvgRating,
        AVG(Reviews_Count * 1.0) AS AvgReviews,
        COUNT(*) AS N
    FROM ElectronicsData
)
SELECT
    SUM(
        (e.Average_Rating - s.AvgRating) *
        (e.Reviews_Count - s.AvgReviews)
    ) / (MAX(s.N) - 1.0) AS Covariance
FROM ElectronicsData e
CROSS JOIN Stats s;


-- Finding Co Relation
WITH Stats AS
(
    SELECT
        AVG(Average_Rating * 1.0) AS AvgRating,
        AVG(Reviews_Count * 1.0) AS AvgReviews
    FROM ElectronicsData
)
SELECT
    SUM(
        (e.Average_Rating - s.AvgRating) *
        (e.Reviews_Count - s.AvgReviews)
    )
    /
    SQRT(
        SUM(POWER(e.Average_Rating - s.AvgRating, 2))
        *
        SUM(POWER(e.Reviews_Count - s.AvgReviews, 2))
    ) AS Correlation
FROM ElectronicsData e
CROSS JOIN Stats s
WHERE e.Average_Rating IS NOT NULL
  AND e.Reviews_Count IS NOT NULL;



-- Find Slope
WITH Stats AS
(
    SELECT
        AVG(Average_Rating * 1.0) AS AvgX,
        AVG(Reviews_Count * 1.0) AS AvgY
    FROM ElectronicsData
    WHERE Average_Rating IS NOT NULL
      AND Reviews_Count IS NOT NULL
)
SELECT
    SUM(
        (e.Average_Rating - s.AvgX) *
        (e.Reviews_Count - s.AvgY)
    )
    /
    SUM(
        POWER(e.Average_Rating - s.AvgX, 2)
    ) AS Slope
FROM ElectronicsData e
CROSS JOIN Stats s
WHERE e.Average_Rating IS NOT NULL
  AND e.Reviews_Count IS NOT NULL;



-- Categorical - Categorical (Bivariate Analysis)
SELECT * FROM ElectronicsData;

SELECT Brand_Name, COUNT(DISTINCT(Sub_Category)) AS SubCategoryCounts
FROM ElectronicsData
GROUP BY Brand_Name;


-- Numerical - Categorical Analysis (Bivariate Analysis)
SELECT * FROM ElectronicsData;

SELECT Brand_Name, 
    MAX(Price) AS MaxPrice,
    MIN(Price) AS MinPrice,
    ROUND(AVG(Price), 2) AS AvgPrice,
    ROUND(STDEV(Price), 2) AS StdPrice
FROM ElectronicsData
GROUP BY Brand_Name;


-- MultiVariant Analysis
WITH Stats AS
(
    SELECT
        [Sub_Category],
        AVG(Price * 1.0) AS AvgPrice,
        AVG(MRP * 1.0) AS AvgMRP,
        COUNT(*) AS N
    FROM ElectronicsData
    GROUP BY [Sub_Category]
)
SELECT
    e.[Sub_Category],
    ROUND(
        SUM(
            (e.Price - s.AvgPrice)
            *
            (e.MRP - s.AvgMRP)
        ) / (MAX(s.N) - 1.0),
        2
    ) AS Covariance
FROM ElectronicsData e
JOIN Stats s
    ON e.[Sub_Category] = s.[Sub_Category]
GROUP BY e.[Sub_Category];

-------------------------------------------------------------------------------------------------------------------
--------------------------------------------------
-- 1: Data Quality Assessment
--------------------------------------------------

-- Objective
-- Understanding missing values helps determine
-- data quality and whether imputation or row removal
-- is required before further analysis.

SELECT
    SUM(CASE WHEN Price IS NULL THEN 1 ELSE 0 END) AS MissingPrice,
    SUM(CASE WHEN Average_Rating IS NULL THEN 1 ELSE 0 END) AS MissingRating,
    SUM(CASE WHEN Reviews_Count IS NULL THEN 1 ELSE 0 END) AS MissingReviews,
    SUM(CASE WHEN Brand_Name IS NULL THEN 1 ELSE 0 END) AS MissingBrand,
    SUM(CASE WHEN Sub_Category IS NULL THEN 1 ELSE 0 END) AS MissingSubCategory
FROM ElectronicsData;




--------------------------------------------------
-- Business Insights 2: Duplicate Record Analysis
--------------------------------------------------

-- Objective
-- Duplicate product records may inflate
-- inventory counts, average prices,
-- and review metrics.

SELECT Title, COUNT(*) AS DuplicateCount
    FROM ElectronicsData
GROUP BY Title
HAVING COUNT(*) > 1;




--------------------------------------------------
-- Business Insights 3: Premium Product Categories (Most Expensive Categories)
--------------------------------------------------

-- Objective
-- Identifies premium product categories
-- that generate higher-value sales.

SELECT
    Sub_Category,
    ROUND(AVG(Price),2) AvgPrice
FROM ElectronicsData
GROUP BY Sub_Category
ORDER BY AvgPrice DESC;





--------------------------------------------------
-- Business Insights 4: Customer Satisfaction (Brands With Highest Ratings)
--------------------------------------------------

-- Objective
-- Highlights brands with the strongest
-- customer satisfaction.

SELECT
    Brand_Name,
    ROUND(AVG(Average_Rating),2) AvgRating,
    COUNT(*) Products
FROM ElectronicsData
GROUP BY Brand_Name
HAVING COUNT(*) >= 5
ORDER BY AvgRating DESC;







--------------------------------------------------
-- Business Insights 5: Popularity Analysis (Brands With Most Reviews)
--------------------------------------------------

-- Objective
-- Brands with more reviews usually have
-- higher customer engagement and visibility.

SELECT
    Brand_Name,
    SUM(Reviews_Count) TotalReviews
FROM ElectronicsData
GROUP BY Brand_Name
ORDER BY TotalReviews DESC;





--------------------------------------------------
-- Business Insights 6. Price Distribution by Brand
--------------------------------------------------

-- Objective
-- Shows whether a brand targets
-- budget, mid-range, or premium customers.

SELECT
    Brand_Name,
    MIN(Price) MinPrice,
    MAX(Price) MaxPrice,
    ROUND(AVG(Price),2) AvgPrice,
    ROUND(STDEV(Price),2) StdDevPrice
FROM ElectronicsData
GROUP BY Brand_Name
ORDER BY AvgPrice DESC;





--------------------------------------------------
-- Business Insights 7. Top 10 Most Expensive Products
--------------------------------------------------

-- Objective
-- Identifies premium products and
-- potential price outliers.

SELECT TOP 10
    Title,
    Brand_Name,
    Price
FROM ElectronicsData
ORDER BY Price DESC 



--------------------------------------------------
-- Business Insights 8. Rating Categories
--------------------------------------------------

-- Objective
-- Provides a customer satisfaction overview.
SELECT
    CASE
        WHEN Average_Rating >= 4.5 THEN 'Excellent'
        WHEN Average_Rating >= 4.0 THEN 'Good'
        WHEN Average_Rating >= 3.0 THEN 'Average'
        ELSE 'Poor'
    END RatingCategory,
    COUNT(*) Products
FROM ElectronicsData
GROUP BY
    CASE
        WHEN Average_Rating >= 4.5 THEN 'Excellent'
        WHEN Average_Rating >= 4.0 THEN 'Good'
        WHEN Average_Rating >= 3.0 THEN 'Average'
        ELSE 'Poor'
    END;





--------------------------------------------------
-- Business Insights 9. Correlation Matrix
--------------------------------------------------

-- Objective
-- Determines whether lower-priced
-- products receive more engagement.

WITH Stats AS
(
    SELECT
        AVG(Price) AvgPrice,
        AVG(Reviews_Count) AvgReviews
    FROM ElectronicsData
)
SELECT
SUM((Price-AvgPrice)*(Reviews_Count-AvgReviews))
/
SQRT(
SUM(POWER(Price-AvgPrice,2))
*
SUM(POWER(Reviews_Count-AvgReviews,2))
) AS Correlation
FROM ElectronicsData
CROSS JOIN Stats;








--------------------------------------------------
-- Business Insights 10. Revenue Opportunity Analysis
--------------------------------------------------

-- Objective
-- Combines popularity and pricing
-- to identify brands with strong
-- commercial potential.

SELECT
    Brand_Name,
    COUNT(*) ProductCount,
    ROUND(AVG(Price),2) AvgPrice,
    SUM(ISNULL(Reviews_Count,0)) TotalReviews
FROM ElectronicsData
GROUP BY Brand_Name
ORDER BY TotalReviews DESC;







--------------------------------------------------
-- Business Insights 11. Premium vs Budget Products
--------------------------------------------------

-- Objective
-- Shows the product mix across
-- different price segments.

SELECT
    CASE
        WHEN Price < 500 THEN 'Budget'
        WHEN Price BETWEEN 500 AND 1500 THEN 'Mid-Range'
        ELSE 'Premium'
    END ProductSegment,
    COUNT(*) Products
FROM ElectronicsData
GROUP BY
    CASE
        WHEN Price < 500 THEN 'Budget'
        WHEN Price BETWEEN 500 AND 1500 THEN 'Mid-Range'
        ELSE 'Premium'
    END;









--------------------------------------------------
-- Business Insights 12. Executive Summary Query
--------------------------------------------------

SELECT
    COUNT(*) AS TotalProducts,
    COUNT(DISTINCT Brand_Name) AS TotalBrands,
    COUNT(DISTINCT Sub_Category) AS TotalSubCategories,
    ROUND(AVG(Price),2) AvgPrice,
    MAX(Price) HighestPrice,
    MIN(Price) LowestPrice
FROM ElectronicsData;























--------------------------------------------------
-- KEY FINDINGS
--------------------------------------------------

-- 1. Dataset contains 82 brands and 23 product categories.

-- 2. Average product price is $944.21.

-- 3. Products above $2,871.24 were detected as outliers using IQR analysis.

-- 4. Correlation between Rating and Reviews is 0.10,
--    indicating a weak positive relationship.

-- 5. -- Several brands, including EFNOTE, STARLINK, Roland, and Sony, operate in the premium price segment based on average product pricing.

-- 6. Most products belong to the Budget and Mid-Range categories.

-- 7. Several brands achieved high customer ratings despite
--    receiving fewer reviews.

-- 8. Significant differences exist in pricing strategies
--    across brands and product categories.


