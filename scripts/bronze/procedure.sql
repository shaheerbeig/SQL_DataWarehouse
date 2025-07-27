/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files. 
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the `BULK INSERT` command to load data from csv Files to bronze tables.

Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC bronze.load_bronze;
===============================================================================
*/
CREATE OR ALTER PROCEDURE bronze.load_procedure AS
BEGIN
	BEGIN TRY
		TRUNCATE TABLE bronze.crm_customer_info
		BULK INSERT bronze.crm_customer_info
		from 'C:\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		with (
			firstrow = 2,
			fieldterminator=','
		);

		TRUNCATE TABLE bronze.crm_product_info
		BULK INSERT bronze.crm_product_info
		from 'C:\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		with(
			firstrow = 2,
			fieldterminator=','
		)

		TRUNCATE TABLE  bronze.crm_sales_info
		BULK INSERT bronze.crm_sales_info
		from 'C:\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		with(
			firstrow = 2,
			fieldterminator=','
		);

		TRUNCATE TABLE  bronze.erp_loc_a101
		BULK INSERT bronze.erp_loc_a101
		from 'C:\sql-data-warehouse-project\datasets\source_erp\loc_a101.csv'
		with(
			firstrow = 2,
			fieldterminator=','
		);

		TRUNCATE TABLE  bronze.erp_cust_az12
		BULK INSERT bronze.erp_cust_az12
		from 'C:\sql-data-warehouse-project\datasets\source_erp\cust_az12.csv'
		with(
			firstrow = 2,
			fieldterminator=','
		);

		TRUNCATE TABLE  bronze.erp_px_cat_g1v2
		BULK INSERT bronze.erp_px_cat_g1v2
		from 'C:\sql-data-warehouse-project\datasets\source_erp\px_cat_g1v2.csv'
		with(
			firstrow = 2,
			fieldterminator=','
		);
	END TRY
	BEGIN CATCH
		PRINT 'Error Message' + ERROR_MESSAGE();
	END CATCH
END
