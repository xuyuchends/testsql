SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE proc [dbo].[Rpt_D_LaborSummaryByStoreByDay]
(
	@BeginDate datetime,
	@EndDate datetime,
	@storeID nvarchar(200)
)
as
declare @sql nvarchar(max)
SET NOCOUNT ON;
set @sql='SELECT s.StoreName StoreName,
		convert(decimal(18,2), SUM(ts.PayRate * case when ts.HoursWorked =0 then DATEDIFF( mi ,ts.TimeIn,GETDATE())/60.0 else ts.HoursWorked end)+SUM(ts.OT1HoursWorked * ts.OT1Payrate+ts.OT2HoursWorked  * ts.OT2Payrate))as TotalPay
		From EmployeeTimeSheet as ts
LEFT OUTER JOIN EmployeeJob as ej ON ts.PositionID = ej.PositionID AND ts.EmployeeID = ej.EmployeeID and ts.StoreID=ej.StoreID
LEFT OUTER JOIN Position as p ON ts.PositionID =p.ID and p.StoreID=ts.StoreID
LEFT OUTER JOIN Employee as e ON ts.EmployeeID = e.ID and ts.StoreID=e.StoreID
inner join Store s on s.ID=ts.StoreID 
		where 
		ts.BusinessDate between '''+CONVERT(nvarchar(20),@BeginDate)+''' and '''+CONVERT(nvarchar(20),@EndDate)+''' 
		and ts.StoreID in ('+@storeID+')
		GROUP BY ts.BusinessDate,s.StoreName'
execute sp_executesql @sql
--select @sql
GO
