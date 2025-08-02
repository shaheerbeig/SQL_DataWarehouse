/*
===============================================================================
DDL Script: Create Gold View
===============================================================================
Script Purpose:
    This script creates view in the 'view' schema.
	  Run this script to re-define the DDL structure of 'gold' Tables
===============================================================================
*/

create view gold.dim_customers as
SELECT  
row_number() over (order by cst_id)  as customer_key,
ci.cst_id , ci.cst_key , ci.cst_firstname , ci.cst_lastname ,
case when ci.cst_gndr != 'N/A' then ci.cst_gndr
else coalesce(ci.cst_gndr,'N/A')
end cst_gndr , ci.cst_create_date , la.cntry , ca.gen
from silver.crm_customer_info ci 
left join silver.erp_cust_az12 ca on ci.cst_key = ca.cid 
left join silver.erp_loc_a101 la on  ci.cst_key = la.cid

create view gold.dim_product as
select 
row_number() over (order by prd_start_Dt , prd_key ) product_key ,
pi.prd_id , pi.prd_key , pi.prd_nm , pi.prd_Cost , pi.prd_line , pi.prd_start_dt ,
ec.cat, ec.subcat , ec.maintenance
from  silver.crm_product_info pi 
left join silver.erp_px_cat_g1v2 ec on pi.category_id = ec.id  
where pi.prd_end_dt is null

create view gold.fact_sales as
SELECT si.sls_ord_num,ci.customer_key,pi.product_key,si.sls_order_dt,si.sls_ship_dt,si.sls_due_dt,si.sls_sales,si.sls_quantity,si.sls_price
FROM silver.crm_sales_info si 
left join gold.dim_customers ci on si.sls_cust_id = ci.cst_id
left join gold.dim_product pi on si.sls_prd_key = pi.prd_key
