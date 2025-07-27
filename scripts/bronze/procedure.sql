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
