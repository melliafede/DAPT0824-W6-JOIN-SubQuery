use AdventureWorksDW;

show tables;

select * from dimproduct;

select * from dimproductsubcategory;

-- 1. Anagrafica dei prodotti indicando per ciascun prodotto anche la sua sotto-categoria
select p.ProductKey, p.EnglishProductName, s.EnglishProductSubcategoryName
from dimproduct as p
left join dimproductsubcategory as s
on p.ProductSubcategoryKey = s.ProductSubcategoryKey;

select * from dimproductcategory;

-- 2. Anagrafica prodotti indicando per ciascun prodotto la sua sotto-categoria e la sua categoria
select p.ProductKey, p.EnglishProductName, c.EnglishProductCategoryName ,s.EnglishProductSubcategoryName
from dimproduct as p
left join dimproductsubcategory as s
on p.ProductSubcategoryKey = s.ProductSubcategoryKey
left join dimproductcategory as c
on s.ProductcategoryKey = c.ProductCategoryKey;

-- 3. Elenco dei soli prodotti venduti
select ProductKey, EnglishProductName, StandardCost, Color, ListPrice, Size, FinishedGoodsFlag
from dimproduct
where ProductKey in (select ProductKey from factresellersales);

-- 4. Elenco dei prodotti non venduti (considera i soli prodotti finiti)
select ProductKey, EnglishProductName, StandardCost, Color, ListPrice, Size, FinishedGoodsFlag
from dimproduct
where FinishedGoodsFlag = 1 and ProductKey not in (select ProductKey from factresellersales);

describe factresellersales;

-- 5. Elenco delle transazioni di vendita indicando anche il nome del prodotto
SELECT s.SalesOrderNumber, s.OrderDate, s.ProductKey, p.EnglishProductName, s.OrderQuantity, s.UnitPrice, s.TotalProductCost
from factresellersales as s
INNER JOin dimproduct as p
on s.ProductKey = p.ProductKey;

-- Esponi l'elenco delle transazioni di vendita indicando la cateoria di appartenenza di ciascun prodotto venduto
SELECT s.SalesOrderNumber, s.OrderDate, s.ProductKey, p.EnglishProductName, cat.EnglishProductCategoryName, s.OrderQuantity, s.UnitPrice, s.TotalProductCost
FROM factresellersales as s
INNER join dimproduct as p
on s.ProductKey = p.ProductKey
left join dimproductsubcategory as sub
on p.ProductSubcategoryKey = sub.ProductSubcategoryKey
left join dimproductcategory as cat
on sub.ProductCategoryKey = cat.ProductCategoryKey;

-- Anagrafica prodotto venduto come ultima transazione
Select dimproduct.ProductKey, dimproduct.EnglishProductName, factresellersales.orderdate
from dimproduct inner join factresellersales on dimproduct.ProductKey = factresellersales.ProductKey
where factresellersales.OrderDate = (select max(factresellersales.orderdate) from factresellersales)
order by dimproduct.ProductKey;

SELECT orderdate from factresellersales order by orderDate DESC;