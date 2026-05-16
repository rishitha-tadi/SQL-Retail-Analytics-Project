# 🛒 SQL Retail Analytics Project

## 📌 Project Overview

This project demonstrates how SQL can be used to analyze retail business data and generate meaningful insights. It covers end-to-end data analysis including data cleaning, filtering, aggregation, joins, and advanced analytics using window functions.

The dataset simulates a retail business environment with customers, stores, products, and sales transactions. The project helps in understanding real-world business analysis using SQL queries and analytical techniques.

---

# 🗂️ Database Structure

## 📋 Tables Used

### 1. customers
- Stores customer details

### 2. stores
- Contains store information

### 3. products
- Includes product categories

### 4. sales
- Main transactional sales data

---

# ⚙️ Data Generation

- 50 Customers  
- 3 Stores (CMR, SR, Lucky)  
- 4 Product Categories (Electronics, Fashion, Grocery, Home)  
- 1000 Sales Records generated using `CONNECT BY LEVEL` and `DBMS_RANDOM`

---

# 🔍 Project Sections

## 1️⃣ Data Understanding

- Total transactions, revenue, and customers  
- Average order value analysis  
- Sales by store and category  
- Understanding dataset structure and business metrics  

---

## 2️⃣ Data Cleaning

- Handling NULL values using `NVL` and `COALESCE`  
- Creating cleaned revenue columns  
- Identifying missing data  
- Preparing data for analysis  

---

## 3️⃣ Filtering (WHERE Clause)

- Sales based on conditions  
- Store and category-based filtering  
- High-value transactions  
- Recent transaction analysis  

---

## 4️⃣ Aggregation (GROUP BY)

- Revenue per store, category, and customer  
- Monthly and daily sales analysis  
- Quantity and discount analysis  
- Summarizing business performance  

---

## 5️⃣ HAVING Clause

- Identifying top-performing customers and stores  
- Filtering aggregated results  
- Advanced grouped data analysis  

---

## 6️⃣ CASE WHEN Statements

- Customer segmentation (High / Medium / Low)  
- Transaction classification  
- Custom business labels and conditions  

---

## 7️⃣ JOINS

- Combining multiple tables  
- Customer-store-product analysis  
- Matching and comparing related data  
- Finding missing and unmatched records  

---

## 8️⃣ Window Functions

- Ranking customers and stores  
- Running totals and cumulative revenue  
- LAG and LEAD functions for trend analysis  
- Advanced analytical calculations  

---

## 9️⃣ NTILE / Segmentation

- Customer segmentation into quartiles  
- Identifying top 25% and bottom customers  
- Marketing and business segmentation analysis  

---

## 🔟 FIRST_VALUE Analysis

- Comparing best and worst performance  
- Identifying top customers and categories  
- Business comparison analysis  

---

## 1️⃣1️⃣ Date Analysis

- Daily and monthly sales trends  
- Weekend sales analysis  
- Customer activity tracking  
- Time-based business insights  

---

# 🧠 Key Skills Used

- SQL Queries (Basic to Advanced)  
- Data Cleaning Techniques  
- Aggregations & Grouping  
- Joins & Subqueries  
- Window Functions  
- Data Segmentation  
- Business Data Analysis  

---

# 📊 Tools Used

- Oracle SQL / FreeSQL  
- Microsoft Word (Documentation)  
- GitHub (Project Sharing)  

---

# 📁 Project Structure

```bash id="31hl7w"
SQL-Retail-Analytics-Project/
│
├── retail_analysis.sql
├── sales_dataset.sql
├── README.md
```

---

# 🚀 How to Run the Project

1. Create tables using the provided SQL scripts  

2. Insert data using auto-generated queries  

3. Run SQL analysis queries step by step  

4. Review query outputs and business insights  

---

# 📈 Sample Analysis Performed

- Store-wise revenue analysis  
- Customer segmentation analysis  
- Product category performance  
- Running revenue calculations  
- Monthly sales trend analysis  
- Ranking top-performing customers  
- Discount and quantity analysis  

---

# 📌 Conclusion

This project showcases how SQL can be used for real-world business analysis in the retail domain. It demonstrates practical usage of SQL concepts such as filtering, grouping, joins, window functions, and segmentation techniques.

The project helps in understanding customer behavior, sales performance, revenue trends, and business insights through structured query analysis. It also improves practical SQL skills used in data analytics and business intelligence projects.

---

# 🙌 Author

**Rishitha Tadi**  
Aspiring Data Analyst | SQL Learner

