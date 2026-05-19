SELECT 
  SUM(CASE WHEN Region IS NULL THEN 1 ELSE 0 END) AS null_regions,
  SUM(CASE WHEN PostalCode IS NULL THEN 1 ELSE 0 END) AS null_postcodes,
  SUM(CASE WHEN Phone IS NULL THEN 1 ELSE 0 END) AS null_phones
FROM Customers;

--Cleaning Customer data ========================================

SELECT * FROM Customers

SELECT  CustomerID,
		CompanyName, 
		ContactName,
        ContactTitle,
        Address,
        City,
        COALESCE(Region, 'N/A') AS Region,
		COALESCE(PostalCode, 'N/A') AS PostalCode,
		Country
FROM Customers;

--Cleaning Employee data ========================================

SELECT	EmployeeID,
		FirstName,
		LastName,
		Title,
		CAST(BirthDate AS DATE) AS BirthDate,
		CAST(HireDate AS DATE) AS HireDate,
		Address,
		City,
		COALESCE(Region, 'N/A') AS Region,
		Country
FROM Employees

SELECT * FROM Employees

--Cleaning Orders data ========================================

SELECT	OrderID,
		CustomerID,
		EmployeeID,
		CAST(OrderDate AS DATE) AS OrderDate,
		CAST(RequiredDate AS DATE) AS RequiredDate,
		CAST(ShippedDate AS DATE) AS ShippedDate,
		ShipVia,
		Freight,
		ShipCity,
		COALESCE(ShipRegion, 'N/A') AS ShipRegion,
		ShipCountry
FROM Orders

--Cleaning Suppliers ========================================

SELECT	SupplierID,
		CompanyName,
		ContactName,
		ContactTitle,
		Address,
		City,
		COALESCE(Region, 'N/A') AS Region,
		Country,
		PostalCode
FROM Suppliers

--Creating views for the cleaned tables ========================================

CREATE VIEW CustomersClean AS
SELECT  CustomerID,
		CompanyName, 
		ContactName,
        ContactTitle,
        Address,
        City,
        COALESCE(Region, 'N/A') AS Region,
		COALESCE(PostalCode, 'N/A') AS PostalCode,
		Country
FROM Customers

CREATE VIEW EmployeesClean AS
SELECT	EmployeeID,
		FirstName,
		LastName,
		Title,
		CAST(BirthDate AS DATE) AS BirthDate,
		CAST(HireDate AS DATE) AS HireDate,
		Address,
		City,
		COALESCE(Region, 'N/A') AS Region,
		Country
FROM Employees

CREATE VIEW OrdersClean AS 
SELECT	OrderID,
		CustomerID,
		EmployeeID,
		CAST(OrderDate AS DATE) AS OrderDate,
		CAST(RequiredDate AS DATE) AS RequiredDate,
		CAST(ShippedDate AS DATE) AS ShippedDate,
		ShipVia,
		Freight,
		ShipCity,
		COALESCE(ShipRegion, 'N/A') AS ShipRegion,
		ShipCountry
FROM Orders

CREATE VIEW SuppliersClean AS 
SELECT	SupplierID,
		CompanyName,
		ContactName,
		ContactTitle,
		Address,
		City,
		COALESCE(Region, 'N/A') AS Region,
		Country,
		PostalCode
FROM Suppliers

SELECT * FROM CustomersClean
SELECT * FROM EmployeesClean
SELECT * FROM OrdersClean
SELECT * FROM SuppliersClean

SELECT * FROM [Order Details]
SELECT * FROM OrdersClean
SELECT * FROM Products
SELECT * FROM EmployeesClean
SELECT * FROM CustomersClean

--Joining tables to create a Master Orders table ========================================

CREATE VIEW MasterOrders AS
SELECT	oc.OrderID,
		cc.CompanyName,
		ec.FirstName + ' ' + ec.LastName AS EmployeeName,
		p.ProductName,
		od.Quantity,
		od.UnitPrice,
		od.Discount,
		oc.ShipCountry
FROM OrdersClean oc
JOIN [Order Details] od ON oc.OrderID = od.OrderID
JOIN CustomersClean cc ON oc.CustomerID = cc.CustomerID
JOIN EmployeesClean ec ON oc.EmployeeID = ec.EmployeeID
JOIN Products p ON od.ProductID = p.ProductID

