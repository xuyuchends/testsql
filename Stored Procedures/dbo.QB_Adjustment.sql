SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

---old sql
--ALTER PROCEDURE [dbo].[QB_Adjustment]
--	@EventID [int]
--WITH EXECUTE AS CALLER
--AS
--BEGIN
--	-- SET NOCOUNT ON added to prevent extra result sets from
--	-- interfering with SELECT statements.
--	SET NOCOUNT ON;

--    -- Insert statements for procedure here
--    declare @BeginTime datetime
--    declare @EndTime datetime
--    declare @ProfileID int
--    select @BeginTime=BeginTime,@EndTime=EndTime,@ProfileID=ProfileID from QB_Event where RefNum=@EventID
--	select c.storeid as storeID,c.id as checkID,c.OrderID as orderiD ,c.BusinessDate as businessDate into #temp 
--	from [check] as c inner join QB_ExcludeOrder as qb on qb.OrderID=c.OrderID and c.StoreID=qb.StoreID and c.BusinessDate=qb.BusinessDate
--	where qb.EventID =@eventID
--	--adjustment
--	select @EventID EventID,@BeginTime BeginTime,@EndTime EndTime,SUM(round(isnull(oli.qty*oli.AdjustedPrice,0),2)) Adjustments
--	,am.AdjustName,am.AdjustType,am.QBType,ac.ID QBName,ac1.ID as ClassName,null as Vendor
--	from [QB_AdjustmentMatch] am inner join 
--	(  
--	select AdjustedPrice,abs(qty) qty,case when RecordType='Void' then (select Name from Void where id=AdjustID and StoreID=o.StoreID) 
--  when RecordType='Coupon' then (select Name from Coupon where id=AdjustID and StoreID=o.StoreID)
--  when RecordType='Discount' then (select Name from Discount where id=AdjustID and StoreID=o.StoreID)
--  when RecordType='Comp' then (select Name from Comp where id=AdjustID and StoreID=o.StoreID) 
--  end AdjustName,
--  RecordType,o.StoreID
--  from dbo.[fnOrderLineItemTable1](@BeginTime,@EndTime) o
--  inner join MenuItem mi on o.StoreID=mi.StoreID and mi.MIType not in ('GC', 'IHPYMNT') and MI.ReportDepartment <> 'MODIFIER' 
--  and mi.ID=o.ItemID
--  where o.StoreID in (select StoreID from QB_ProfileMachStore where ProfileID=@ProfileID) and RecordType<>'NONE'
--  and not exists (select * from  QB_ExcludeOrder as qbe where o.OrderID=qbe.OrderID and o.StoreID=qbe.StoreID and o.BusinessDate=qbe.BusinessDate)
--  )  oli 
--  on am.StoreID=oli.StoreID and am.AdjustType=oli.RecordType and am.AdjustName=oli.AdjustName
--  inner join QB_AdjustmentCategory ac on ac.ID=am.QBID
--   inner join QB_AdjustmentCategory ac1 on ac1.ID=am.QBClassID
--	where am. StoreID in (select StoreID from QB_ProfileMachStore where ProfileID=@ProfileID)
--	group by am.AdjustName,am.AdjustType, am.QBType,ac.ID,ac1.ID
	
--	-- GrossSales
--	Union all
	
