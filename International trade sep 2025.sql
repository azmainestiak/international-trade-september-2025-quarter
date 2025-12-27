CREATE TABLE country_classification (
    country_code VARCHAR(10) PRIMARY KEY,
    country_label VARCHAR(255)
);

select * from country_classification;

CREATE TABLE goods_classification (
    nzhsc_level_2_code_hs4 NUMERIC,
    nzhsc_level_1_code_hs2 VARCHAR(10),
    nzhsc_level_2 TEXT,
    nzhsc_level_1 TEXT,
    status_hs4 VARCHAR(50)
);

select * from goods_classification;

CREATE TABLE services_classification (
    code VARCHAR(20) PRIMARY KEY,
    service_label TEXT);

select * from services_classification;

CREATE TABLE revised_transactions (
    time_ref INTEGER,
    account VARCHAR(20), -- 'Exports' or 'Imports'
    code VARCHAR(20),
    country_code VARCHAR(10),
    product_type VARCHAR(20), -- 'Goods' or 'Services'
    value NUMERIC,
    status CHAR(1) -- 'F' (Final), 'C' (Confidential), etc.
);

select * from revised_transactions;

--Q1: What are the top 5 actual countries by total export value?

SELECT c.country_label, SUM(r.value) as total_export
FROM revised_transactions r
JOIN country_classification c ON r.country_code = c.country_code
WHERE r.account = 'Exports' AND c.country_label NOT LIKE 'Total%'
GROUP BY c.country_label
ORDER BY total_export DESC
LIMIT 5;



--Q2: What is the total trade value (Exports + Imports) for 'Goods' vs 'Services'?

SELECT product_type, SUM(value) as total_value
FROM revised_transactions
GROUP BY product_type;



--Q3: How many transactions are marked with status 'F' (Final)?
SELECT COUNT(*) 
FROM revised_transactions 
WHERE status = 'F';


--Q4: Which month (time_ref) recorded the highest total trade value?
SELECT time_ref, SUM(value) as monthly_total
FROM revised_transactions
GROUP BY time_ref
ORDER BY monthly_total DESC
LIMIT 1;


--Q5: What is the average value of a transaction involving 'United States of America' (US)?

SELECT AVG(value) 
FROM revised_transactions 
WHERE country_code = 'US';


--Q6: List the top 3 specific service codes (excluding the general 'A12' category) by trade value.

SELECT code, SUM(value) as total_val
FROM revised_transactions
WHERE product_type = 'Services' AND code != 'A12'
GROUP BY code
ORDER BY total_val DESC
LIMIT 3;




--Q7: How many unique country codes are recorded in the country classification table?

SELECT COUNT(DISTINCT country_code) 
FROM country_classification;



--Q8: What is the total import value for 'Australia' (AU)?

SELECT SUM(value) 
FROM revised_transactions 
WHERE country_code = 'AU' AND account = 'Imports';


--Q9: Which country code has the highest number of transaction records in the dataset?

SELECT country_code, COUNT(*) as record_count
FROM revised_transactions
GROUP BY country_code
ORDER BY record_count DESC
LIMIT 1;



--Q10: What is the total value of all 'Services' exports?

SELECT SUM(value) 
FROM revised_transactions 
WHERE product_type = 'Services' AND account = 'Exports';