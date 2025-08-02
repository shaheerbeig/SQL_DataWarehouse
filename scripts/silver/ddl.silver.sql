/*
===============================================================================
DDL Script: Create Silver Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'Silver' schema, dropping existing tables 
    if they already exist.
	  Run this script to re-define the DDL structure of 'Silver' Tables
===============================================================================
*/
IF OBJECT_ID('silver.crm_customer_info','U') IS NOT NULL
	DROP TABLE silver.crm_customer_info
create table silver.crm_customer_info(
cst_id int ,
cst_key varchar(10),
cst_firstname varchar(20),
cst_lastname varchar(20),
cst_marital_status varchar(10),
cst_gndr varchar(10),
cst_create_date date
);

IF OBJECT_ID('silver.crm_product_info','U') IS NOT NULL
	DROP TABLE silver.crm_product_info
create table silver.crm_product_info(
prd_id int,
prd_key varchar(100),
category_id varchar(100),
prd_nm varchar(100),
prd_cost int,
prd_line varchar(100),
prd_start_dt date,
prd_end_dt date
);

IF OBJECT_ID('silver.crm_sales_info','U') IS NOT NULL
	DROP TABLE silver.crm_sales_info
create table silver.crm_sales_info(
sls_ord_num varchar(10) ,
sls_prd_key varchar(100),
sls_cust_id int,
sls_order_dt date,
sls_ship_dt date,
sls_due_dt date,
sls_sales int,
sls_quantity int,
sls_price int
);

IF OBJECT_ID('silver.erp_cust_az12','U') IS NOT NULL
	DROP TABLE silver.erp_cust_az12
create table silver.erp_cust_az12(
CID varchar(100),
BDATE date,
GEN varchar(10)
);

IF OBJECT_ID('silver.erp_loc_a101','U') IS NOT NULL
	DROP TABLE silver.erp_loc_a101
create table silver.erp_loc_a101(
CID varchar(100),
CNTRY varchar(100)
);

IF OBJECT_ID('silver.erp_px_cat_g1v2','U') IS NOT NULL
	DROP TABLE silver.erp_px_cat_g1v2
create table silver.erp_px_cat_g1v2(
ID varchar(100),
CAT varchar(200),
SUBCAT varchar(500),
MAINTENANCE varchar(10)
);