--	select @EventID EventID,@BeginTime BeginTime,@EndTime EndTime,SUM(Adjustments) Adjustments
--	,am.AdjustName,am.AdjustType,am.QBType,ac.ID QBName,ac1.ID as ClassName ,null
--	from [QB_AdjustmentMatch] am inner join (
--	select SUM(round(isnull(o.qty*o.Price,0),2)) Adjustments, o.StoreID,mi.ReportDepartment Department from dbo.[fnOrderLineItemTable1](@BeginTime,@EndTime)  o
--	 inner join MenuItem mi on mi.ID=o.ItemID and mi.StoreID=o.StoreID  
--	 where o.BusinessDate between @BeginTime and @EndTime and MI.MIType NOT IN ('GC', 'IHPYMNT') and MI.ReportDepartment <> 'MODIFIER' 
--	   and not exists (select * from  QB_ExcludeOrder as qbe where o.OrderID=qbe.OrderID and o.StoreID=qbe.StoreID and o.BusinessDate=qbe.BusinessDate)
--	  group by o.StoreID, mi.ReportDepartment ) oli 
--	on am.StoreID=oli.StoreID and am.AdjustType= 'Gross Sales' and oli.Department=am.AdjustName
--	inner join QB_AdjustmentCategory ac on ac.ID=am.QBID
--	 inner join QB_AdjustmentCategory ac1 on ac1.ID=am.QBClassID
--	where am.StoreID in (select StoreID from QB_ProfileMachStore where ProfileID=@ProfileID)
--	group by am.AdjustName,am.AdjustType, am.QBType,ac.ID,ac1.ID 
	
--	--GCSales
--	Union all
	
--	select @EventID EventID,@BeginTime BeginTime,@EndTime EndTime,SUM(Adjustments) Adjustments
--	,am.AdjustName,am.AdjustType,am.QBType,ac.ID QBName,ac1.ID as ClassName ,null
--	from [QB_AdjustmentMatch] am inner join (
--	select SUM(round(isnull(o.qty*o.Price,0),2)) Adjustments,o.StoreID,mi.Department,o.RecordType from dbo.[fnOrderLineItemTable1](@BeginTime,@EndTime) o
--	 inner join MenuItem mi on mi.ID=o.ItemID and mi.StoreID=o.StoreID and mi.MIType='GC'
--	 where  not exists (select * from  QB_ExcludeOrder as qbe where o.OrderID=qbe.OrderID and o.StoreID=qbe.StoreID and o.BusinessDate=qbe.BusinessDate)
--	  group by o.StoreID,mi.Department,o.RecordType) oli 
--	on am.StoreID=oli.StoreID and am.AdjustType= 'Other Income' and am.AdjustName='Gift Certificate Sales'
--	inner join QB_AdjustmentCategory ac on ac.ID=am.QBID
--	 inner join QB_AdjustmentCategory ac1 on ac1.ID=am.QBClassID
--	where oli.RecordType <> 'VOID' and oli.RecordType <>'comp'  
--	and am.StoreID in(select StoreID from QB_ProfileMachStore where ProfileID=@ProfileID)
--	group by am.AdjustName,am.AdjustType, am.QBType,ac.ID,ac1.ID 
	
--	--Paid In
--	Union all
	
--	select @EventID EventID,@BeginTime BeginTime,@EndTime EndTime,CONVERT(decimal(18,2),SUM(Amount)) Adjustments
--	,am.AdjustName,am.AdjustType,am.QBType,ac.ID QBName,ac1.ID as ClassName ,null
--	from [QB_AdjustmentMatch] am inner join (select SUM(isnull(Amount,0)) Amount,storeid from   dbo.fnPaidInTrxTable1(@BeginTime,@EndTime)
--	where Status='PAID_IN' group by StoreID)  pit 
--	on am.StoreID=pit.StoreID and am.AdjustType= 'Other Income' and am.AdjustName='Paid Ins'
--	inner join QB_AdjustmentCategory ac on ac.ID=am.QBID
--	 inner join QB_AdjustmentCategory ac1 on ac1.ID=am.QBClassID
--	where 
--	 am.StoreID in (select StoreID from QB_ProfileMachStore where ProfileID=@ProfileID)
--	group by am.AdjustName,am.AdjustType, am.QBType,ac.ID,ac1.ID
	
--	--In House Payment Sales
--	Union all
	
