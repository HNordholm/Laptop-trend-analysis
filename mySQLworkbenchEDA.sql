
#Welcome to this exploratory data analysis part using mySQL Workbench.

#Here I will perform a number of queries to get a better insight into the data. 
#After each query, I will provide a short summary of the result.

SELECT company, ROUND(AVG(priceUSD),2) AS avarageprice FROM ltclean2
GROUP BY company
ORDER BY avarageprice DESC; 

SELECT company, ROUND(AVG(priceUSD),2) AS avarageprice FROM ltclean2
GROUP BY company
ORDER BY avarageprice ASC; 

# On avarage, Razer has the most expensive laptops with avarage price of 2139USD followed by
# LG (1342USD) and MSI(1101USD). Vero(139USD),Mediacom(188USD) and Chuwi(200USD) has the cheapest laptops. 

SELECT typename,ROUND(AVG(priceUSD),2) AS avarageprice FROM ltclean2
GROUP BY typename 
ORDER BY avarageprice DESC; 

#On avarage, laptops of type workstation(1455USD) is most expensive followed by gaming laptops(1106USD). 
#Cheapest types is netbooks(444USD) followed by notebooks(503USD). 


SELECT ips_panel, ROUND(AVG(priceUSD),2) AS avarageprice
FROM ltclean2
GROUP BY ips_panel;

#Laptops with feature IPS-panel is on avarage 253USD more expensive then 
#laptops without IPS-panel. 
#Hypothesis testing will be performed in R to validate significant difference. 

SELECT touchscreen, ROUND(AVG(priceUSD),2) AS avarageprice
FROM ltclean2
GROUP BY touchscreen;

#Laptops with touchscreen is on avarage avarage 239USD more expensive then 
#laptops without touchscreen. 
#Hypothesis testing will be performed in R to validate significant difference. 


SELECT memory,ROUND(AVG(priceUSD),2) AS avarageprice
FROM ltclean2
GROUP BY memory
ORDER BY avarageprice DESC; 

#On avarage, memorys with 1TB SSD + 1TB HDD is most expensive(2317USD) followed by 512GB SSD + 1TB hybrid(2071USD).'
#Cheapest are memorys with 16GB SSD(143USD), 32GB SSD(182USD) is more expensive then 32GBHHD(169USD).

SELECT resolution_category, ROUND(AVG(priceUSD),2) AS avarageprice
FROM ltclean2
GROUP BY resolution_category
ORDER BY avarageprice DESC; 

#QuadHD most expensive, followed by fullHD and no-HD. 

SELECT screenresolution, COUNT(*) AS total_laptops
FROM ltclean2
GROUP BY screenresolution
ORDER BY total_laptops DESC;

#Screenresolutions with full HD 1920x1080 are preferred by the market, with a total of 492 laptops within this sample. 

SELECT resolution_category, COUNT(*) AS total_laptops
FROM ltclean2
GROUP BY resolution_category
ORDER BY total_laptops DESC;

#FullHD laptops most common, followed by laptops with noHD and quadHD. 

SELECT opsys, COUNT(*) AS total_laptops
FROM ltclean2
GROUP BY opsys
ORDER BY total_laptops DESC;

#Windows 10 is by far the most popular operating system, in second place are laptops without an operating system, 
#with Linux and Windows 7 next. In general, 
#windows is definitely the most popular operating system. 

WITH pricerank AS
(
SELECT *,
RANK() OVER ( PARTITION BY company ORDER BY priceUSD DESC) AS price_rank
FROM ltclean2 
)
SELECT * FROM pricerank
WHERE price_rank <=5; 

#CTE used for analysing top 5 most expensive laptops for each brand. 

#The SQL queries above provide a broad insight and understanding of what the distribution and 
#pricing structure looks like for laptops within this data.
#For EDA visualizations, check out *R-visualizations*.



