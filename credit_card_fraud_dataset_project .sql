create database project2 ;
use project2 ;

-- 1. Total number of transactions in the dataset.--
SELECT COUNT(TransactionID) AS TotalTransactions FROM dataset;

-- 2. Total amount of transactions.--
SELECT SUM(Amount) AS TotalTransactionAmount FROM dataset;

-- 3. Average transaction amount.--
SELECT AVG(Amount) AS AverageTransactionAmount FROM dataset;

-- 4. Number of fraudulent transactions.--
 SELECT COUNT(TransactionID) AS FraudulentTransactions FROM dataset WHERE IsFraud = 1;
 
 -- 5. Total amount of fraudulent transactions.--
 SELECT SUM(Amount) AS FraudulentTransactionAmount FROM dataset WHERE IsFraud = 1;
 
 -- 6. Number of non-fraudulent transactions.--
 SELECT COUNT(TransactionID) AS NonFraudulentTransactions FROM dataset WHERE IsFraud = 0;
 
 -- 7. Top 5 merchants with the most fraud cases.--
 SELECT MerchantID, COUNT(IsFraud) AS FraudCount FROM dataset WHERE IsFraud = 1 GROUP BY MerchantID ORDER BY FraudCount DESC LIMIT 5;
 
 -- 8. Top 3 transaction types with the most fraud cases.--
 SELECT TransactionType, COUNT(IsFraud) AS FraudCount FROM dataset WHERE IsFraud = 1 GROUP BY TransactionType ORDER BY FraudCount DESC LIMIT 3;
 
 -- 9. Average transaction amount for fraudulent transactions.--
 SELECT AVG(Amount) AS AvgFraudAmount FROM dataset WHERE IsFraud = 1;
 
-- 10. Average transaction amount for non-fraudulent transactions.--
SELECT AVG(Amount) AS AvgNonFraudAmount FROM dataset WHERE IsFraud = 0;

-- 11. Total transaction amount per merchant.--
SELECT MerchantID, SUM(Amount) AS TotalAmount FROM dataset GROUP BY MerchantID;

-- 12. Total fraud cases by location.--
SELECT Location, COUNT(IsFraud) AS FraudCount FROM dataset WHERE IsFraud = 1 GROUP BY Location;

-- 13. Highest transaction amount in the dataset.--
SELECT MAX(Amount) AS HighestTransaction FROM dataset;

-- 14. Lowest transaction amount in the dataset.--
SELECT MIN(Amount) AS LowestTransaction FROM dataset;

-- 15. Find transactions over a certain amount (e.g., $5000).--
SELECT * FROM dataset WHERE Amount > 5000;

-- 16. Find the number of unique merchants in the dataset.--
SELECT COUNT(DISTINCT MerchantID) AS UniqueMerchants FROM dataset;

-- 17. Find the number of unique locations.--
SELECT COUNT(DISTINCT Location) AS UniqueLocations FROM dataset;

-- 18. Percentage of fraudulent transactions.--
SELECT (SUM(CASE WHEN IsFraud = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS FraudPercentage FROM dataset;

-- 19. Percentage of non-fraudulent transactions.--
SELECT (SUM(CASE WHEN IsFraud = 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(*)) AS NonFraudPercentage FROM dataset;

-- 20. Identify the most common transaction type.--
SELECT TransactionType, COUNT(*) AS Count FROM dataset GROUP BY TransactionType ORDER BY Count DESC LIMIT 1;

                                                         -- -- -- -- -- INSIGHTS -- -- -- -- --
-- 1. Transaction Volume
-- Insight: Total transaction volume and daily/monthly transaction counts can reveal peaks or patterns in activity.
-- Action: Monitor high-transaction periods (e.g., weekends, holidays) and potentially add additional security checks during these times if fraud cases also peak.
-- 2. Fraud Rate and Trend
-- Insight: The percentage of fraudulent transactions compared to non-fraudulent ones provides insight into fraud risk levels.
-- Action: If the fraud rate is high, enhance fraud detection algorithms, especially around peak times identified by trend analysis.
-- 3. Transaction Amount Analysis
-- Insight: Average transaction amounts for fraudulent vs. non-fraudulent transactions could reveal that fraud cases involve unusually high or low amounts.
-- Action: Set thresholds for heightened security checks, such as manual reviews for transactions that deviate significantly from average amounts.
-- 4. Merchant-Based Fraud Analysis
-- Insight: Certain merchants may have higher counts or amounts of fraudulent transactions.
-- Action: Collaborate with these merchants to improve transaction verification processes. Implement additional monitoring for transactions involving merchants with high fraud cases.
-- 5. Location-Based Fraud Patterns
-- Insight: Some locations might show a high number of fraudulent transactions compared to others.
-- Action: Increase security protocols, such as two-factor authentication, for transactions from high-risk locations.












