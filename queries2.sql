create database customer_profiling;
use customer_profiling;

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(50),
    Gender VARCHAR(10),
    Age INT,
    City VARCHAR(50),
    State VARCHAR(50)
);

CREATE TABLE Transactions (
    TransactionID INT PRIMARY KEY,
    CustomerID INT,
    TransactionDate DATE,
    Amount DECIMAL(10, 2),
    Product VARCHAR(100),
    Category VARCHAR(50)
);


INSERT INTO Customers VALUES
(101, 'Michael', 'Williams', 'michael@example.com', 'Male', 25, 'Chicago', 'IL'),
(102, 'Emily', 'Davis', 'emily@example.com', 'Female', 35, 'Houston', 'TX'),
(103, 'David', 'Miller', 'david@example.com', 'Male', 28, 'Miami', 'FL'),
(104, 'Sarah', 'Brown', 'sarah@example.com', 'Female', 22, 'San Francisco', 'CA'),
(105, 'Daniel', 'Jones', 'daniel@example.com', 'Male', 40, 'Seattle', 'WA'),
(106, 'Olivia', 'Martinez', 'olivia@example.com', 'Female', 29, 'Boston', 'MA'),
(107, 'James', 'Taylor', 'james@example.com', 'Male', 31, 'Denver', 'CO'),
(108, 'Sophia', 'Anderson', 'sophia@example.com', 'Female', 27, 'Dallas', 'TX'),
(109, 'Ethan', 'Johnson', 'ethan@example.com', 'Male', 23, 'Phoenix', 'AZ'),
(110, 'Ava', 'Brown', 'ava@example.com', 'Female', 26, 'Atlanta', 'GA'),
(111, 'Liam', 'Wilson', 'liam@example.com', 'Male', 33, 'Chicago', 'IL'),
(112, 'Emma', 'Garcia', 'emma@example.com', 'Female', 31, 'Miami', 'FL'),
(113, 'Noah', 'Lee', 'noah@example.com', 'Male', 29, 'Los Angeles', 'CA'),
(114, 'Olivia', 'Smith', 'olivia@example.com', 'Female', 28, 'New York', 'NY'),
(115, 'William', 'Davis', 'william@example.com', 'Male', 27, 'Houston', 'TX');


INSERT INTO Transactions VALUES
(201, 3,  '2023-03-10',  90.00, 'Headphones',  'Electronics'),
(202, 4,  '2023-04-05', 120.00, 'Dress',       'Fashion'),
(203, 5,  '2023-05-15',  50.00, 'Books',       'Education'),
(204, 6,  '2023-06-20',  35.00, 'Sunglasses',  'Fashion'),
(205, 7,  '2023-07-08', 180.00, 'Laptop',      'Electronics'),
(206, 8,  '2023-08-12',  65.00, 'Jeans',       'Fashion'),
(207, 9,  '2023-09-25', 110.00, 'Smartwatch',  'Electronics'),
(208, 10, '2023-10-30',  70.00, 'T-shirt',     'Fashion'),
(209, 11, '2023-11-12',  25.00, 'Notebooks',   'Education'),
(210, 12, '2023-12-18',  40.00, 'Sneakers',    'Fashion'),
(211, 13, '2024-01-05',  60.00, 'Camera',      'Electronics'),
(212, 14, '2024-02-20',  80.00, 'Jacket',      'Fashion'),
(213, 15, '2024-03-15',  70.00, 'Tablet',      'Electronics');

INSERT INTO Transactions
(TransactionID, CustomerID, TransactionDate, Amount, Product, Category)
VALUES
(301, 101, '2023-03-10', 90.00, 'Headphones', 'Electronics'),
(302, 102, '2023-04-05', 120.00, 'Dress', 'Fashion'),
(303, 103, '2023-05-15', 50.00, 'Books', 'Education'),
(304, 104, '2023-06-20', 35.00, 'Sunglasses', 'Fashion'),
(305, 105, '2023-07-08', 180.00, 'Laptop', 'Electronics'),
(306, 106, '2023-08-12', 65.00, 'Jeans', 'Fashion'),
(307, 107, '2023-09-25', 110.00, 'Smartwatch', 'Electronics'),
(308, 108, '2023-10-30', 70.00, 'T-shirt', 'Fashion'),
(309, 109, '2023-11-12', 25.00, 'Notebook', 'Education'),
(310, 110, '2023-12-18', 40.00, 'Sneakers', 'Fashion'),
(311, 111, '2024-01-05', 60.00, 'Camera', 'Electronics'),
(312, 112, '2024-02-20', 80.00, 'Jacket', 'Fashion'),
(313, 113, '2024-03-15', 70.00, 'Tablet', 'Electronics');



