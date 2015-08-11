SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Rpt_EmployeeTimeslip]
	@BeginDate datetime,
	@EndDate datetime,
	@EmployeeID int,
	@StoreID nvarchar(200)
	
AS
BEGIN
Declare @Sql as nvarchar(max)
	SET NOCOUNT ON;
set @sql='SELECT     s.StoreName, p.Name AS PositionName, e.FirstName +'' ' + '''+ e.LastName AS employeeName, 
 CONVERT(varchar(12) , ts.TimeIn, 108 ) TimeIn, 
 CONVERT(varchar(12) , ts.TimeOut, 108 ) TimeOut,  
SUM(ts.HoursWorked) AS RegHours,  BusinessDate, 
                      SUM(ts.PayRate * ts.HoursWorked) AS RegPay, SUM(ts.OT1HoursWorked + ts.OT2HoursWorked) AS OTHours, 
                      SUM(ts.OT1HoursWorked * ts.OT1Payrate + ts.OT2HoursWorked * ts.OT2Payrate) AS OTPay
FROM         EmployeeTimeSheet AS ts LEFT OUTER JOIN
                      EmployeeJob AS ej ON ts.PositionID = ej.PositionID AND ts.EmployeeID = ej.EmployeeID AND ts.StoreID = ej.StoreID LEFT OUTER JOIN
                      Employee AS e ON ts.EmployeeID = e.ID AND ts.StoreID = e.StoreID INNER JOIN
                      Position AS p ON p.ID = ts.PositionID AND p.StoreID = ts.StoreID INNER JOIN
                      Store AS s ON s.ID = ts.StoreID
WHERE     ej.WageType = ''HOURLY'' AND e.HasPayrollReport = 1 AND ts.BusinessDate BETWEEN '''+ Convert(nvarchar,@BeginDate,120)+ ''' AND '''+ Convert(nvarchar,@EndDate,120) + '''
and s.ID in (' + @StoreID+')'
if (@EmployeeID>0)
begin
	set @sql +=' AND e.ID='+Convert(nvarchar,@EmployeeID)
end
   set @sql +=' GROUP BY ts.BusinessDate,s.StoreName, p.Name, e.FirstName +'' ' + '''+ e.LastName,ts.TimeIn, ts.TimeOut'
   set @sql +=' ORDER BY s.StoreName, p.Name, e.FirstName +'' ' + '''+ e.LastName,ts.TimeIn, ts.TimeOut'
--select  @sql
exec sp_executesql @sql
end
GO
