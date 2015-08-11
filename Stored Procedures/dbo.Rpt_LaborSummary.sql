SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Rpt_LaborSummary]
	@BeginDate datetime,
	@EndDate datetime,
	@StoreID nvarchar(200)
AS
BEGIN
Declare @Sql as nvarchar(max)
	SET NOCOUNT ON;
set @sql='SELECT s.id as StoreID, s.StoreName as StoreName, convert(nvarchar(10), ts.BusinessDate,101) as BusinessDate,
	SUM(ts.HoursWorked) AS RegHours, 
	SUM(ts.PayRate * ts.HoursWorked) As RegPay,
	SUM(ts.OT1HoursWorked + ts.OT2HoursWorked ) as OTHours, 
	SUM(ts.OT1HoursWorked * ts.OT1Payrate+ts.OT2HoursWorked  * ts.OT2Payrate ) As OTPay 
FROM EmployeeTimeSheet as ts LEFT OUTER JOIN EmployeeJob  as ej
ON ts.PositionID = ej.PositionID AND ts.EmployeeID = ej.EmployeeID and ts.StoreID=ej.StoreID
LEFT OUTER JOIN Employee as e ON ts.EmployeeID = e.ID and ts.StoreID=e.StoreID
 inner join store as s on s.id=ts.storeid 
WHERE ej.WageType = ''HOURLY''  and
 ts.BusinessDate BETWEEN '''+ Convert(nvarchar,@BeginDate,120)+ ''' AND '''+ Convert(nvarchar,@EndDate,120) + '''
 AND ts.StoreID in ('+@storeID+')'
   set @sql +=' GROUP BY s.ID, s.StoreName, convert(nvarchar(10), ts.BusinessDate,101) '
   set @sql+=' order by s.ID, convert(nvarchar(10), ts.BusinessDate,101)'
--select @sql
exec sp_executesql @sql
end
GO
