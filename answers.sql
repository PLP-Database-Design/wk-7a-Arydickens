-- Question 1 Achieving 1NF (First Normal Form) 🛠️
SELECT OrderID,
    CustomerName,
    TRIM(product) AS Product
FROM (
        SELECT OrderID,
            CustomerName,
            JSON_TABLE(
                CONCAT('[', REPLACE(Products, ',', '","'), ']'),
                '$[*]' COLUMNS (product VARCHAR(100) PATH '$')
            ) AS jt
        FROM ProductDetail
    ) AS sub;
-- Question 2 Achieving 2NF (Second Normal Form) 🛠️
-- Step 1: Create the Orders table
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100)
);
-- Insert distinct OrderID–CustomerName pairs
INSERT INTO Orders (OrderID, CustomerName)
SELECT DISTINCT OrderID,
    CustomerName
FROM OrderDetails;
-- Step 2: Create the OrderItems table
CREATE TABLE OrderItems (
    OrderID INT,
    Product VARCHAR(100),
    Quantity INT,
    PRIMARY KEY (OrderID, Product),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);
-- Insert product-level order details
INSERT INTO OrderItems (OrderID, Product, Quantity)
SELECT OrderID,
    Product,
    Quantity
FROM OrderDetails;