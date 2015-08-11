SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[mobile_GetRealTimeChartValue]
	-- Add the parameters for the stored procedure here
	@ValueType nvarchar(20),
	@StoreIDList nvarchar(max),
	@beginTime datetime,
	@EndTime datetime
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    declare @StoreNameStr nvarchar(max) 
	set @StoreNameStr = dbo.fn_GetStoreName(@StoreIDList)
	declare @sql nvarchar(max) 

	if isnull(@ValueType,'')='GrossSales'
	begin
		--set @sql ='select * from (select SUM(qty*price) value,s.StoreName,MealPeriod 
		--	from OrderLineItem oli inner join Store s on oli.StoreID=s.ID   
		--	inner join [Order] o on o.ID=oli.OrderID  
		-- where oli.BusinessDate between '''+CONVERT(nvarchar(20),@beginTime)+''' and '''+CONVERT(nvarchar(20),@EndTime)+''' and 
		-- oli.StoreID in (select * from dbo.f_split('''+convert(nvarchar(2000),@StoreIDList)+''','','')) group by s.StoreName,mealperiod) b 
		-- pivot	(sum(value) for StoreName in ('+@StoreNameStr+')) b '
		 
		 set @sql='select * from(select Department,CAST(sum(GrossSales) as decimal) GrossSales,s.StoreName from DailyDepartmentSales
		 inner join Store s on s.id=StoreID 
		  where CONVERT(datetime, BusinessDate) between '''+CONVERT(nvarchar(20),@beginTime)+''' and '''+CONVERT(nvarchar(20),@EndTime)+'''
		 and StoreID in (select * from dbo.f_split('''+convert(nvarchar(2000),@StoreIDList)+''','',''))
		 group by Department,s.StoreName)
		 b pivot	(sum(GrossSales) for StoreName in ('+@StoreNameStr+')) c'
	end
	else if isnull(@ValueType,'')='NetSales'
	begin
		--set @sql ='select * from (select SUM(qty*(price-AdjustedPrice)) value,s.StoreName,MealPeriod 
		--	from OrderLineItem oli inner join Store s on oli.StoreID=s.ID   
		--	inner join [Order] o on o.ID=oli.OrderID  
		-- where oli.BusinessDate between '''+CONVERT(nvarchar(20),@beginTime)+''' and 
		-- '''+CONVERT(nvarchar(20),@EndTime)+''' and 
		-- oli.StoreID in (select * from dbo.f_split('''+convert(nvarchar(2000),@StoreIDList)+''','','')) group by s.StoreName,mealperiod) b 
		-- pivot	(sum(value) for StoreName in ('+@StoreNameStr+')) b '
		 
			 set @sql='select * from(select Department,CAST(sum(GrossSales-Voids-Comps-Discount) as decimal) NetSales,s.StoreName from DailyDepartmentSales
		 inner join Store s on s.id=StoreID 
		  where CONVERT(datetime, BusinessDate) between '''+CONVERT(nvarchar(20),@beginTime)+''' and '''+CONVERT(nvarchar(20),@EndTime)+'''
		 and StoreID in (select * from dbo.f_split('''+convert(nvarchar(2000),@StoreIDList)+''','',''))
		 group by Department,s.StoreName)
		 b pivot	(sum(NetSales) for StoreName in ('+@StoreNameStr+')) c'
	end
	else if isnull(@ValueType,'')='Voids' or isnull(@ValueType,'')='Comps' or 
	isnull(@ValueType,'')='Discounts'
	begin
		
		--set @sql ='select * from (select SUM(qty*AdjustedPrice) value,s.StoreName,MealPeriod 
		--	from OrderLineItem oli inner join Store s on oli.StoreID=s.ID   
		--	inner join [Order] o on o.ID=oli.OrderID  
		-- where oli.BusinessDate between '''+CONVERT(nvarchar(20),@beginTime)+''' and 
		-- '''+CONVERT(nvarchar(20),@EndTime)+''' and RecordType=''Void'' and 
		-- oli.StoreID in (select * from dbo.f_split('''+convert(nvarchar(2000),@StoreIDList)+''','','')) group by s.StoreName,mealperiod) b 
		-- pivot	(sum(value) for StoreName in ('+@StoreNameStr+')) b '
		 
		 declare @AdjustType nvarchar(max)
		 if @ValueType='VOIDS' 
		  set @sql='select * from(select Department,CAST(sum(voids) as decimal) value,s.StoreName from DailyDepartmentSales
		 inner join Store s on s.id=StoreID 
		  where CONVERT(datetime, BusinessDate) between '''+CONVERT(nvarchar(20),@beginTime)+'''  
		  and '''+CONVERT(nvarchar(20),@EndTime)+'''
		 and StoreID in (select * from dbo.f_split('''+convert(nvarchar(2000),@StoreIDList)+''','',''))
		
		 group by Department,s.StoreName)
		 b pivot	(sum(Value) for StoreName in ('+@StoreNameStr+')) c'
		 if @ValueType='Comps' 
		  set @sql='select * from(select Department,CAST(sum(comps) as decimal) value,s.StoreName from DailyDepartmentSales
		 inner join Store s on s.id=StoreID 
		  where CONVERT(datetime, BusinessDate) between '''+CONVERT(nvarchar(20),@beginTime)+'''  
		  and '''+CONVERT(nvarchar(20),@EndTime)+'''
		 and StoreID in (select * from dbo.f_split('''+convert(nvarchar(2000),@StoreIDList)+''','',''))
		
		 group by Department,s.StoreName)
		 b pivot	(sum(Value) for StoreName in ('+@StoreNameStr+')) c'
		 if @ValueType='Discounts' 
		  set @sql='select * from(select Department,CAST(sum(Discount) as decimal) value,s.StoreName from DailyDepartmentSales
		 inner join Store s on s.id=StoreID 
		  where CONVERT(datetime, BusinessDate) between '''+CONVERT(nvarchar(20),@beginTime)+'''  
		  and '''+CONVERT(nvarchar(20),@EndTime)+'''
		 and StoreID in (select * from dbo.f_split('''+convert(nvarchar(2000),@StoreIDList)+''','',''))
		
		 group by Department,s.StoreName)
		 b pivot	(sum(Value) for StoreName in ('+@StoreNameStr+')) c'
		 
		 
		
	end
	else if isnull(@ValueType,'')='TotalGuests'
	begin
		--set @sql ='select * from (select SUM(GuestCount) value,s.StoreName,MealPeriod 
		--	from Store s inner join [Order] o on o.StoreID=s.id  
		-- where o.BusinessDate between '''+CONVERT(nvarchar(20),@beginTime)+''' and 
		-- '''+CONVERT(nvarchar(20),@EndTime)+''' and 
		-- o.StoreID in (select * from dbo.f_split('''+convert(nvarchar(2000),@StoreIDList)+''','','')) group by s.StoreName,mealperiod) b 
		-- pivot	(sum(value) for StoreName in ('+@StoreNameStr+')) b '
		 
		 set @sql='select * from(select RevenueCenterName,CAST(sum(NumGuest) as decimal) value,s.StoreName from DailyGuestTableSummaryByPC
		 inner join Store s on s.id=StoreID 
		  where CONVERT(datetime, BusinessDate) between '''+CONVERT(nvarchar(20),@beginTime)+''' 
		  and '''+CONVERT(nvarchar(20),@EndTime)+'''
		 and StoreID in (select * from dbo.f_split('''+convert(nvarchar(2000),@StoreIDList)+''','','')) 
		 group by RevenueCenterName,s.StoreName)
		 b pivot	(sum(Value) for StoreName in ('+@StoreNameStr+')) c'
	end
	--select @sql
	execute sp_executesql @sql
END
GO
