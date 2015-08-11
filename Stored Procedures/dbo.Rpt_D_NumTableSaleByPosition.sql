SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create Procedure [dbo].[Rpt_D_NumTableSaleByPosition]
	@BeginDate datetime,
	@EndDate datetime,
	@storeID nvarchar(200)
AS  
BEGIN
declare @sql nvarchar(max)
SET NOCOUNT ON;

set @sql='SELECT '+@storeID+' StoreID,
		p.Name PositionName,
		SUM(ts.PayRate * ts.HoursWorked)+SUM(ts.OT1HoursWorked * ts.OT1Payrate+ts.OT2HoursWorked  * ts.OT2Payrate)as TotalPay,
		(select SUM((Price-AdjustedPrice)*Qty) from OrderLineItem where BusinessDate=ts.BusinessDate 
		and StoreID=ts.StoreID) as Sales
		From EmployeeTimeSheet as ts
LEFT OUTER JOIN EmployeeJob as ej ON ts.PositionID = ej.PositionID AND ts.EmployeeID = ej.EmployeeID and ts.StoreID=ej.StoreID
LEFT OUTER JOIN Position as p ON ts.PositionID =p.ID and p.StoreID=ts.StoreID
LEFT OUTER JOIN Employee as e ON ts.EmployeeID = e.ID and ts.StoreID=e.StoreID
inner join Store s on s.ID=ts.StoreID 
		where 
		--ts.BusinessDate between '''+CONVERT(nvarchar(20),@BeginDate)+''' and '''+CONVERT(nvarchar(20),@EndDate)+''' 
		 ts.StoreID in ('+@storeID+')
		GROUP BY p.Name,ts.BusinessDate,ts.StoreID'

--select @sql
exec sp_executesql @sql
end
GO