-- This groups customers into Young, Middle-aged, Senior and counts them.

SELECT
    CASE
        WHEN Age < 25 THEN 'Young'
        WHEN Age BETWEEN 24 AND 40 THEN 'Middle-aged'
        ELSE 'Senior'
    END AS AgeSegment,
    COUNT(*) AS CustomerCount
FROM Customers
GROUP BY AgeSegment;


-- This shows average spending and number of transactions for each age.

SELECT
    Customers.Age,
    AVG(Transactions.Amount) AS AverageTransactionAmount,
    COUNT(*) AS TransactionCount
FROM Customers
JOIN Transactions
    ON Customers.CustomerID = Transactions.CustomerID
GROUP BY Customers.Age;


-- Customer Profiling + Export to CSV
-- Groups customers by age segment
-- Calculates average transaction amount
-- Counts transactions
-- Exports result to a CSV file


SELECT
    CASE
        WHEN Age < 25 THEN 'Young'
        WHEN Age BETWEEN 24 AND 40 THEN 'Middle-aged'
        ELSE 'Senior'
    END AS AgeSegment,

    AVG(Amount) AS AverageTransactionAmount,
    COUNT(*) AS TransactionCount

INTO OUTFILE
'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Customer_Profilings.csv'

FROM Customers
JOIN Transactions
    ON Customers.CustomerID = Transactions.CustomerID

GROUP BY
    CASE
        WHEN Age < 25 THEN 'Young'
        WHEN Age BETWEEN 24 AND 40 THEN 'Middle-aged'
        ELSE 'Senior'
    END;


-- Segmentation by Spending (High / Medium / Low)

SELECT
    Customers.CustomerID,

    CASE
        WHEN SUM(Transactions.Amount) > 200 THEN 'High Spender'
        WHEN SUM(Transactions.Amount) BETWEEN 100 AND 200 THEN 'Medium Spender'
        ELSE 'Low Spender'
    END AS SpendingCategory,

    SUM(Transactions.Amount) AS TotalSpending

FROM Customers
JOIN Transactions
ON Customers.CustomerID = Transactions.CustomerID
GROUP BY Customers.CustomerID;

-- Segmentation by Purchase Frequency (Regular / Occasional)
-- Identify loyal customers
-- Offer rewards
SELECT
    Customers.CustomerID,

    CASE
        WHEN COUNT(Transactions.TransactionID) >= 3 THEN 'Regular'
        ELSE 'Occasional'
    END AS CustomerType,

    COUNT(*) AS TotalOrders

FROM Customers
JOIN Transactions
ON Customers.CustomerID = Transactions.CustomerID

GROUP BY Customers.CustomerID;


-- Location-Based Segmentation (City/State)
-- Which city gives more revenue
-- Where to expand business

SELECT
    City,
    COUNT(*) AS TotalCustomers,
    AVG(Amount) AS AvgSpending

FROM Customers
JOIN Transactions
ON Customers.CustomerID = Transactions.CustomerID

GROUP BY City;


-- Product Preference Profiling
-- Understand buying behavior
-- Improve marketing

SELECT
    Customers.Age,
    Transactions.Product,
    COUNT(*) AS PurchaseCount

FROM Customers
JOIN Transactions
ON Customers.CustomerID = Transactions.CustomerID

GROUP BY Customers.Age, Transactions.Product

ORDER BY PurchaseCount DESC;

-- RFM Analysis
-- RFM = Recency, Frequency, Monetary

SELECT
    CustomerID,
    MAX(TransactionDate) AS LastPurchase,
    COUNT(*) AS Frequency,
    SUM(Amount) AS MonetaryValue

FROM Transactions

GROUP BY CustomerID;


-- Combine Age + Spending
-- Step 1

-- For every customer:

-- Find age group
-- Find total spending
-- Label as High/Normal

-- Step 2

-- After that:

-- Count how many customers are in each category

SELECT 
    AgeGroup,
    SpendingType,
    COUNT(*) AS CustomerCount
FROM
(
    SELECT 
        Customers.CustomerID,

        CASE 
            WHEN Age < 25 THEN 'Young'
            WHEN Age BETWEEN 25 AND 40 THEN 'Middle-aged'
            ELSE 'Senior'
        END AS AgeGroup,

        CASE 
            WHEN SUM(Transactions.Amount) > 200 THEN 'High Spender'
            ELSE 'Normal'
        END AS SpendingType

    FROM Customers
    JOIN Transactions
        ON Customers.CustomerID = Transactions.CustomerID

    GROUP BY Customers.CustomerID, Age
) AS t

GROUP BY AgeGroup, SpendingType;





