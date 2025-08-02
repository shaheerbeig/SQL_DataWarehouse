/*
===============================================================================
Stored Procedure: Load Silver Layer (Bronze -> Silver)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'Silver' schema from Bronze Layer. 
    It performs the following actions:
    - Truncates the silver tables before loading data

Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXECUTE silver.load_procedure
===============================================================================
*/

EXECUTE silver.load_procedure

CREATE OR ALTER PROCEDURE silver.load_procedure AS
BEGIN
/*
Cleaning the bronze.crm_customer_info and loading in the silver layer
*/
	TRUNCATE TABLE silver.crm_customer_info;
	INSERT INTO silver.crm_customer_info(
	cst_id ,cst_key ,cst_firstname ,cst_lastname ,cst_marital_status ,cst_gndr ,cst_create_date)
	select 
	cst_id , cst_key ,
	trim(cst_firstname) AS cst_firstname ,
	trim(cst_lastname) AS cst_lastname,
	CASE WHEN  cst_marital_status  = 'S' THEN 'Single' WHEN  cst_marital_status ='M' THEN 'Married' ELSE 'N/A' END cst_marital_status , 
	CASE WHEN cst_gndr='F' THEN 'Female' WHEN cst_gndr='M' THEN 'Male' ELSE 'N/A' END cst_gndr , 
	cst_create_date
	from(
	select * , rank() over (partition by cst_id order by cst_create_date desc) AS flag_rank 
	from bronze.crm_customer_info where cst_id is not null)t where flag_rank = 1
/*
Cleaning the bronze.crm_product_info and loading in the silver layer
*/
	TRUNCATE TABLE silver.crm_product_info;
	insert into silver.crm_product_info(
	prd_id ,prd_key ,category_id,prd_nm ,prd_cost,prd_line ,prd_start_dt,prd_end_dt
	)
	select prd_id , 
	substring(prd_key,7,len(prd_key)) prd_key ,
	replace(substring(prd_key,1,5),'-','_') category_id ,
	trim(prd_nm) AS prd_nm ,
	COALESCE(prd_cost,0) AS prd_cost,
	CASE trim(prd_line) WHEN 'R' THEN 'Road' WHEN 'M' THEN 'Mountain' WHEN 'S' THEN 'Other Sales' WHEN 'T' THEN 'Touring' ELSE 'N/A' END prd_line,
	prd_start_dt , 
	DATEADD(DAY, -1, LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt)) AS prd_end_dt
	from bronze.crm_product_info 
/*
Cleaning the bronze.crm_sales_info and loading in the silver layer
*/
	TRUNCATE TABLE silver.crm_sales_info;
	insert into silver.crm_sales_info(
	sls_ord_num, sls_prd_key, sls_cust_id ,sls_order_dt ,sls_ship_dt ,sls_due_dt, sls_quantity ,  sls_price , sls_sales
	)
	SELECT 
	sls_ord_num, sls_prd_key,sls_cust_id, 
	CASE WHEN sls_order_dt <= 0 OR LEN(sls_order_dt) != 8 THEN NULL 
	ELSE TRY_CONVERT(DATE, CAST(NULLIF(sls_order_dt, 0) AS VARCHAR), 112) END sls_order_dt, 
	CASE WHEN sls_ship_dt <= 0 OR LEN(sls_ship_dt) != 8 THEN NULL 
	ELSE TRY_CONVERT(DATE, CAST(NULLIF(sls_ship_dt, 0) AS VARCHAR), 112) END sls_ship_dt,
	CASE WHEN sls_due_dt <= 0 OR LEN(sls_due_dt) != 8 THEN NULL 
	ELSE TRY_CONVERT(DATE, CAST(NULLIF(sls_due_dt, 0) AS VARCHAR), 112) END sls_due_dt,
	sls_quantity,
	CASE WHEN sls_price <= 0 OR sls_price IS NULL THEN sls_sales/nullif(sls_quantity,0)
	ELSE sls_price 
	END sls_price,
	CASE WHEN sls_sales <= 0 or sls_sales is null or sls_sales != abs(sls_price) * sls_quantity
	THEN sls_price * sls_quantity ELSE sls_sales 
	END sls_sales
	FROM bronze.crm_sales_info; 
/*
Cleaning the bronze.erp_cust_az12 and loading in the silver layer
*/
	TRUNCATE TABLE silver.erp_cust_az12;
	INSERT INTO silver.erp_cust_az12(
	CID , BDATE , GEN 
	)
	select substring(CID,4,len(CID)) CID, 
	CASE WHEN BDATE > GETDATE() THEN NULL ELSE BDATE END BDATE ,
	CASE WHEN GEN = 'M' THEN 'Male'
	WHEN GEN = 'F' THEN 'Female'
	WHEN GEN = NULL OR GEN = '' THEN 'N/A'
	ELSE GEN
	END GEN
	from bronze.erp_cust_az12
/*
Cleaning the bronze.erp_loc_a101 and loading in the silver layer
*/
	TRUNCATE TABLE silver.erp_loc_a101;
	insert into silver.erp_loc_a101(
	CID,CNTRY
	)
	select 
	CASE WHEN CID IS NOT NULL THEN CONCAT(SUBSTRING(CID,1,2),SUBSTRING(CID,4,LEN(CID))) ELSE 'N/A' END CID,
	CASE WHEN CNTRY IS NULL OR CNTRY = '' THEN 'N/A' 
	WHEN CNTRY = 'US' OR CNTRY = 'USA' THEN 'United States'
	ELSE CNTRY
	END CNTRY 
	from bronze.erp_loc_a101
/*
Cleaning the bronze.erp_px_cat_g1v2 and loading in the silver layer
*/
	TRUNCATE TABLE silver.erp_px_cat_g1v2;
	INSERT INTO silver.erp_px_cat_g1v2(
	ID , CAT , SUBCAT , MAINTENANCE
	)
	select ID , CAT , SUBCAT , MAINTENANCE FROM BRONZE.erp_px_cat_g1v2

END
