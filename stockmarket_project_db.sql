create database stockmarket_db;
use stockmarket_db;


CREATE TABLE stock_market_data (
    Date DATE NOT NULL,
    Open DECIMAL(10, 2),
    High DECIMAL(10, 2),
    Low DECIMAL(10, 2),
    Close DECIMAL(10, 2),
    Volume BIGINT,
    Company VARCHAR(50),
    PRIMARY KEY (Date, Company)
);

SET global local_infile = ON;

LOAD DATA LOCAL INFILE 'C:/your_path/stockmarket_project.csv'
into table stock_market_data
fields terminated by ','
OPTIONALLY ENCLOSED BY '"'
lines terminated by '\r\n'
ignore 1 rows;

-- Q1 which stock grew more in 5 years?
SELECT company,
MIN(close) AS starting_price,
MAX(close) AS highest_price
FROM stock_market_data
GROUP BY company;

-- this shows growth of apple vs tesla
-- apple get good growth


-- Q2 difference between high and low price
SELECT date, company, (high - low) AS daily_volatility
FROM stock_market_data
ORDER BY daily_volatility DESC;

-- This query identifes days with biggest price changes.


SELECT 
    date,
    MAX(CASE WHEN company = 'Apple' THEN high END) AS apple_high,
    MAX(CASE WHEN company = 'Apple' THEN low END) AS apple_low,
    MAX(CASE WHEN company = 'Tesla' THEN high END) AS tesla_high,
    MAX(CASE WHEN company = 'Tesla' THEN low END) AS tesla_low
FROM stock_market_data
GROUP BY date
ORDER BY date;


-- Check if high trading volume affects price movement.
SELECT company, AVG(volume) AS avg_volume FROM stock_market_data
GROUP BY company;

-- This shows which stock has more liquidity.
-- this shows tesla stock has more liquidity


-- Check how prices changed over time.

SELECT date, company, close FROM stock_market_data
ORDER BY date;

-- Then create a trend chart.



-- Check for any NULL values in important columns
SELECT * FROM stock_market_data 
WHERE Close IS NULL OR Volume IS NULL;

-- Check for "Negative" prices (which should be impossible)
SELECT * FROM stock_market_data 
WHERE Low < 0 OR Open < 0;

-- Check for data consistency (High must always be >= Low)
SELECT * FROM stock_market_data 
WHERE High < Low;

-- 7-Day Moving Average for Apple
SELECT Date, Company, Close,
       AVG(Close) OVER(PARTITION BY Company ORDER BY Date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) as moving_avg_7day
FROM stock_market_data
WHERE Company = 'Apple';