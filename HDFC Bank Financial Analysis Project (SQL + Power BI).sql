CREATE DATABASE HDFC_BANK;
USE HDFC_BANK;

CREATE TABLE  PROFIT_LOSS_YEARLY(
PERIOD_YEAR TEXT,
 Sales 	DOUBLE,
 Raw_Material_Cost 	DOUBLE, 
 Change_in_Inventory 	DOUBLE,
 Power_and_Fuel 	DOUBLE,
 Other_Mfr_Exp 	DOUBLE,	
 Employee_Cost 	DOUBLE,
 Selling_and_admin 	DOUBLE,	
 Other_Expenses		DOUBLE,
 Other_Income 	DOUBLE,
 Depreciation 	DOUBLE,
 Interest 	DOUBLE,
 Profit_before_tax 	DOUBLE,
 Tax 	DOUBLE,
 Net_profit 	DOUBLE,
 Dividend_Amount 	DOUBLE);

CREATE TABLE PROFIT_LOSS_QUATERLY(
PERIOD_YEAR TEXT,
Sales DOUBLE ,
Expenses DOUBLE ,
Other_Income DOUBLE ,
Depreciation DOUBLE ,
Interest DOUBLE ,
Profit_before_tax DOUBLE ,
Tax	DOUBLE ,
Net_profit DOUBLE ,
Operating_Profit DOUBLE );

CREATE TABLE BALANCESHEET(
PERIOD_YEAR TEXT,
Equity_Share_Capital DOUBLE,
Reserves DOUBLE,
 Borrowings DOUBLE,
 Other_Liabilities DOUBLE,
 Total DOUBLE,
 Net_Block DOUBLE,
 Investments DOUBLE,
 Other_Assets DOUBLE,
 Totals DOUBLE,
 Receivables DOUBLE,
 Inventory DOUBLE,
 Cash_Bank DOUBLE,
 No_of_Equity_Shares BIGINT,
 New_Bonus_Shares DOUBLE);
 
 CREATE TABLE CASHFLOW(
PERIOD_YEAR TEXT,
 Cash_from_Operating_Activity DOUBLE,
 Cash_from_Investing_Activity DOUBLE,
 Cash_from_Financing_Activity DOUBLE,
 Net_Cash_Flow DOUBLE,
 PRICE DOUBLE,
 Adjusted_Equity_Shares_in_Cr DOUBLE);
 
 -- TASKS AND ANALYSIS 
 
-- Revenue & Profitability Analysis

-- What is the total revenue and net profit per year?

SELECT PERIOD_YEAR,SALES AS TOTAL_REVENUE,Net_profit
FROM profit_loss_yearly
ORDER BY PERIOD_YEAR;

-- Which quarter had the highest net profit?

SELECT NET_PROFIT,PERIOD_QUATERELY
FROM profit_loss_quaterly
ORDER BY NET_PROFIT DESC;

-- Year-over-Year Sales Growth

SELECT 
    PERIOD_YEAR,
    sales,
    LAG(sales) OVER (ORDER BY PERIOD_YEAR) AS previous_year_sales,
    ROUND(((sales - LAG(sales) OVER (ORDER BY PERIOD_YEAR)) / LAG(sales) OVER (ORDER BY PERIOD_YEAR)) * 100, 2) AS yoy_growth_percent
FROM 
    profit_loss_yearly;
    
-- Average Annual Sales

SELECT AVG(SALES)
FROM profit_loss_yearly;

-- Top 5 metrics with the highest values in 2025

SELECT Sales, 
Raw_Material_Cost, 
Change_in_Inventory, 
Power_and_Fuel,
Other_Mfr_Exp ,
Employee_Cost ,
Selling_and_admin,  
Other_Expenses ,
Other_Income ,
Depreciation ,
Interest ,
Profit_before_tax ,
Tax,
Net_profit ,
Dividend_Amount
FROM profit_loss_yearly
WHERE PERIOD_YEAR  = "Mar-25"
ORDER BY Sales, 
Raw_Material_Cost, 
Change_in_Inventory, 
Power_and_Fuel,
Other_Mfr_Exp ,
Employee_Cost ,
Selling_and_admin,  
Other_Expenses ,
Other_Income ,
Depreciation ,
Interest ,
Profit_before_tax ,
Tax,
Net_profit ,
Dividend_Amount DESC
LIMIT 5;


-- Cost Structure Analysis

-- Trend in Other Manufacturing Expenses

SELECT PERIOD_YEAR , Other_Mfr_Exp AS other_expenses
FROM profit_loss_yearly
ORDER BY PERIOD_YEAR DESC;

-- Which year had the highest Other Manufacturing Expenses?

SELECT Other_Mfr_Exp AS MAX_Other_Mfr_Exp  ,PERIOD_YEAR 
FROM profit_loss_yearly 
ORDER BY Other_Mfr_Exp DESC
LIMIT 1; 

-- Cost-to-Income ratio (Total Expenses / Total Income)?

SELECT 
    PERIOD_YEAR,
    sales,
    Other_Expenses,
    other_income,
    depreciation,
    interest,
    tax,
    
    -- Total Expenses
    (Other_Expenses + depreciation + interest + tax) AS total_expenses,
    
    -- Total Income
    (sales + other_income) AS total_income,
    
    -- Cost-to-Income Ratio
    ROUND((Other_Expenses + depreciation + interest + tax) / NULLIF((sales + other_income), 0), 4) AS cost_to_income_ratio

FROM profit_loss_yearly
ORDER BY PERIOD_YEAR;

-- Ratio Calculations