--	select @EventID EventID,@BeginTime BeginTime,@EndTime EndTime,sum(Adjustments) Adjustments
--	,am.AdjustName,am.AdjustType,am.QBType,ac.ID QBName,ac1.ID as ClassName ,null
--	from [QB_AdjustmentMatch] am  inner join (
--	select SUM(round(isnull(o.qty*o.Price,0),2)) Adjustments,o.StoreID,mi.Department,o.RecordType from dbo.[fnOrderLineItemTable1](@BeginTime,@EndTime) o
--	 inner join MenuItem mi on mi.ID=o.ItemID and mi.StoreID=o.StoreID and mi.MIType='IHPYMNT'
--	 where not exists (select * from  QB_ExcludeOrder as qbe where o.OrderID=qbe.OrderID and o.StoreID=qbe.StoreID and o.BusinessDate=qbe.BusinessDate)
--	  group by o.StoreID,mi.Department,o.RecordType)  oli
--	on am.StoreID=oli.StoreID and am.AdjustType= 'Other Income' and am.AdjustName='In House Payments'
--	inner join QB_AdjustmentCategory ac on ac.ID=am.QBID
--	 inner join QB_AdjustmentCategory ac1 on ac1.ID=am.QBClassID
--	where oli.RecordType <> 'VOID' and
--	 am.StoreID in (select StoreID from QB_ProfileMachStore where ProfileID=@ProfileID)
--	group by am.AdjustName,am.AdjustType, am.QBType,ac.ID,ac1.ID
	
--	--Advance Payment
--	Union all
--	select @EventID EventID,@BeginTime BeginTime,@EndTime EndTime,sum(p.Amount) Adjustments
--	,am.AdjustName,am.AdjustType,am.QBType,ac.ID QBName,ac1.ID as ClassName ,null
--	from [QB_AdjustmentMatch] am inner join (select sum(isnull(a.Amount,0)) Amount,a.StoreID from dbo.fnPaymentTable1(@BeginTime,@EndTime) a inner join
--	dbo.fnCheckTable1(@BeginTime,@EndTime) b on a.StoreID=b.StoreID and b.ID=a.CheckID
--	where b.FutureOrderAdvPayment='Y' and  not exists (select * from  QB_ExcludeOrder as qbe where b.OrderID=qbe.OrderID and b.StoreID=qbe.StoreID and b.BusinessDate=qbe.BusinessDate)
--	 group by a.StoreID) p on p.StoreID=am.StoreID
--	 inner join QB_AdjustmentCategory ac on ac.ID=am.QBID
--	  inner join QB_AdjustmentCategory ac1 on ac1.ID=am.QBClassID
--	where  am.AdjustType='Other Income' and am.AdjustName='Advance Payments (net)' and
--	am.StoreID in (select StoreID from QB_ProfileMachStore where ProfileID=@ProfileID)
--	group by am.AdjustName,am.AdjustType, am.QBType,ac.ID,ac1.ID 
	
--	--Surcharge Collected
--	Union all
--	select @EventID EventID,@BeginTime BeginTime,@EndTime EndTime,CONVERT(decimal(18,2),sum(tax.TaxAmt)) Adjustments
--	,am.AdjustName,am.AdjustType,am.QBType,ac.ID QBName,ac1.ID as ClassName ,null
--	from [QB_AdjustmentMatch] am inner join (Select Sum(ISNULL((case when ss.SurchargeGuestPays='Y' then TaxAmt else 0 end),0)) TaxAmt,a.StoreID
--From dbo.fnTaxTable1(@BeginTime,@EndTime) A 
--JOIN TaxCategory B on a.TaxCategoryID = b.ID and B.Category='SUR' and  A.Category=B.Category 
--	left outer join StoreSetting as ss on A.StoreID =ss.StoreID
--	where  not exists (select * from  QB_ExcludeOrder as qbe where a.OrderID=qbe.OrderID and a.StoreID=qbe.StoreID and a.BusinessDate=qbe.BusinessDate)
--	group by A.StoreID) tax on am.StoreID=tax.StoreID 
--	inner join QB_AdjustmentCategory ac on ac.ID=am.QBID
--	 inner join QB_AdjustmentCategory ac1 on ac1.ID=am.QBClassID
--	where  am.AdjustType='Other Income' and am.AdjustName='Surcharge Collected' and
--	am.StoreID in(select StoreID from QB_ProfileMachStore where ProfileID=@ProfileID)
--	group by am.AdjustName,am.AdjustType, am.QBType ,ac.ID,ac1.ID

