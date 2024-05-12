SELECT 
    Year,
    Month,
    SalesType,
	EnglishCountryRegionName,
	City,
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
		G.EnglishCountryRegionName,
	    G.City,
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
	JOIN
         DimGeography AS G ON I.SalesTerritoryKey = G.SalesTerritoryKey
    GROUP BY 
        I.ProductKey,
        C.EnglishProductCategoryName,
        C.ProductCategoryKey,
        P.ProductSubcategoryKey,
        P.EnglishProductName,
        S.EnglishProductSubcategoryName,
        D.CalendarYear,
        D.EnglishMonthName,
		G.EnglishCountryRegionName,
	    G.City
         
    UNION ALL
    
    SELECT 
        R.ProductKey,
        D.CalendarYear AS Year,
        D.EnglishMonthName AS Month,
        'ResellerSales' AS SalesType,
		G.EnglishCountryRegionName,
	    G.City,
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
	JOIN
         DimGeography AS G ON R.SalesTerritoryKey = G.SalesTerritoryKey
    GROUP BY 
        R.ProductKey,
        C.EnglishProductCategoryName,
        C.ProductCategoryKey,
        P.ProductSubcategoryKey,
        P.EnglishProductName,
        S.EnglishProductSubcategoryName,
        D.CalendarYear,
        D.EnglishMonthName,
		G.EnglishCountryRegionName,
	    G.City
) AS Total_sales



