🏅 SQL Data Warehouse – Medallion Architecture
This repository contains a SQL-based Data Warehouse implementation using the Medallion Architecture pattern. The project processes two CSV files (customers.csv and orders.csv) and builds analytical insights across Bronze, Silver, and Gold layers.

📌 Key Concepts
Medallion Architecture is a layered approach to organizing data workflows:

🥉 Bronze Layer: Ingests raw, uncleaned data.

🥈 Silver Layer: Cleans, transforms, and enriches the raw data.

🥇 Gold Layer: Provides aggregated, business-ready datasets for reporting and analytics.

📂 Project Structure
pgsql
Copy
Edit
.
├── data/
│   ├── customers.csv                # Raw customer data
│   └── orders.csv                   # Raw order data
│
├── sql/
│   ├── bronze/
│   │   ├── create_bronze_customers.sql
│   │   └── create_bronze_orders.sql
│   │
│   ├── silver/
│   │   ├── transform_customers.sql
│   │   └── transform_orders.sql
│   │
│   └── gold/
│       ├── customer_order_summary.sql
│       └── top_customers_by_spend.sql
│
├── schema_diagram.png               # Optional: ER diagram or workflow
└── README.md
🗃️ Source Data
File	Description
customers.csv	Contains customer information (ID, name, region, etc.)
orders.csv	Contains order details (ID, customer_id, amount, date)

🧰 Technologies Used
SQL (compatible with PostgreSQL / MySQL / SQLite)

Manual CSV ingestion or COPY/LOAD command

Optional: DBeaver / pgAdmin / CLI tools for interaction

🚀 How to Run
1. Clone the Repository
bash
Copy
Edit
git clone https://github.com/yourusername/sql-medallion-warehouse.git
cd sql-medallion-warehouse
2. Set Up Your Database
Use any SQL-compatible RDBMS (PostgreSQL is recommended).

3. Create Bronze Tables
Execute scripts from sql/bronze/ to create raw tables:

sql
Copy
Edit
-- Create raw tables
\i sql/bronze/create_bronze_customers.sql
\i sql/bronze/create_bronze_orders.sql
4. Load CSV Data
sql
Copy
Edit
-- Example for PostgreSQL
\COPY bronze_customers FROM 'data/customers.csv' DELIMITER ',' CSV HEADER;
\COPY bronze_orders FROM 'data/orders.csv' DELIMITER ',' CSV HEADER;
5. Transform to Silver Layer
Run transformation scripts:

sql
Copy
Edit
\i sql/silver/transform_customers.sql
\i sql/silver/transform_orders.sql
6. Generate Gold Insights
sql
Copy
Edit
\i sql/gold/customer_order_summary.sql
\i sql/gold/top_customers_by_spend.sql
🧱 Medallion Architecture Layers
🥉 Bronze Layer – Raw Zone
Stores unprocessed CSV data.

Tables:

bronze_customers

bronze_orders

🥈 Silver Layer – Clean Zone
Applies data cleansing (e.g., trimming, type casting, null handling).

Standardizes schemas and formats.

Tables:

silver_customers

silver_orders

🥇 Gold Layer – Analytics Zone
Provides business logic, aggregations, and KPIs.

Ready for dashboarding tools (Power BI, Tableau, etc.).

Views or tables:

gold_customer_order_summary

gold_top_customers_by_spend

📊 Example Output (Gold Layer)
Top 5 Customers by Spend:

Customer ID	Name	Total Spent
101	John Smith	$3,240.00
203	Jane Doe	$2,890.50
...	...	...

✅ Benefits of This Architecture
Scalable and modular ETL pipeline.

Historical auditability with preserved raw data.

Easy to extend with new sources or metrics.

Clear separation of concerns for data engineers and analysts.