--Calculating total revenue per customer ========================================

SELECT	CompanyName,
		ROUND(SUM(UnitPrice * Quantity * (1 - Discount)), 2) AS TotalRevenue
FROM MasterOrders
GROUP BY CompanyName
ORDER BY TotalRevenue DESC

--Calculating revenue per country ========================================

SELECT	ShipCountry,
		ROUND(SUM(UnitPrice * Quantity * (1 - Discount)), 2) AS TotalRevenue
FROM MasterOrders
GROUP BY ShipCountry
ORDER BY TotalRevenue DESC

--Calculating revenue lost to discounts ========================================

SELECT	OrderID,
		CompanyName,
		ROUND(SUM(UnitPrice * Quantity), 2) AS FullRevenue,
		ROUND(SUM(UnitPrice * Quantity * (1 - Discount)), 2) AS ActualRevenue,
		ROUND(SUM(UnitPrice * Quantity * Discount), 2) AS RevenueLost
FROM MasterOrders
WHERE Discount > 0
GROUP BY OrderID, CompanyName
ORDER BY RevenueLost DESC

--Calculating best selling products by quantity ========================================

SELECT ProductName, SUM(Quantity) AS TotalQuantityOrdered
FROM MasterOrders
GROUP BY ProductName
ORDER BY TotalQuantityOrdered DESC

--Calculating best selling products by revenue ========================================

SELECT ProductName, SUM(Quantity * UnitPrice * (1 - Discount)) AS TotalRevenue
FROM MasterOrders
GROUP BY ProductName
ORDER BY TotalRevenue DESC

--Analyzing which employee generates the most revenue ========================================

SELECT	EmployeeName, 
		ROUND(SUM(Quantity * UnitPrice * (1 - Discount)), 2) AS TotalRevenue
FROM MasterOrders
GROUP BY EmployeeName
ORDER BY TotalRevenue DESC

--Analyzing which employee processes the most orders ========================================

SELECT	EmployeeName,
		COUNT(DISTINCT OrderID) AS TotalOrders
FROM MasterOrders
GROUP BY EmployeeName
ORDER BY TotalOrders DESC
--margaret deserves a promotion lol

--Analyzing which countries order the most ========================================

SELECT	ShipCountry,
		COUNT(DISTINCT OrderID) AS TotalOrders
FROM MasterOrders
GROUP BY ShipCountry
ORDER BY TotalOrders DESC

--Calculating AVG no. of products per order ========================================

WITH ProductsPerOrder AS (
    SELECT 
        OrderID,
        COUNT(ProductName) AS ProductCount
    FROM MasterOrders
    GROUP BY OrderID
)
SELECT AVG(ProductCount) AS AvgProductsPerOrder
FROM ProductsPerOrder

--Calculating month over month revenue change ========================================

ALTER VIEW MasterOrders AS
SELECT	oc.OrderID,
		oc.OrderDate, --added this
		cc.CompanyName,
		ec.FirstName + ' ' + ec.LastName AS EmployeeName,
		p.ProductName,
		od.Quantity,
		od.UnitPrice,
		od.Discount,
		oc.ShipCountry
FROM OrdersClean oc
JOIN [Order Details] od ON oc.OrderID = od.OrderID
JOIN CustomersClean cc ON oc.CustomerID = cc.CustomerID
JOIN EmployeesClean ec ON oc.EmployeeID = ec.EmployeeID
JOIN Products p ON od.ProductID = p.ProductID

WITH MonthlyRevenue AS (
SELECT	FORMAT(OrderDate, 'yyyy-MM') AS OrderMonth,
		ROUND(SUM(UnitPrice * Quantity * (1 - Discount)), 2) AS Revenue
FROM MasterOrders
GROUP BY FORMAT(OrderDate, 'yyyy-MM')
)
SELECT	OrderMonth,
		Revenue,
		LAG(Revenue) OVER (ORDER BY OrderMonth) AS PrevMonthRevenue,
		ROUND(Revenue - LAG(Revenue) OVER (ORDER BY OrderMonth), 2) AS MoMChange
FROM MonthlyRevenue
ORDER BY OrderMonth