SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Rpt_LaborByJob]
	@BeginDate datetime,
	@EndDate datetime,
	@StoreID nvarchar(200)
AS
BEGIN
Declare @Sql as nvarchar(max)
	SET NOCOUNT ON;
set @sql='select s.id as storeID, s.StoreName as StoreName, p.Name as PositionName,p.id as PositionID,
	SUM(ts.HoursWorked) AS RegHours, 
	SUM(ts.PayRate * ts.HoursWorked) As RegPay,
	SUM(ts.OT1HoursWorked + ts.OT2HoursWorked ) as OTHours, 
	SUM(ts.OT1HoursWorked * ts.OT1Payrate+ts.OT2HoursWorked  * ts.OT2Payrate ) As OTPay 
FROM EmployeeTimeSheet as ts LEFT OUTER JOIN EmployeeJob  as ej
	ON ts.PositionID = ej.PositionID AND ts.EmployeeID = ej.EmployeeID and ts.StoreID=ej.StoreID
LEFT OUTER JOIN Employee as e ON ts.EmployeeID = e.ID and ts.StoreID=e.StoreID
inner join Position as p on p.ID=ts.PositionID and p.StoreID=ts.StoreID
inner join Store as s on s.ID =ts.storeID
WHERE ej.WageType = ''HOURLY''  and 
	ts.BusinessDate BETWEEN '''+ Convert(nvarchar,@BeginDate,120)+ ''' AND '''+ Convert(nvarchar,@EndDate,120) + '''
and ts.StoreID in ('+@StoreID+')'
   set @sql +=' GROUP BY s.id,s.StoreName ,p.id,p.Name'
   set @sql +=' Order BY s.id,s.StoreName ,p.id,p.Name'
--select  @sql
exec sp_executesql @sql
end


GO
