-- Data Handling

-- Impute mean for the following columns, and round off to the nearest integer if required: WarehouseToHome, HourSpendOnApp, OrderAmountHikeFromlastYear, DaySinceLastOrder.

SELECT round(avg(warehousetohome)) FROM customer_churn;

SET sql_safe_updates=0;
UPDATE customer_churn
SET WarehouseToHome = 16
WHERE WarehouseToHome IS NULL;

SELECT round(avg(HourSpendOnApp)) FROM customer_churn;

UPDATE customer_churn
SET HourSpendOnApp= 3
WHERE HourSpendOnApp IS NULL;

SELECT round(avg(OrderAmountHikeFromlastYear)) FROM customer_churn;

UPDATE customer_churn
SET OrderAmountHikeFromlastYear= 16
WHERE OrderAmountHikeFromlastYear IS NULL;

SELECT round(avg(DaySinceLastOrder)) FROM customer_churn;

UPDATE customer_churn
SET DaySinceLastOrder= 5
WHERE DaySinceLastOrder IS NULL;

SELECT * FROM customer_churn;

-- Impute mode for the following columns: Tenure, CouponUsed, OrderCount.
-- To find the mode

 SELECT Tenure, COUNT(*) AS Frequency
FROM customer_churn
WHERE Tenure IS NOT NULL
GROUP BY Tenure
ORDER BY Frequency DESC
LIMIT 1;

UPDATE customer_churn
SET Tenure = 1
WHERE Tenure IS NULL;

SELECT CouponUsed, COUNT(*) AS Frequency
FROM customer_churn
WHERE CouponUsed IS NOT NULL
GROUP BY CouponUsed
ORDER BY Frequency DESC
LIMIT 1;

UPDATE customer_churn
SET CouponUsed = 1
WHERE CouponUsed IS NULL;

SELECT OrderCount, COUNT(*) AS Frequency
FROM customer_churn
WHERE OrderCount IS NOT NULL
GROUP BY OrderCount
ORDER BY OrderCount DESC
LIMIT 1;

UPDATE customer_churn
SET OrderCount = 16
WHERE OrderCount IS NULL;

SELECT * FROM Customer_churn;

-- Handle outliers in the 'WarehouseToHome' column by deleting rows where the values are greater than 100.
SELECT *
FROM Customer_churn
WHERE warehousetoHome > 100;

DELETE FROM customer_churn
WHERE WarehouseToHome > 100;

SELECT * FROM Customer_churn;

-- Replace occurrences of “Phone” in the 'PreferredLoginDevice' column and “Mobile” in the 'PreferedOrderCat' column with “Mobile Phone” to ensure uniformity.

UPDATE customer_churn
SET PreferredLoginDevice = 'Mobile Phone'
WHERE PreferredLoginDevice = 'Phone';

UPDATE customer_churn
SET PreferedOrderCat = 'Mobile Phone'
WHERE PreferedOrderCat = 'Mobile';

SELECT * FROM Customer_churn;

-- Standardize payment mode values: Replace "COD" with "Cash on Delivery" and "CC" with "Credit Card" in the PreferredPaymentMode column.

UPDATE customer_churn
SET PreferredPaymentMode = 'Cash on Delivery'
WHERE PreferredPaymentMode = 'COD';

UPDATE customer_churn
SET PreferredPaymentMode = 'Credit Card'
WHERE PreferredPaymentMode = 'CC';

SELECT * FROM Customer_churn;

-- Data Transformation 

-- Rename the column "PreferedOrderCat" to "PreferredOrderCat".

ALTER TABLE customer_churn
RENAME COLUMN PreferedOrderCat TO PreferredOrderCat;

DESCRIBE customer_churn;

-- Rename the column "HourSpendOnApp" to "HoursSpentOnApp".

ALTER TABLE customer_churn
RENAME COLUMN HourSpendOnApp TO HoursSpentOnApp;