----Paid Out
--	Union all
	
--	select @EventID EventID,@BeginTime BeginTime,@EndTime EndTime,CONVERT(decimal(18,2),SUM(Amount)) Adjustments
--	,am.AdjustName,am.AdjustType,am.QBType,ac.ID QBName,ac1.ID as ClassName ,null
--	from [QB_AdjustmentMatch] am inner join (select SUM(isnull(Amount,0)) Amount,storeid from dbo.fnPaidOutTrxTable1(@BeginTime,@EndTime)
--	group by StoreID ) pit 
--	on am.StoreID=pit.StoreID and am.AdjustType= 'Other Income' and am.AdjustName='Paid Outs'
--	inner join QB_AdjustmentCategory ac on ac.ID=am.QBID
--	 inner join QB_AdjustmentCategory ac1 on ac1.ID=am.QBClassID
--	where 
--	 am.StoreID in (select StoreID from QB_ProfileMachStore where ProfileID=@ProfileID)
--	group by am.AdjustName,am.AdjustType, am.QBType,ac.ID,ac1.ID 
	
	
--	--Previous payments from Future Order
	
--	Union all
--	select @EventID EventID,@BeginTime BeginTime,@EndTime EndTime,CONVERT(decimal(18,2),SUM(Amount)) Adjustments
--	,am.AdjustName,am.AdjustType,am.QBType,ac.ID QBName,ac1.ID as ClassName ,null
--	from [QB_AdjustmentMatch] am inner join (select SUM(ISNULL(p.amount,0)) Amount,p.StoreID
-- From dbo.fnPaymentTable1(@BeginTime,@EndTime) as p
--  inner JOIN dbo.fnCheckTable1(@BeginTime,@EndTime) as c ON p.CheckID = c.ID and p.StoreID=c.StoreID  
-- inner JOIN dbo.fnOrderTable1(@BeginTime,@EndTime) as O ON c.orderid = O.ID  and O.StoreID=c.StoreID and c.BusinessDate=O.BusinessDate
-- where O.FutureOrder = 'Y' and not exists (select * from  QB_ExcludeOrder as qbe where o.ID=qbe.OrderID and o.StoreID=qbe.StoreID and o.BusinessDate=qbe.BusinessDate)	group by p.StoreID) a
-- on a.StoreID=am.StoreID
-- inner join QB_AdjustmentCategory ac on ac.ID=am.QBID
--  inner join QB_AdjustmentCategory ac1 on ac1.ID=am.QBClassID
-- where am.AdjustType= 'Other Income' and am.AdjustName='Previous payments from Future Order' and
--	am.StoreID in (select StoreID from QB_ProfileMachStore where ProfileID=@ProfileID)
--	group by am.AdjustName,am.AdjustType, am.QBType,ac.ID,ac1.ID
	
--	--Tax
--	Union all
--	select @EventID EventID,@BeginTime BeginTime,@EndTime EndTime,CONVERT(decimal(18,2),SUM(TaxAmt)) Adjustments
--	,am.AdjustName,am.AdjustType,am.QBType,ac.ID QBName,ac1.ID as ClassName ,ac2.ID
--	from [QB_AdjustmentMatch] am inner join (Select tc.Name as TaxName, SUM(ISNULL(t.TaxAmt,0)) as TaxAmt,t.StoreID
--			From dbo.fnTaxTable1(@BeginTime,@EndTime) as t inner JOIN TaxCategory tc 
--				ON t.TaxCategoryID = tc.ID and t.Category COLLATE SQL_Latin1_General_CP1_CI_AS=tc.Category and tc.StoreID= t.StoreID
--	Where  t.Category = 'TAX'  and not exists (select * from  QB_ExcludeOrder as qbe where t.OrderID=qbe.OrderID and t.StoreID=qbe.StoreID and t.BusinessDate=qbe.BusinessDate)
--	Group By tc.Name,t.StoreID) tax
--	on am.StoreID=tax.StoreID and am.AdjustName=tax.TaxName
--	inner join QB_AdjustmentCategory ac on ac.ID=am.QBID
--	 inner join QB_AdjustmentCategory ac1 on ac1.ID=am.QBClassID
--	 inner join QB_AdjustmentCategory ac2 on ac2.ID=am.QBVendorID 
--	 where am.AdjustType= 'Tax'  and
--	am.StoreID in (select StoreID from QB_ProfileMachStore where ProfileID=@ProfileID)
--	group by am.AdjustName,am.AdjustType, am.QBType ,ac.ID,ac1.ID,ac2.ID
	
