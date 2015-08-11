SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Rpt_TipIncomeAll]
 @BeginDate  datetime,
 @EndDate  datetime,
 @StoreID int
AS
BEGIN
declare @ModuleValue as nvarchar(50)
declare @sqlEMPLOYEE_CC_SALES2 as nvarchar(max)
SET NOCOUNT ON;

if exists (select * from tempdb.dbo.sysobjects where id = object_id(N'tempdb..#tempCheck') and type='U')
drop table #tempCheck
select * into #tempCheck from [dbo].[fnCheckTable](@BeginDate,@EndDate,@StoreID)

if exists (select * from tempdb.dbo.sysobjects where id = object_id(N'tempdb..#tempPayment') and type='U')
drop table #tempPayment
select * into #tempPayment from [dbo].[fnPaymentTable](@BeginDate,@EndDate,@StoreID)

 set @ModuleValue= dbo.fn_CheckIfModuleInstalledAndEnabled('GIFT_CERTIFICATE',@StoreID)

if exists (select * from tempdb.dbo.sysobjects where id = object_id(N'tempdb..#EMPLOYEE_CC_SALES2') and type='U')
drop table #EMPLOYEE_CC_SALES2
 create table #EMPLOYEE_CC_SALES2
( 
TotalCCSales    money, 
EmployeeID   int ,
CCTips money
)
 if Upper(@ModuleValue)='Y'
	begin
		insert into #EMPLOYEE_CC_SALES2(TotalCCSales,EmployeeID,CCTips)
			SELECT SUM(p.Amount) AS TotalCCSales, 
				c.EmployeeID as EmployeeID, 
				SUM(p.Tip + p.Gratuity) AS CCTips 
			FROM #tempPayment as p INNER JOIN #tempCheck as c ON p.CheckID = c.ID and p.StoreID=c.StoreID and p.BusinessDate=c.BusinessDate
			WHERE (convert(datetime,(CONVERT(nvarchar(12), CONVERT(datetime,c.SaleTime) , 23)+' 00:00:00')) between  @BeginDate AND @EndDate ) AND p.StoreID=@StoreID and
			exists (select * from PaymentMethod as pm where p.MethodID =pm.Name 
			and (pm.PaymentType='CREDIT_CARD' or pm.name='GC'))
			GROUP BY c.EmployeeID
	end
else
	begin
		insert into #EMPLOYEE_CC_SALES2(TotalCCSales,EmployeeID,CCTips)
			SELECT SUM(p.Amount) AS TotalCCSales, 
				c.EmployeeID as EmployeeID, 
				SUM(p.Tip + p.Gratuity) AS CCTips
			FROM #tempPayment as p INNER JOIN #tempCheck as c ON p.CheckID = c.ID  and p.StoreID=c.StoreID and p.BusinessDate=c.BusinessDate
			WHERE (convert(datetime,(CONVERT(nvarchar(12), CONVERT(datetime,c.SaleTime) , 23)+' 00:00:00')) between  @BeginDate AND @EndDate ) AND  c.StoreID=@StoreID and 
				exists (select * from PaymentMethod as pm where p.MethodID =pm.Name 
				and pm.PaymentType='CREDIT_CARD')
			GROUP BY c.EmployeeID
	end
	
if exists (select * from tempdb.dbo.sysobjects where id = object_id(N'tempdb..#EMPLOYEE_SALES') and type='U')
drop  table #EMPLOYEE_SALES
 create table #EMPLOYEE_SALES
( 
TotalCCSales    money, 
EmployeeID   int 
)

insert into #EMPLOYEE_SALES(TotalCCSales,EmployeeID)
SELECT SUM(p.Amount) AS TotalSales, 
c.EmployeeID as EmployeeID
FROM #tempCheck as c INNER JOIN 
#tempPayment as p ON c.ID = p.CheckID and c.StoreID=p.StoreID and p.BusinessDate=c.BusinessDate
WHERE(convert(datetime,(CONVERT(nvarchar(12), CONVERT(datetime,c.SaleTime) , 23)+' 00:00:00')) between  @BeginDate AND @EndDate ) and c.StoreID=@StoreID 
GROUP BY c.EmployeeID
if exists (select * from tempdb.dbo.sysobjects where id = object_id(N'tempdb..#EMPLOYEE_TIPS') and type='U')
drop  table #EMPLOYEE_TIPS
create table #EMPLOYEE_TIPS
( 
EmployeeID   int ,
TipDeclared    money, 
IndirectTipsDeclared    money, 
TipPoolContribution    money, 
CashTipsDeclared    money, 
dateIn    datetime
)
insert into #EMPLOYEE_TIPS(EmployeeID,TipDeclared,IndirectTipsDeclared,TipPoolContribution,CashTipsDeclared,dateIn)
SELECT et.EmployeeID as EmployeeID, 
	sum(et.TipDeclared) as TipDeclared, 
	sum(IndirectTipsDeclared) as IndirectTipsDeclared, 
	sum(TipPoolContribution) as TipPoolContribution, 
	sum(et.CashTipsDeclared) as CashTipsDeclared, 
	CONVERT(DATETIME, et.TimeIn, 102)  as dateIn 
FROM EmployeeTimeSheet as et
WHERE (convert(datetime,(CONVERT(nvarchar(12), CONVERT(datetime,et.TimeIn) , 23)+' 00:00:00')) between  @BeginDate AND @EndDate )  and et.StoreID=@StoreID
GROUP BY et.EmployeeID, CONVERT(DATETIME, et.TimeIn, 102)

SELECT  
	e.FirstName + ' '+ e.LastName as EmployeeName,
	e.PayrollID as PayrollID,
	Isnull(es2.TotalCCSales ,0) as TotalCCSales,
	Isnull(es2.CCTips,0) as CCTips,
	Isnull(es.TotalCCSales,0) as TotalSales,
	Isnull(sum(et.TipPoolContribution ),0) as TipPoolContribution, 
	Isnull(SUM(et.TipDeclared),0) AS TipDeclared,
	Isnull(sum(et.CashTipsDeclared),0) as CashTipsDeclared,
	Isnull(sum(et.IndirectTipsDeclared),0) as IndirectTipsDeclared
FROM #EMPLOYEE_SALES as es 
	FULL OUTER JOIN #EMPLOYEE_CC_SALES2 es2 ON es.EmployeeID = es2.EmployeeID
	left OUTER JOIN Employee as e ON es.EmployeeID = e.ID
	left OUTER JOIN #EMPLOYEE_TIPS as et ON et.EmployeeID = es.EmployeeID
WHERE e.IsShowTipInTime=1  and e.StoreID=@StoreID  

--and et.EmployeeID is not null
GROUP BY e.FirstName + ' '+ e.LastName, es2.TotalCCSales, es2.CCTips , es.TotalCCSales, e.FirstName, e.LastName, e.PayrollID
having Isnull(es2.TotalCCSales ,0)+Isnull(es2.CCTips,0)+Isnull(es.TotalCCSales,0)+Isnull(sum(et.TipPoolContribution ),0)+Isnull(SUM(et.TipDeclared),0)+Isnull(sum(et.CashTipsDeclared),0)+Isnull(sum(et.IndirectTipsDeclared),0)<>0

drop table #tempCheck
drop table #tempPayment
drop table #EMPLOYEE_CC_SALES2
drop table #EMPLOYEE_SALES
drop table #EMPLOYEE_TIPS
end
GO