DESCRIBE customer_churn;

-- Create a new column named ‘ComplaintReceived’ with values "Yes" if the corresponding value in the ‘Complain’ is 1, and "No" otherwise.

ALTER TABLE customer_churn
ADD COLUMN ComplaintReceived VARCHAR(3);

UPDATE customer_churn
SET ComplaintReceived =
    CASE
        WHEN Complain = 1 THEN 'Yes'
        ELSE 'No'
    END;
    
-- Create a new column named 'ChurnStatus'. Set its value to “Churned” if the corresponding value in the 'Churn' column is 1, else assign “Active”.

ALTER TABLE customer_churn
ADD COLUMN ChurnStatus VARCHAR(7);

UPDATE customer_churn
SET ChurnStatus =
    CASE
        WHEN Churn = 1 THEN 'Churned'
        ELSE 'Active'
    END;
    
DESCRIBE customer_churn;

-- Drop the columns "Churn" and "Complain" from the table.

ALTER TABLE customer_churn
DROP COLUMN churn;
ALTER TABLE customer_churn
DROP COLUMN Complain;

DESCRIBE customer_churn;

    
-- Data Exploration and Analysis

-- Retrieve the count of churned and active customers from the dataset.

SELECT
    ChurnStatus,
    COUNT(*) AS CustomerCount
FROM customer_churn
GROUP BY ChurnStatus;

-- Display the average tenure and total cashback amount of customers who churned.

SELECT
    AVG(Tenure) AS AverageTenure,
    SUM(CashbackAmount) AS TotalCashback
FROM customer_churn
WHERE ChurnStatus = 'Churned';

-- Determine the percentage of churned customers who complained.
SELECT
    ROUND(
        SUM(ComplaintReceived = 'Yes') * 100.0 / COUNT(*),2) AS ComplaintPercentage
FROM customer_churn
WHERE ChurnStatus = 'Churned';

-- Identify the city tier with the highest number of churned customers whose preferred order category is Laptop & Accessory.

SELECT
    CityTier,
    COUNT(*) AS ChurnedCustomerCount
FROM customer_churn
WHERE ChurnStatus = 'Churned'
  AND PreferredOrderCat = 'Laptop & Accessory'
GROUP BY CityTier
ORDER BY ChurnedCustomerCount DESC
LIMIT 1;

-- Identify the most preferred payment mode among active customers.

SELECT
    PreferredPaymentMode,
    COUNT(*) AS CustomerCount
FROM customer_churn
WHERE ChurnStatus = 'Active'
GROUP BY PreferredPaymentMode
ORDER BY CustomerCount DESC
LIMIT 1;

-- Calculate the total order amount hike from last year for customers who are single and prefer mobile phones for ordering.

SELECT
    SUM(OrderAmountHikeFromlastYear) AS TotalOrderAmountHike
FROM customer_churn
WHERE MaritalStatus = 'Single'
  AND PreferredLoginDevice = 'Mobile Phone';
  
--  Find the average number of devices registered among customers who used UPI as their preferred payment mode.

SELECT round(Avg(NumberOfDeviceRegistered)) AS AverageNumOfDevices
FROM customer_churn
WHERE PreferredPaymentMode = 'UPI';

-- Determine the city tier with the highest number of customers.

SELECT cityTier, count(*) AS HighestNumCustomers
FROM customer_churn
GROUP BY CityTier
ORDER BY HighestNumCustomers DESC
LIMIT 1;

-- Identify the gender that utilized the highest number of coupons.

SELECT Gender,
    SUM(CouponUsed) AS TotalCouponsUsed
FROM customer_churn
GROUP BY Gender
ORDER BY TotalCouponsUsed DESC
LIMIT 1;

-- List the number of customers and the maximum hours spent on the app in each preferred order category.

SELECT
    PreferredOrderCat,
    COUNT(*) AS CustomerCount,
    MAX(HoursSpentOnApp) AS MaximumHoursSpent
