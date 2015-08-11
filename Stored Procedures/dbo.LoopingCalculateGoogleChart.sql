SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
--looping 5 minutes
CREATE proc [dbo].[LoopingCalculateGoogleChart]

as
declare @storeID int

--Deletion of expired data
declare @endDate as datetime
	declare @monthBeginDate as datetime
	declare @dayBeginDate as datetime
	set @endDate=CONVERT(nvarchar(20), datepart(year,getdate()))+'-12-31'
	set @monthBeginDate=convert(nvarchar(10),datepart(year,DATEAdd(YEAR,-1, getdate()))) +'-11-01' 
	set @dayBeginDate=DATEADD(day,-6,DATEADD(day, DATEDIFF(day,0,GETDATE()),0))
	
	declare @TableName nvarchar(50)
	declare @sql nvarchar(max)
	set @sql=''
	declare curTable cursor
	read_only
	for select name from sysobjects where xtype='U' and name like 'GoogleChart%' and name<>'GoogleChartSetting'
	and name<>'GoogleChartPositionSetting' order by name 
	open curTable
	fetch next from curTable into @TableName
	while(@@fetch_status=0)
	begin
		set @sql +='delete  from '+@TableName+' where CONVERT(datetime, case when  len(ltrim(rtrim(BusinessDate)))>7 then BusinessDate else GETDATE() end)<'''+CONVERT(nvarchar(20),@dayBeginDate)+'''
		or CONVERT(datetime, case when  len(ltrim(rtrim(BusinessDate)))<=7 then ltrim(rtrim(BusinessDate))+''-01'' else GETDATE() end)<'''+CONVERT(nvarchar(20),@monthBeginDate)+'''
		and storeid in (select StoreID from FoundationMessageLog where IsCalculating=1)'
		
		fetch next from curTable into @TableName
	end
	close curTable
	deallocate curTable
	--select @sql
	execute sp_executesql @sql
	
--	delete  from GoogleChartGrossSalesByDept where 
--	CONVERT(datetime, case when  len(ltrim(rtrim(BusinessDate)))>7 then BusinessDate else GETDATE() end)<@dayBeginDate
--or CONVERT(datetime, case when  len(ltrim(rtrim(BusinessDate)))<=7 then ltrim(rtrim(BusinessDate))+'-01' else GETDATE() end)<@monthBeginDate
--	delete  from GoogleChartGrossSalesByDeptOld where CONVERT(datetime, case when  len(ltrim(rtrim(BusinessDate)))>7 then BusinessDate else GETDATE() end)<@dayBeginDate
--or CONVERT(datetime, case when  len(ltrim(rtrim(BusinessDate)))<=7 then ltrim(rtrim(BusinessDate))+'-01' else GETDATE() end)<@monthBeginDate
	
--	delete  from GoogleChartGrossSalesByPeriodAll where CONVERT(datetime, case when  len(ltrim(rtrim(BusinessDate)))>7 then BusinessDate else GETDATE() end)<@dayBeginDate
--or CONVERT(datetime, case when  len(ltrim(rtrim(BusinessDate)))<=7 then ltrim(rtrim(BusinessDate))+'-01' else GETDATE() end)<@monthBeginDate
--	delete  from GoogleChartGrossSalesByPeriodAllOld where CONVERT(datetime, case when  len(ltrim(rtrim(BusinessDate)))>7 then BusinessDate else GETDATE() end)<@dayBeginDate
--or CONVERT(datetime, case when  len(ltrim(rtrim(BusinessDate)))<=7 then ltrim(rtrim(BusinessDate))+'-01' else GETDATE() end)<@monthBeginDate
	
--	delete  from GoogleChartGrossSalesByProfitCenter where CONVERT(datetime, case when  len(ltrim(rtrim(BusinessDate)))>7 then BusinessDate else GETDATE() end)<@dayBeginDate
--or CONVERT(datetime, case when  len(ltrim(rtrim(BusinessDate)))<=7 then ltrim(rtrim(BusinessDate))+'-01' else GETDATE() end)<@monthBeginDate
--	delete  from GoogleChartGrossSalesByProfitCenterOld where CONVERT(datetime, case when  len(ltrim(rtrim(BusinessDate)))>7 then BusinessDate else GETDATE() end)<@dayBeginDate
--or CONVERT(datetime, case when  len(ltrim(rtrim(BusinessDate)))<=7 then ltrim(rtrim(BusinessDate))+'-01' else GETDATE() end)<@monthBeginDate
	
--	delete  from GoogleChartGuestSummaryByPeriodAll where CONVERT(datetime, case when  len(ltrim(rtrim(BusinessDate)))>7 then BusinessDate else GETDATE() end)<@dayBeginDate
--or CONVERT(datetime, case when  len(ltrim(rtrim(BusinessDate)))<=7 then ltrim(rtrim(BusinessDate))+'-01' else GETDATE() end)<@monthBeginDate
--	delete  from GoogleChartGuestSummaryByPeriodAllOld where CONVERT(datetime, case when  len(ltrim(rtrim(BusinessDate)))>7 then BusinessDate else GETDATE() end)<@dayBeginDate
--or CONVERT(datetime, case when  len(ltrim(rtrim(BusinessDate)))<=7 then ltrim(rtrim(BusinessDate))+'-01' else GETDATE() end)<@monthBeginDate
	
--	delete  from GoogleChartGuestSummaryByProfitCenterAll where CONVERT(datetime, case when  len(ltrim(rtrim(BusinessDate)))>7 then BusinessDate else GETDATE() end)<@dayBeginDate
--or CONVERT(datetime, case when  len(ltrim(rtrim(BusinessDate)))<=7 then ltrim(rtrim(BusinessDate))+'-01' else GETDATE() end)<@monthBeginDate
--	delete  from GoogleChartGuestSummaryByProfitCenterAllOld where CONVERT(datetime, case when  len(ltrim(rtrim(BusinessDate)))>7 then BusinessDate else GETDATE() end)<@dayBeginDate
--or CONVERT(datetime, case when  len(ltrim(rtrim(BusinessDate)))<=7 then ltrim(rtrim(BusinessDate))+'-01' else GETDATE() end)<@monthBeginDate
	
--	delete  from GoogleChartGuestSummaryByStoreAll where CONVERT(datetime, case when  len(ltrim(rtrim(BusinessDate)))>7 then BusinessDate else GETDATE() end)<@dayBeginDate
--or CONVERT(datetime, case when  len(ltrim(rtrim(BusinessDate)))<=7 then ltrim(rtrim(BusinessDate))+'-01' else GETDATE() end)<@monthBeginDate
--	delete  from GoogleChartGuestSummaryByStoreAllOld where CONVERT(datetime, case when  len(ltrim(rtrim(BusinessDate)))>7 then BusinessDate else GETDATE() end)<@dayBeginDate
--or CONVERT(datetime, case when  len(ltrim(rtrim(BusinessDate)))<=7 then ltrim(rtrim(BusinessDate))+'-01' else GETDATE() end)<@monthBeginDate
	
--	delete  from GoogleChartNumberByPaymentTypeAll where CONVERT(datetime, case when  len(ltrim(rtrim(BusinessDate)))>7 then BusinessDate else GETDATE() end)<@dayBeginDate
--or CONVERT(datetime, case when  len(ltrim(rtrim(BusinessDate)))<=7 then ltrim(rtrim(BusinessDate))+'-01' else GETDATE() end)<@monthBeginDate
--	delete  from GoogleChartNumberByPaymentTypeAllOld where CONVERT(datetime, case when  len(ltrim(rtrim(BusinessDate)))>7 then BusinessDate else GETDATE() end)<@dayBeginDate
--or CONVERT(datetime, case when  len(ltrim(rtrim(BusinessDate)))<=7 then ltrim(rtrim(BusinessDate))+'-01' else GETDATE() end)<@monthBeginDate
	
--	delete  from GoogleChartSaleByPaymentTypeAll where CONVERT(datetime, case when  len(ltrim(rtrim(BusinessDate)))>7 then BusinessDate else GETDATE() end)<@dayBeginDate
--or CONVERT(datetime, case when  len(ltrim(rtrim(BusinessDate)))<=7 then ltrim(rtrim(BusinessDate))+'-01' else GETDATE() end)<@monthBeginDate
--	delete  from GoogleChartSaleByPaymentTypeAllOld where CONVERT(datetime, case when  len(ltrim(rtrim(BusinessDate)))>7 then BusinessDate else GETDATE() end)<@dayBeginDate
--or CONVERT(datetime, case when  len(ltrim(rtrim(BusinessDate)))<=7 then ltrim(rtrim(BusinessDate))+'-01' else GETDATE() end)<@monthBeginDate
	
--	delete  from GoogleChartSalesByStoreALL where CONVERT(datetime, case when  len(ltrim(rtrim(BusinessDate)))>7 then BusinessDate else GETDATE() end)<@dayBeginDate
--or CONVERT(datetime, case when  len(ltrim(rtrim(BusinessDate)))<=7 then ltrim(rtrim(BusinessDate))+'-01' else GETDATE() end)<@monthBeginDate
--	delete  from GoogleChartSalesByStoreALLOld where CONVERT(datetime, case when  len(ltrim(rtrim(BusinessDate)))>7 then BusinessDate else GETDATE() end)<@dayBeginDate
--or CONVERT(datetime, case when  len(ltrim(rtrim(BusinessDate)))<=7 then ltrim(rtrim(BusinessDate))+'-01' else GETDATE() end)<@monthBeginDate
	
--	delete  from GoogleChartTableSummaryByPeriodAll where CONVERT(datetime, case when  len(ltrim(rtrim(BusinessDate)))>7 then BusinessDate else GETDATE() end)<@dayBeginDate
--or CONVERT(datetime, case when  len(ltrim(rtrim(BusinessDate)))<=7 then ltrim(rtrim(BusinessDate))+'-01' else GETDATE() end)<@monthBeginDate
--	delete  from GoogleChartTableSummaryByPeriodAllOld where CONVERT(datetime, case when  len(ltrim(rtrim(BusinessDate)))>7 then BusinessDate else GETDATE() end)<@dayBeginDate
--or CONVERT(datetime, case when  len(ltrim(rtrim(BusinessDate)))<=7 then ltrim(rtrim(BusinessDate))+'-01' else GETDATE() end)<@monthBeginDate
	
--	delete  from GoogleChartTableSummaryByProfitCenterAll where CONVERT(datetime, case when  len(ltrim(rtrim(BusinessDate)))>7 then BusinessDate else GETDATE() end)<@dayBeginDate
--or CONVERT(datetime, case when  len(ltrim(rtrim(BusinessDate)))<=7 then ltrim(rtrim(BusinessDate))+'-01' else GETDATE() end)<@monthBeginDate
--	delete  from GoogleChartTableSummaryByProfitCenterAllOld where CONVERT(datetime, case when  len(ltrim(rtrim(BusinessDate)))>7 then BusinessDate else GETDATE() end)<@dayBeginDate
--or CONVERT(datetime, case when  len(ltrim(rtrim(BusinessDate)))<=7 then ltrim(rtrim(BusinessDate))+'-01' else GETDATE() end)<@monthBeginDate
	
--	delete  from GoogleChartTableSummaryByStoreAll where CONVERT(datetime, case when  len(ltrim(rtrim(BusinessDate)))>7 then BusinessDate else GETDATE() end)<@dayBeginDate
--or CONVERT(datetime, case when  len(ltrim(rtrim(BusinessDate)))<=7 then ltrim(rtrim(BusinessDate))+'-01' else GETDATE() end)<@monthBeginDate
--	delete  from GoogleChartTableSummaryByStoreAllOld where CONVERT(datetime, case when  len(ltrim(rtrim(BusinessDate)))>7 then BusinessDate else GETDATE() end)<@dayBeginDate
--or CONVERT(datetime, case when  len(ltrim(rtrim(BusinessDate)))<=7 then ltrim(rtrim(BusinessDate))+'-01' else GETDATE() end)<@monthBeginDate
	
--	delete  from GoogleChartVoidCompDiscont where CONVERT(datetime, case when  len(ltrim(rtrim(BusinessDate)))>7 then BusinessDate else GETDATE() end)<@dayBeginDate
--or CONVERT(datetime, case when  len(ltrim(rtrim(BusinessDate)))<=7 then ltrim(rtrim(BusinessDate))+'-01' else GETDATE() end)<@monthBeginDate
--	delete  from GoogleChartVoidCompDiscontOld where CONVERT(datetime, case when  len(ltrim(rtrim(BusinessDate)))>7 then BusinessDate else GETDATE() end)<@dayBeginDate
--or CONVERT(datetime, case when  len(ltrim(rtrim(BusinessDate)))<=7 then ltrim(rtrim(BusinessDate))+'-01' else GETDATE() end)<@monthBeginDate
--Deletion of expired data
declare cur cursor
read_only
for select StoreID from FoundationMessageLog where IsCalculating=1
open cur
fetch next from cur into @storeID
while(@@fetch_status=0)
begin
	exec GoogleChart_GrossSalesByDeptSel @storeID
	exec GoogleChart_GrossSalesByPeriodAllSel @storeID
	exec GoogleChart_GrossSalesByProfitCenterSel @storeID
	exec GoogleChart_GuestSummaryByPeriodAllSel @storeID
	exec GoogleChart_GuestSummaryByProfitCenterAllSel @storeID
	exec GoogleChart_GuestSummaryByStoreAllSel @storeID
	exec GoogleChart_NumberByPaymentTypeAllSel @storeID
	exec GoogleChart_SaleByPaymentTypeAllSel @storeID
	exec GoogleChart_SalesByStoreALLSel @storeID
	exec GoogleChart_TableSummaryByPeriodAllSel @storeID
	exec GoogleChart_TableSummaryByProfitCenterAllSel @storeID
	exec GoogleChart_TableSummaryByStoreAllSel @storeID
	exec GoogleChart_VoidCompDiscontSel @storeID
	exec [GoogleChart_LaborByPositionAllSel] @storeID
	exec [GoogleChart_LaborByStore] @storeID
	--exec GoogleChart_SaleAndLaobrAllSel @storeID
	update FoundationMessageLog set IsCalculating=0 where StoreID=@storeID
fetch next from cur into @storeID
end
close cur
deallocate cur
GO
