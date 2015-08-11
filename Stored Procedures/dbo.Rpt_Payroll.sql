SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rpt_Payroll]
	@BeginDate datetime,
	@EndDate datetime,
	@StoreID int
as 
declare @OTHoursType as int
select @OTHoursType  = OTHoursType from StoreSetting where StoreID =@StoreID

SELECT SUM(et.HoursWorked) AS HoursWorked,
		et.PayRate as PayRate,  
		et.PositionID as PositionID,
		--et.EmployeeID as EmployeeID, 
		e.FirstName + ' '+ e.LastName as EmployeeName, 
		e.PayrollID as PayrollID,
		p.Name as Positionname,
		ej.WageType as WageType,
		--@OTHoursType as OvertimeType,
		et.OT1Payrate as OT1Payrate,
		et.OT2Payrate as OT2Payrate,
		ISNULL(eow.OtherWage,0) as  OtherWage,
		ISNULL(SUM(et.TipDeclared),0) as TipDeclared,
		ISNULL(SUM(et.OT1HoursWorked* et.OT1Payrate+et.OT2HoursWorked* et.OT2Payrate),0) as OvertimeRate, 
		ISNULL(SUM(et.OT1HoursWorked+et.OT2HoursWorked),0) AS OTHours, 
		ISNULL(sum(et.IndirectTipsDeclared),0) as IndirectTips, 
		(CASE @OTHoursType WHEN 1 THEN convert(varchar, (SUM(et.OT1HoursWorked+et.OT2HoursWorked)))
			WHEN 2 THEN (CONVERT(varchar,(sum(et.OT1HoursWorked)))+'/'+CONVERT(varchar,(sum(et.OT2HoursWorked)))) END)as OTHoursD,
		(CASE @OTHoursType WHEN 1 THEN et.OT1Payrate WHEN 2 THEN (CONVERT(varchar,et.OT1Payrate)+'/'+CONVERT(varchar,et.OT2Payrate)) END)as OTRateD
FROM Position as p RIGHT OUTER JOIN EmployeeTimeSheet as et ON p.id = et.PositionID and p.StoreID=et.StoreID
LEFT OUTER JOIN Employee as e ON et.EmployeeID = e.id and et.StoreID=e.StoreID
LEFT OUTER JOIN EmployeeJob as ej ON et.EmployeeID = ej.EmployeeID  and et.StoreID=ej.StoreID AND et.PositionID = ej.PositionID 
LEFT OUTER JOIN (
	select EmployeeID as EmployeeID,
	storeID, 
	sum(OtherWage) as OtherWage
	from EmployeeOtherWage
	where businessdate between @BeginDate and @EndDate
	group by storeID,EmployeeID
)as eow
ON e.ID  = eow.EmployeeID  and e.StoreID =eow.StoreID

WHERE 
e.HasPayrollReport = 1 
and CONVERT(varchar(10), et.TimeIn, 120 )  between @BeginDate and @EndDate
and p.StoreID=@StoreID
GROUP BY 
et.PositionID, et.PayRate,e.FirstName + ' '+ e.LastName, 
p.Name , ej.wagetype ,et.OT1Payrate,et.OT2Payrate,eow.OtherWage,	e.PayrollID 
--e.PayrollID , et.EmployeeID,
GO