--	Union all
--	--Payment
	
--	select @EventID EventID,@BeginTime BeginTime,@EndTime EndTime,CONVERT(decimal(18,2),SUM(sales)) Adjustments
--	,am.AdjustName,am.AdjustType,am.QBType,ac.ID QBName,ac1.ID as ClassName ,null
--	from [QB_AdjustmentMatch] am inner join (SELECT 
--	SUM(isnull(p.Amount,0)) AS sales,P.StoreID,pm.Name
--	FROM dbo.fnPaymentTable1(@BeginTime,@EndTime) AS p 
--	INNER JOIN PaymentMethod AS pm ON p.MethodID = pm.Name AND pm.StoreID = p.StoreID
--	where
--	not exists (select * from #temp as t where p.CheckID=t.checkID and p.StoreID=t.storeID and t.businessDate=p.BusinessDate)
--	GROUP BY pm.Name,P.StoreID) payment
--	on am.StoreID=payment.StoreID and am.AdjustName=payment.Name
--	inner join QB_AdjustmentCategory ac on ac.ID=am.QBID
--	 inner join QB_AdjustmentCategory ac1 on ac1.ID=am.QBClassID
--	where am.AdjustType= 'Payment'  and
--	am.StoreID in (select StoreID from QB_ProfileMachStore where ProfileID=@ProfileID)
--	group by am.AdjustName,am.AdjustType, am.QBType  ,ac.ID,ac1.ID 
	
--END

---old sql
---new sql
CREATE PROCEDURE [dbo].[QB_Adjustment]
	@EventID [int]
WITH EXECUTE AS CALLER
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   ---adjustment

    -- Insert statements for procedure here
    declare @BeginTime datetime
    declare @EndTime datetime
    declare @ProfileID int
	select @BeginTime=BeginTime,@EndTime=EndTime,@ProfileID=ProfileID from QB_Event where RefNum=@EventID


select @EventID as EventID,@BeginTime BeginTime,@EndTime EndTime, sum(u.Adjustments) as Adjustments,am.AdjustName,am.AdjustType,am.QBType,ac.ID QBName,ac1.ID as ClassName,max(am.QBVendorID) as Vendor
from
(
	select o.OrderID as OrderID,
  o.StoreID as StoreID,
  o.BusinessDate as BusinessDate, 
  round(isnull(o.qty*o.AdjustedPrice,0),2) as Adjustments, 
  RecordTypeTable.name as AdjustName ,
  o.RecordType as AdjustType
  from 
  (
	select id,BusinessDate,StoreID,OrderID,qty,AdjustedPrice,RecordType,ItemID,AdjustID from OrderLineItem 	where    BusinessDate between @BeginTime and @EndTime  and status='CLOSE' and RecordType<>'NONE'
	union all 
	select id,BusinessDate,StoreID,OrderID,qty,AdjustedPrice,RecordType,ItemID,AdjustID from  OrderLineItemArchive  	where  BusinessDate between @BeginTime and @EndTime  and status='CLOSE' and RecordType<>'NONE'
	) as o

  inner join MenuItem as  mi on o.StoreID=mi.StoreID and mi.MIType not in ('GC', 'IHPYMNT') and MI.ReportDepartment <> 'MODIFIER'  and mi.ID=o.ItemID
  left outer join 
  (
	select ID as ID,name as name ,storeID as storeID,'Void' as RecordType from void
	union all
	select ID as ID,name as name ,storeID as storeID,'Coupon' as RecordType from Coupon
	union all
	select ID as ID,name as name ,storeID as storeID,'Discount' as RecordType from Discount
	union all
	select ID as ID,name as name ,storeID as storeID,'Comp' as RecordType from Comp
) as RecordTypeTable on o.AdjustID=RecordTypeTable.ID and RecordTypeTable.storeID=o.StoreID

union all

-- GrossSales
	select o.OrderID as OrderID,
	o.StoreID as StoreID,
	o.BusinessDate as BusinessDate,
	 round(isnull(o.qty*o.Price,0),2) Adjustments, 
	 mi.ReportDepartment as AdjustName,
	 'Gross Sales'as AdjustType   
	 from 
  (
	select id,BusinessDate,StoreID,OrderID,qty,ItemID,Price from OrderLineItem 	where    BusinessDate between @BeginTime and @EndTime  and status='CLOSE'
	union all
	select id,BusinessDate,StoreID,OrderID,qty,ItemID,Price from  OrderLineItemArchive  	where  BusinessDate between @BeginTime and @EndTime  and status='CLOSE'
	) as o
	 inner join MenuItem mi on mi.ID=o.ItemID and mi.StoreID=o.StoreID  
	 where o.BusinessDate between @BeginTime and @EndTime and MI.MIType NOT IN ('GC', 'IHPYMNT') and MI.ReportDepartment <> 'MODIFIER' 


union all	 
	 ----GCSales
	 	select 
	 	o.OrderID as OrderID,
	o.StoreID as StoreID,
	o.BusinessDate as BusinessDate,
	round(isnull(o.qty*o.Price,0),2) as  Adjustments,
	'Gift Certificate Sales' as AdjustName,
	'Other Income' as AdjustType
	from
	  (
	select id,BusinessDate,StoreID,OrderID,qty,ItemID,Price,RecordType from OrderLineItem 	where    BusinessDate between @BeginTime and @EndTime  and status='CLOSE' and RecordType not in ('VOID','COMP')
	union all
	select id,BusinessDate,StoreID,OrderID,qty,ItemID,Price,RecordType from  OrderLineItemArchive  	where  BusinessDate between @BeginTime and @EndTime  and status='CLOSE' and RecordType not in ('VOID','COMP')
	) as o
	 inner join MenuItem mi on mi.ID=o.ItemID and mi.StoreID=o.StoreID 
	 where  mi.MIType='GC'

union all
----Paid In
select 
	-99999 as orderID,
	pit.StoreID as StoreID,
	pit.BusinessDate as BusinessDate,
	CONVERT(decimal(18,2),isnull(Amount,0)) as Adjustments,
	'Other Income' as AdjustType,
	'Paid Ins' as AdjustName
	 from  
  (
	select id,BusinessDate,StoreID,Amount from PaidInTrx 	where    BusinessDate between @BeginTime and @EndTime  and Status='PAID_IN' 
	union all
	select id,BusinessDate,StoreID ,Amount from  PaidInTrxArchive  	where  BusinessDate between @BeginTime and @EndTime and Status='PAID_IN' 
	) as pit 


union all	
	--In House Payment Sales
	select 
	o.OrderID as OrderID,
	o.StoreID as StoreID,
	o.BusinessDate as BusinessDate,
	round(isnull(o.qty*o.Price,0),2) as Adjustments,
	'In House Payments' as AdjustName,
	'Other Income' as AdjustType
	 from 
	  (
	select id,BusinessDate,StoreID,OrderID,qty,ItemID,Price,RecordType from OrderLineItem 	where    BusinessDate between @BeginTime and @EndTime  and status='CLOSE' and RecordType <> 'VOID'
	union all
	select id,BusinessDate,StoreID,OrderID,qty,ItemID,Price,RecordType from  OrderLineItemArchive  	where  BusinessDate between @BeginTime and @EndTime  and status='CLOSE' and RecordType <> 'VOID'
	) as o
	 inner join MenuItem mi on mi.ID=o.ItemID and mi.StoreID=o.StoreID and mi.MIType='IHPYMNT'


union all
	 ---Advance Payment
	select 
	b.OrderID as OrderID,
	b.StoreID as StoreID,
	b.BusinessDate as BusinessDate,
	isnull(a.Amount,0) as Adjustments,
	'Advance Payments (net)' as AdjustName,
	'Other Income' as AdjustType
	from 
	(
	select Amount,StoreID,CheckID,BusinessDate from Payment 	where    BusinessDate between @BeginTime and @EndTime  and status='CLOSED'
	union all
	select Amount,StoreID,CheckID,BusinessDate from  PaymentArchive  	where  BusinessDate between @BeginTime and @EndTime  and status='CLOSED'
	) as a
	inner join
	(
	select id,BusinessDate,StoreID,OrderID,FutureOrderAdvPayment from [Check] 	where FutureOrderAdvPayment='Y' and   BusinessDate between @BeginTime and @EndTime  and status='CLOSED'
	union all
	select id,BusinessDate,StoreID,OrderID,FutureOrderAdvPayment from  CheckArchive  	where FutureOrderAdvPayment='Y' and   BusinessDate between @BeginTime and @EndTime  and status='CLOSED'
	) as b
	on a.StoreID=b.StoreID and b.ID=a.CheckID and a.BusinessDate=b.BusinessDate



union all
	--Surcharge Collected
		Select 
	a.OrderID as OrderID,
	a.StoreID as StoreID,
	a.BusinessDate as BusinessDate,
	ISNULL((case when ss.SurchargeGuestPays='Y' then TaxAmt else 0 end),0) as Adjustments,
	'Surcharge Collected' as AdjustName,
	'Other Income' as AdjustType
	From 
	(
	select OrderID,StoreID,BusinessDate,TaxAmt,TaxCategoryID,Category  from Tax 	where     BusinessDate between @BeginTime and @EndTime  and status='VALID'
	union all
	select OrderID,StoreID,BusinessDate,TaxAmt,TaxCategoryID,Category from  TaxArchive  	where     BusinessDate between @BeginTime and @EndTime  and status='VALID'
	) as a
	
	JOIN TaxCategory B on a.TaxCategoryID = b.ID and  A.Category=B.Category and b.StoreID=a.StoreID
	left outer join StoreSetting as ss on A.StoreID =ss.StoreID
	where  B.Category='SUR'

	
union all
	--Paid Out
	select 
	-99999 as OrderID,
	pit.StoreID as StoreID,
	pit.BusinessDate as BusinessDate,
	CONVERT(decimal(18,2),isnull(Amount,0)) as Adjustments ,
	'Paid Outs' as AdjustName,
	'Other Income' as AdjustType
	from 	(
	select StoreID,BusinessDate,Amount  from PaidOutTrx 	where     BusinessDate between @BeginTime and @EndTime  
	union all
	select StoreID,BusinessDate,Amount from  PaidOutTrxArchive  	where     BusinessDate between @BeginTime and @EndTime 
	) as pit


union all
	--Previous payments from Future Order
		select 
	o.ID as OrderID,
	o.StoreID as StoreID,
	o.BusinessDate as BusinessDate,
	CONVERT(decimal(18,2),ISNULL(p.amount,0)) as Adjustments,
	'Previous payments from Future Order' as AdjustName,
	 'Other Income' as AdjustType
 From
 (
	select Amount,StoreID,CheckID,BusinessDate from Payment 	where    BusinessDate between @BeginTime and @EndTime  and status='CLOSED'
	union all
	select Amount,StoreID,CheckID,BusinessDate from  PaymentArchive  	where  BusinessDate between @BeginTime and @EndTime  and status='CLOSED'
	) as p
  inner JOIN 
 (
	select id,BusinessDate,StoreID,OrderID,FutureOrderAdvPayment from [Check] 	 where   BusinessDate between @BeginTime and @EndTime  and status='CLOSED'
	union all
	select id,BusinessDate,StoreID,OrderID,FutureOrderAdvPayment from  CheckArchive  where    BusinessDate between @BeginTime and @EndTime  and status='CLOSED'
	) as c
  ON p.CheckID = c.ID and p.StoreID=c.StoreID  and p.BusinessDate=c.BusinessDate
 inner JOIN 
 (
	select id,BusinessDate,StoreID from [Order] 	where    BusinessDate between @BeginTime and @EndTime  and status='CLOSE' and FutureOrder = 'Y' 
	union all
	select id,BusinessDate,StoreID from  OrderArchive  	where  BusinessDate between @BeginTime and @EndTime  and status='CLOSE' and FutureOrder = 'Y' 
	) as o
 ON c.orderid = O.ID  and O.StoreID=c.StoreID and c.BusinessDate=O.BusinessDate

 
 union all
 --Tax
 	Select
	t.OrderID as OrderID,
	t.StoreID as StoreID,
	t.BusinessDate as BusinessDate,
	CONVERT(decimal(18,2),ISNULL(t.TaxAmt,0)) as Adjustments,
	tc.Name as  AdjustName,
	'Tax' as AdjustType
	From 
	(
	select OrderID,StoreID,BusinessDate,TaxAmt,TaxCategoryID,Category  from Tax 	where     BusinessDate between @BeginTime and @EndTime  and status='VALID' and Category = 'TAX'  
	union all
	select OrderID,StoreID,BusinessDate,TaxAmt,TaxCategoryID,Category from  TaxArchive  	where     BusinessDate between @BeginTime and @EndTime  and status='VALID'  and Category = 'TAX'  
	) as t
	inner JOIN TaxCategory tc ON t.TaxCategoryID = tc.ID and t.Category COLLATE SQL_Latin1_General_CP1_CI_AS=tc.Category and tc.StoreID= t.StoreID

union all
	--Payment
		SELECT 
	c.OrderID as OrderID,
	p.StoreID as StoreID,
	p.BusinessDate as BusinessDate,
	CONVERT(decimal(18,2),isnull(p.Amount,0)) AS Adjustments,
	pm.Name as AdjustName,
	'Payment' as AdjustType
	FROM 
	(
	select Amount,StoreID,CheckID,BusinessDate,MethodID from Payment 	where    BusinessDate between @BeginTime and @EndTime  and status='CLOSED'
	union all
	select Amount,StoreID,CheckID,BusinessDate,MethodID from  PaymentArchive  	where  BusinessDate between @BeginTime and @EndTime  and status='CLOSED'
	) as p
	 
	INNER JOIN PaymentMethod AS pm ON p.MethodID = pm.Name AND pm.StoreID = p.StoreID
	inner join 
	(
	select id,BusinessDate,StoreID,OrderID,FutureOrderAdvPayment from [Check] where	 BusinessDate between @BeginTime and @EndTime  and status='CLOSED'
	union all
	select id,BusinessDate,StoreID,OrderID,FutureOrderAdvPayment from  CheckArchive where  BusinessDate between @BeginTime and @EndTime  and status='CLOSED'
	) as c
	on p.StoreID=c.StoreID and p.CheckID=c.ID and p.BusinessDate=c.BusinessDate
) as u
inner join QB_AdjustmentMatch as am on am.AdjustType=  u.AdjustType and am.AdjustName=u.AdjustName and am.StoreID=u.StoreID
inner join QB_AdjustmentCategory ac on ac.ID=am.QBID
inner join QB_AdjustmentCategory ac1 on ac1.ID=am.QBClassID
inner join QB_ProfileMachStore as pms on pms.StoreID=u.StoreID
where pms.ProfileID=@ProfileID
and not exists (select * from  QB_ExcludeOrder as qbe where u.OrderID=qbe.OrderID and u.StoreID=qbe.StoreID and u.BusinessDate=qbe.BusinessDate)
group by am.AdjustName,am.AdjustType, am.QBType,ac.ID,ac1.ID
	
END
GO
