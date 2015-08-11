SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Rpt_LaborMetricsAll]
	@BeginDate datetime,
	@EndDate datetime,
	@StoreID varchar(200)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	
	
	-- interfering with SELECT statements.
Declare @Sql as nvarchar(max)
	SET NOCOUNT ON;

 set @sql='
 if exists (select * from tempdb.dbo.sysobjects where id = object_id(N''tempdb..#tempOrder'') and type=''U'')
drop table #tempOrder
select * into #tempOrder from [dbo].[fnOrderTable]('''+ Convert(nvarchar,@BeginDate,120)+ ''','''+ Convert(nvarchar,@EndDate,120) + ''','''+@storeID+''')

if exists (select * from tempdb.dbo.sysobjects where id = object_id(N''tempdb..#tempOrderLineItem'') and type=''U'')
drop table #tempOrderLineItem 
select * into #tempOrderLineItem from [dbo].[fnOrderLineItemTable]('''+ Convert(nvarchar,@BeginDate,120)+ ''','''+ Convert(nvarchar,@EndDate,120) + ''','''+@storeID+''')

if exists (select * from tempdb.dbo.sysobjects where id = object_id(N''tempdb..#SumGuestCount'') and type=''U'')
drop table #SumGuestCount
create table #SumGuestCount
(
GuestCount int ,
StoreID int,
BusinessDate datetime
)
insert into #SumGuestCount	select SUM(GuestCount),StoreID,BusinessDate from #tempOrder group by StoreID,BusinessDate

if exists (select * from tempdb.dbo.sysobjects where id = object_id(N''tempdb..#SumNetSales'') and type=''U'')
drop table #SumNetSales
create table #SumNetSales
(
NetSales decimal(18,2) ,
StoreID int,
BusinessDate datetime
)
insert into #SumNetSales select SUM((Price-AdjustedPrice)*Qty),StoreID,BusinessDate from #tempOrderLineItem group by StoreID,BusinessDate


 select s.StoreName,s.ID,Convert(varchar(12),ts.BusinessDate,101) as BusinessDate,
	SUM(ts.HoursWorked)+SUM(ts.OT1HoursWorked+ts.OT2HoursWorked) as TotalHours,
	SUM(ts.PayRate * ts.HoursWorked)+SUM(ts.OT1HoursWorked * ts.OT1Payrate+ts.OT2HoursWorked  * ts.OT2Payrate)as TotalPay,
    (select SUM(NetSales) from #SumNetSales where StoreID=s.ID) as NetSales,      
    (select SUM(GuestCount) from #SumGuestCount where StoreID=s.ID) as GuestCount 
   FROM  EmployeeTimeSheet as ts
LEFT OUTER JOIN EmployeeJob as ej ON ts.PositionID = ej.PositionID AND ts.EmployeeID = ej.EmployeeID and ts.StoreID=ej.StoreID
LEFT OUTER JOIN Position as p ON ts.PositionID =p.ID and p.StoreID=ts.StoreID
LEFT OUTER JOIN Employee as e ON ts.EmployeeID = e.ID and ts.StoreID=e.StoreID
inner join Store s on s.ID=ts.StoreID 
WHERE ej.WageType = ''HOURLY'' and e.HasPayrollReport = 1 and ts.BusinessDate BETWEEN '''+ Convert(nvarchar,@BeginDate,120)+ ''' AND '''+ Convert(nvarchar,@EndDate,120) + '''
and ts.StoreID in ('+@StoreID+')'
set @sql +=' group by s.StoreName,s.ID,ts.BusinessDate'
--select @sql
exec sp_executesql @sql
END
GO
