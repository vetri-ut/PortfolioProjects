SELECT I.ProductKey,
       C.EnglishProductCategoryName,
       S.EnglishProductSubcategoryName,
       P.EnglishProductName,
       SUM(I.OrderQuantity) AS TotalQuantity
FROM [dbo].[DimProduct] AS P
    join [dbo].[DimProductSubcategory] AS S
        ON S.ProductSubcategoryKey = P.ProductSubcategoryKey
    join [dbo].[DimProductCategory] as C
        ON C.ProductCategoryKey = S.ProductCategoryKey
    join FactInternetSales I
        ON I.ProductKey = P.ProductKey
GROUP BY I.ProductKey,
         C.EnglishProductCategoryName,
         C.ProductCategoryKey,
         P.ProductSubcategoryKey,
         P.EnglishProductName,
         S.EnglishProductSubcategoryName
order by C.EnglishProductCategoryName,
         I.ProductKey




