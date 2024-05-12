SELECT 
    Year,
    Month,
    SalesType,
    EnglishProductCategoryName,
    EnglishProductSubcategoryName,
    EnglishProductName,
    TotalQuantity,
    TotalCost,
    TotalSales,
    TotalSales - TotalCost AS Profit
FROM
(
    SELECT 
        I.ProductKey,
        D.CalendarYear AS Year,
        D.EnglishMonthName AS Month,
        'InternetSales' AS SalesType,
        C.EnglishProductCategoryName,
        S.EnglishProductSubcategoryName,
        P.EnglishProductName,
        SUM(I.OrderQuantity) AS TotalQuantity,
        ROUND(SUM(I.TotalProductCost), 2) AS TotalCost,
        ROUND(SUM(I.SalesAmount), 2) AS TotalSales	   
    FROM 
        [dbo].[DimProduct] AS P
    JOIN 
        [dbo].[DimProductSubcategory] AS S ON S.ProductSubcategoryKey = P.ProductSubcategoryKey
    JOIN 
        [dbo].[DimProductCategory] AS C ON C.ProductCategoryKey = S.ProductCategoryKey
    JOIN 
        FactInternetSales I ON I.ProductKey = P.ProductKey
    JOIN 
        [dbo].[DimDate] D ON D.DateKey = I.OrderDateKey
    GROUP BY 
        I.ProductKey,
        C.EnglishProductCategoryName,
        C.ProductCategoryKey,
        P.ProductSubcategoryKey,
        P.EnglishProductName,
        S.EnglishProductSubcategoryName,
        D.CalendarYear,
        D.EnglishMonthName
         
    UNION ALL
    
    SELECT 
        R.ProductKey,
        D.CalendarYear AS Year,
        D.EnglishMonthName AS Month,
        'ResellerSales' AS SalesType,
        C.EnglishProductCategoryName,
        S.EnglishProductSubcategoryName,
        P.EnglishProductName,
        SUM(R.OrderQuantity) AS TotalQuantity,
        ROUND(SUM(R.TotalProductCost), 2) AS TotalCost,
        ROUND(SUM(R.SalesAmount), 2) AS TotalSales
    FROM 
        [dbo].[DimProduct] AS P
    JOIN 
        [dbo].[DimProductSubcategory] AS S ON S.ProductSubcategoryKey = P.ProductSubcategoryKey
    JOIN 
        [dbo].[DimProductCategory] AS C ON C.ProductCategoryKey = S.ProductCategoryKey
    JOIN 
        [dbo].[FactResellerSales] R ON R.ProductKey = P.ProductKey
    JOIN 
        [dbo].[DimDate] D ON D.DateKey = R.OrderDateKey
    GROUP BY 
        R.ProductKey,
        C.EnglishProductCategoryName,
        C.ProductCategoryKey,
        P.ProductSubcategoryKey,
        P.EnglishProductName,
        S.EnglishProductSubcategoryName,
        D.CalendarYear,
        D.EnglishMonthName
) AS Total_sales
ORDER BY 
    SalesType,Year,
    CASE 
        WHEN Month = 'January' THEN 1
        WHEN Month = 'February' THEN 2
        WHEN Month = 'March' THEN 3
        WHEN Month = 'April' THEN 4
        WHEN Month = 'May' THEN 5
        WHEN Month = 'June' THEN 6
        WHEN Month = 'July' THEN 7
        WHEN Month = 'August' THEN 8
        WHEN Month = 'September' THEN 9
        WHEN Month = 'October' THEN 10
        WHEN Month = 'November' THEN 11
        WHEN Month = 'December' THEN 12
    END,
    EnglishProductCategoryName,
    EnglishProductSubcategoryName;