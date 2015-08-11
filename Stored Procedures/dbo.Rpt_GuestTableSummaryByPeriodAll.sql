SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [dbo].[Rpt_GuestTableSummaryByPeriodAll]
	@BeginDate datetime,
	@EndDate datetime,
	@storeID nvarchar(200)
AS
begin

if exists (select * from tempdb.dbo.sysobjects where id = object_id(N'tempdb..#temp') and type='U')
   drop table #temp
   
select SaleGroup,RecordType,ISNULL(sum(value),0) as value into #temp  from
(
Select dbo.f_GetOrderMealPeriodRpt(o.openTime,o.StoreID) as SaleGroup,'Number Tables Served' as RecordType,count(o.ID) as value  
From (select openTime,StoreID,status,ID  from [dbo].[fnOrderTable](@BeginDate,@EndDate,@storeID)) as o 
where o.status<>'TRANSFERRED' Group by o.openTime,o.StoreID
union all 
Select dbo.f_GetOrderMealPeriodRpt(o.openTime,o.StoreID) as SaleGroup,'Number Guest Served' as RecordType,sum(o.GuestCount) as value 
From (select openTime,StoreID,status,GuestCount from [dbo].[fnOrderTable](@BeginDate,@EndDate,@storeID)) as o  where o.status<>'TRANSFERRED' 
Group by o.openTime,o.StoreID
union all
Select dbo.f_GetOrderMealPeriodRpt(o.openTime,o.StoreID) as SaleGroup, 'Number Checks' as RecordType, COUNT(p.CheckID) AS value   
From (select openTime,StoreID,status,id,BusinessDate from [dbo].[fnOrderTable](@BeginDate,@EndDate,@storeID)) as O 
inner JOIN (select orderid,StoreID,ID,BusinessDate from [dbo].[fnCheckTable](@BeginDate,@EndDate,@storeID)) as c ON O.id = c.orderid and o.StoreID=c.StoreID 
and O.BusinessDate =C.BusinessDate
inner JOIN (select StoreID,CheckID from [dbo].[fnPaymentTable](@BeginDate,@EndDate,@storeID)) as p ON p.CheckID = c.ID and o.StoreID=p.StoreID
where o.status<>'TRANSFERRED' 
Group by o.openTime,o.StoreID 
union all 
Select dbo.f_GetOrderMealPeriodRpt(o.openTime,o.StoreID) as SaleGroup, 'ProfitTotal' as RecordType, SUM(qty *(price -AdjustedPrice)) as ProfitTotal   
From (select openTime,StoreID,status,ID,BusinessDate  from [dbo].[fnOrderTable](@BeginDate,@EndDate,@storeID)) as O 
inner JOIN (select qty,price,AdjustedPrice,orderid,StoreID,BusinessDate from [dbo].[fnOrderLineItemTable](@BeginDate,@EndDate,@storeID))  OI ON O.ID = OI.orderid and o.StoreID= OI.StoreID and o.BusinessDate= OI.BusinessDate where o.status<>'TRANSFERRED' 
Group by o.openTime,o.StoreID
)  as tabel1 group by SaleGroup,RecordType


declare @saleGroup nvarchar(20)  
declare @RecordType nvarchar(20)  
declare @value decimal(10,2)   
declare @GuestValue decimal(10,2)  
declare @CheckValue decimal(10,2)  
declare @PPA decimal (10,2)  
declare @PCA decimal (10,2)    

DECLARE cur CURSOR FOR select * from #temp where recordType='ProfitTotal' 
  
OPEN cur FETCH NEXT FROM cur INTO @saleGroup, @RecordType,@value   
 WHILE @@FETCH_STATUS = 0 
 BEGIN 
	select @GuestValue=value from #temp where RecordType='Number Guest Served' and saleGroup = @saleGroup 
	select @CheckValue=value from #temp where RecordType='Number Checks' and saleGroup = @saleGroup 
	set @PPA=@value/@GuestValue*1.00 
	set @PCA=@value/@CheckValue*1.00 
	
	insert into #temp values(@saleGroup,'PPA',@PPA)     
	insert into #temp values(@saleGroup,'PCA',@PCA)
 FETCH NEXT FROM cur INTO @saleGroup, @RecordType,@value  
 END    
 CLOSE cur 
 DEALLOCATE cur   
 

declare @NumberGuestServedTotal decimal(10,2)   
declare @numCheckTotal decimal(10,2)   
declare @ProfitTotal decimal(10,2) 
declare @NumberTablesServed decimal(10,2)  
if (select COUNT(*) from #temp)>0
begin
select @NumberGuestServedTotal=SUM(isnull(value,0)) from #temp where RecordType='Number Guest Served'  
select @numCheckTotal=SUM(isnull(value,0)) from #temp where RecordType='Number Checks'  
select @NumberTablesServed=SUM(isnull(value,0)) from #temp where RecordType='Number Tables Served'  
select @ProfitTotal=SUM(isnull(value,0)) from #temp where RecordType='ProfitTotal' 
insert into #temp values('Total','Number Checks',@numCheckTotal) 
insert into #temp values('Total','Number Guest Served',@NumberGuestServedTotal)  
insert into #temp values('Total','Number Tables Served',@NumberTablesServed)  
insert into #temp values('Total','PPA',@ProfitTotal/@NumberGuestServedTotal)  
insert into #temp values('Total','PCA',@ProfitTotal/@numCheckTotal) 
delete from #temp where RecordType='ProfitTotal'  

end
select *,case salegroup when 'Lunch' then 1 when 'DINNER' then 2 when 'Total' then 999 else 3 end OrderCol from #temp  
drop table #temp 


end

GO