-- Identify the Year with the Highest Expense-to-Sales Ratio

SELECT PERIOD_YEAR,
       Other_Expenses,
       sales,
       ROUND((Other_Expenses / sales) * 100, 2) AS expense_to_sales_ratio
FROM profit_loss_yearly
ORDER BY expense_to_sales_ratio DESC
LIMIT 1;

-- Cost-to-Sales Ratio

SELECT PERIOD_YEAR,
       ROUND(Other_Mfr_Exp / Sales, 2) AS cost_to_sales_ratio
FROM profit_loss_yearly;

-- Comparative & Variance Analysis

-- Variance in Sales between 2024 and 2025?

SELECT 
    MAX(CASE WHEN PERIOD_YEAR ="Mar-25" THEN Sales END) - 
    MAX(CASE WHEN PERIOD_YEAR = "Mar-24" THEN Sales END) AS sales_variance
FROM profit_loss_yearly;

-- Year when Sales crossed ₹1.5 lakh crore

SELECT PERIOD_YEAR,sales
FROM profit_loss_yearly
WHERE Sales>= 150000;

 -- Multi-Year Comparison

-- Compare Sales and Other Expenses across 3 selected years

SELECT Sales, Other_Mfr_Exp,PERIOD_YEAR
FROM profit_loss_yearly
WHERE PERIOD_YEAR in ("Mar-20", "Mar-23", "Mar-25");


-- Growth rate in Other Mfr. Exp. from 2018 to 2023

SELECT 
    MAX(CASE WHEN PERIOD_YEAR = "Mar-18" THEN Other_Mfr_Exp END) AS exp_2018,
    MAX(CASE WHEN PERIOD_YEAR = "Mar-23" THEN Other_Mfr_Exp END) AS exp_2023,
    ROUND((MAX(CASE WHEN PERIOD_YEAR = "Mar-23" THEN Other_Mfr_Exp END) - 
           MAX(CASE WHEN PERIOD_YEAR = "Mar-18" THEN Other_Mfr_Exp END)) / 
           MAX(CASE WHEN PERIOD_YEAR = "Mar-18" THEN Other_Mfr_Exp END) * 100, 2) AS growth_pct
FROM profit_loss_yearly;

-- Average Dividend Paid (2016–2025)

SELECT AVG(Dividend_Amount) AS avg_dividend
FROM profit_loss_yearly;

-- Total Interest Expense

SELECT SUM(interest) AS total_interest_expense
FROM profit_loss_yearly ;

-- Maximum Depreciation Value

SELECT MAX(depreciation) AS max_depreciation 
FROM profit_loss_yearly ;

-- YoY Growth in Sales

SELECT PERIOD_YEAR,
       sales,
       LAG(sales) OVER (ORDER BY PERIOD_YEAR ) AS prev_year_sales,
       ROUND((sales - LAG(sales) OVER (ORDER BY PERIOD_YEAR)) / LAG(sales) OVER (ORDER BY PERIOD_YEAR) * 100, 2) AS sales_growth_percent
FROM profit_loss_yearly;

-- YoY Growth in Net Profit

SELECT year,
       net_profit,
       LAG(net_profit) OVER (ORDER BY year) AS prev_net_profit,
       ROUND((net_profit - LAG(net_profit) OVER (ORDER BY year)) / LAG(net_profit) OVER (ORDER BY year) * 100, 2) AS net_profit_growth
FROM yearly_pl;

-- YoY Change in Dividend Payout

SELECT PERIOD_YEAR,
       Dividend_Amount,
       LAG(Dividend_Amount) OVER (ORDER BY PERIOD_YEAR) AS prev_dividend,
       ROUND((Dividend_Amount - LAG(Dividend_Amount) OVER (ORDER BY PERIOD_YEAR)) / LAG(Dividend_Amount) OVER (ORDER BY PERIOD_YEAR) * 100, 2) AS dividend_growth
FROM profit_loss_yearly ;

-- Average YoY Growth in Total Expenses

SELECT ROUND(AVG((Other_Expenses - LAG(Other_Expenses) OVER (ORDER BY PERIOD_YEAR)) / LAG(Other_Expenses) OVER (ORDER BY PERIOD_YEAR) * 100), 2) AS avg_expense_growth
FROM profit_loss_yearly;

-- Year with Highest % Increase in PBT
SELECT PERIOD_YEAR,
       ROUND((Profit_before_tax - LAG(Profit_before_tax) OVER (ORDER BY PERIOD_YEAR)) / LAG(Profit_before_tax) OVER (ORDER BY PERIOD_YEAR) * 100, 2) AS pbt_growth
FROM profit_loss_yearly
ORDER BY pbt_growth DESC
LIMIT 1;

-- Profit Margin (%) Each Year

SELECT PERIOD_YEAR,
       ROUND((net_profit / sales) * 100, 2) AS profit_margin
FROM profit_loss_yearly;


 -- Dividend Payout Ratio

SELECT PERIOD_YEAR,
       ROUND((Dividend_Amount / net_profit) * 100, 2) AS dividend_payout_ratio
FROM profit_loss_yearly
WHERE net_profit > 0;

-- Operating Profit (Sales - Expenses)

SELECT PERIOD_YEAR,
       sales - Other_Expenses AS operating_profit
FROM profit_loss_yearly;

-- Effective Tax Rate

SELECT PERIOD_YEAR,
       ROUND((tax / Profit_before_tax) * 100, 2) AS effective_tax_rate
FROM profit_loss_yearly
WHERE Profit_before_tax > 0;



