FROM customer_churn
GROUP BY PreferredOrderCat;

-- Calculate the total order count for customers who prefer using credit cards and have the maximum satisfaction score.

SELECT
    SUM(OrderCount) AS TotalOrderCount
FROM customer_churn
WHERE PreferredPaymentMode = 'Credit Card'
  AND SatisfactionScore = (
      SELECT MAX(SatisfactionScore)
      FROM customer_churn
  );
  
-- What is the average satisfaction score of customers who have complained?

SELECT
    AVG(SatisfactionScore) AS AverageSatisfactionScore
FROM customer_churn
WHERE ComplaintReceived = 'Yes';

-- List the preferred order category among customers who used more than 5 coupons.

SELECT DISTINCT PreferredOrderCat FROM customer_churn
WHERE CouponUsed > 5;

SELECT PreferredOrderCat, COUNT(*) AS CustomerCount
FROM customer_churn
WHERE CouponUsed > 5
GROUP BY PreferredOrderCat;

-- List the top 3 preferred order categories with the highest average cashback amount.

SELECT
    PreferredOrderCat,
    ROUND(AVG(CashbackAmount)) AS AverageCashback
FROM customer_churn
GROUP BY PreferredOrderCat
ORDER BY AverageCashback DESC
LIMIT 3;

-- Find the preferred payment modes of customers whose average tenure is 10 months and have placed more than 500 orders.

SELECT
    PreferredPaymentMode,
    AVG(Tenure) AS AverageTenure,
    SUM(OrderCount) AS TotalOrders
FROM customer_churn
GROUP BY PreferredPaymentMode
HAVING AVG(Tenure) = 10
   AND SUM(OrderCount) > 500;
   
-- Categorize customers based on their distance from the warehouse to home such as 'Very Close Distance' for distances <=5km, 'Close Distance' for <=10km, 'Moderate Distance' for <=15km, and 'Far Distance' for >15km. Then, display the churn status breakdown for each distance category

SELECT
    CASE
        WHEN WarehouseToHome <= 5 THEN 'Very Close Distance'
        WHEN WarehouseToHome <= 10 THEN 'Close Distance'
        WHEN WarehouseToHome <= 15 THEN 'Moderate Distance'
        ELSE 'Far Distance'
    END AS DistanceCategory,
    ChurnStatus,
    COUNT(*) AS CustomerCount
FROM customer_churn
GROUP BY DistanceCategory, ChurnStatus
ORDER BY churnStatus;

-- List the customer’s order details who are married, live in City Tier-1, and their order counts are more than the average number of orders placed by all customers.

SELECT * FROM customer_churn
WHERE maritalStatus = "married" 
AND citytier =1
AND ordercount > (Select avg(ordercount) from customer_churn);

-- Create a ‘customer_returns’ table in the ‘ecomm’ database and insert the following data:

CREATE TABLE Customer_returns 
(returnid INT PRIMARY KEY,
Customerid INT NOT NULL,
returnDate DATE,
Refundamount DECIMAL(10,2));

INSERT INTO customer_returns
VALUES
(1001, 50022, '2023-01-01', 2130),
(1002, 50316, '2023-01-23', 2000),
(1003, 51099, '2023-02-14', 2290),
(1004, 52321, '2023-03-08', 2510),
(1005, 52928, '2023-03-20', 3000),
(1006, 53749, '2023-04-17', 1740),
(1007, 54206, '2023-04-21', 3250),
(1008, 54838, '2023-04-30', 1990);

SELECT * FROM Customer_returns;

-- Display the return details along with the customer details of those who have churned and have made complaints.
SELECT
    cr.*, cc.*
FROM customer_returns cr
INNER JOIN customer_churn cc
    ON cr.CustomerID = cc.CustomerID
WHERE cc.ChurnStatus = 'Churned'
  AND cc.ComplaintReceived = 'Yes';
