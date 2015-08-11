SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[fn_IsBalance]
 
 (
	@eventID int
 )  
 
 RETURNS nvarchar(20)
 
 AS  

 BEGIN 
 	 declare @retValue nvarchar(20)
 	 declare @sumValue decimal(18,2)
 	   declare @BeginTime datetime
    declare @EndTime datetime
    declare @ProfileID int
    select @BeginTime=BeginTime,@EndTime=EndTime,@ProfileID=ProfileID from QB_Event where RefNum=@eventID
	
	--adjustment\
		select @sumValue =SUM(Adjustments)  from (
	
	select @eventID EventID,@BeginTime BeginTime,@EndTime EndTime,CONVERT(decimal(18,2), isnull(SUM(oli.qty*oli.AdjustedPrice*(case when am.QBType='DEBIT' then -1 else 1 end)),0)) Adjustments
	,am.AdjustName,am.AdjustType,am.QBType,ac.ID QBName,ac1.ID as ClassName,null as Vendor
	from [QB_AdjustmentMatch] am inner join 
	(  
	select AdjustedPrice,abs(qty) qty,case when RecordType='Void' then (select Name from Void where id=AdjustID and StoreID=o.StoreID) 
  when RecordType='Coupon' then (select Name from Coupon where id=AdjustID and StoreID=o.StoreID)
  when RecordType='Discount' then (select Name from Discount where id=AdjustID and StoreID=o.StoreID)
  when RecordType='Comp' then (select Name from Comp where id=AdjustID and StoreID=o.StoreID) 
  end AdjustName
  
  ,
  RecordType,o.StoreID
  from dbo.[fnOrderLineItemTable1](@BeginTime,@EndTime) o
  inner join MenuItem mi on o.StoreID=mi.StoreID and mi.MIType not in ('GC', 'IHPYMNT') and MI.ReportDepartment <> 'MODIFIER' 
  and mi.ID=o.ItemID
  where o.StoreID in (select StoreID from QB_ProfileMachStore where ProfileID=@ProfileID) 
  and RecordType<>'NONE' and o.OrderID not in (select orderID from ExcludeOrder)
  --and RecordType in (select EventDataType from QB_EventType where RefNum=@eventID)
  )  oli 
  on am.StoreID=oli.StoreID and am.AdjustType=oli.RecordType and am.AdjustName=oli.AdjustName
  inner join QB_AdjustmentCategory ac on ac.ID=am.QBID
   inner join QB_AdjustmentCategory ac1 on ac1.ID=am.QBClassID
	where am. StoreID in (select StoreID from QB_ProfileMachStore where ProfileID=@ProfileID)
	--and am.AdjustType in (select EventDataType from QB_EventType where RefNum=@eventID)
	group by am.AdjustName,am.AdjustType, am.QBType,ac.ID,ac1.ID
	
	-- GrossSales
	Union all
	
	select @eventID EventID,@BeginTime BeginTime,@EndTime EndTime,CONVERT(decimal(18,2),isnull(SUM(Adjustments*(case when am.QBType='DEBIT' then -1 else 1 end)),0)) Adjustments
	,am.AdjustName,am.AdjustType,am.QBType,ac.ID QBName,ac1.ID as ClassName ,null
	from [QB_AdjustmentMatch] am inner join (
	select SUM(o.qty*o.Price) Adjustments, o.StoreID,mi.ReportDepartment Department from dbo.[fnOrderLineItemTable1](@BeginTime,@EndTime)  o
	 inner join MenuItem mi on mi.ID=o.ItemID and mi.StoreID=o.StoreID  
	 where o.BusinessDate between @BeginTime and @EndTime and MI.MIType NOT IN ('GC', 'IHPYMNT')
	  and MI.ReportDepartment <> 'MODIFIER'    and o.OrderID not in (select orderID from ExcludeOrder)
	  group by o.StoreID, mi.ReportDepartment ) oli 
	on am.StoreID=oli.StoreID and am.AdjustType= 'Gross Sales' and oli.Department=am.AdjustName
	inner join QB_AdjustmentCategory ac on ac.ID=am.QBID
	 inner join QB_AdjustmentCategory ac1 on ac1.ID=am.QBClassID
	where am.StoreID in (select StoreID from QB_ProfileMachStore where ProfileID=@ProfileID)
	--and am.AdjustType in (select EventDataType from QB_EventType where RefNum=@eventID)
	group by am.AdjustName,am.AdjustType, am.QBType,ac.ID,ac1.ID 
	
	--GCSales
	Union all
	
	select @eventID EventID,@BeginTime BeginTime,@EndTime EndTime,CONVERT(decimal(18,2),isnull(SUM(Adjustments*(case when am.QBType='DEBIT' then -1 else 1 end)),0)) Adjustments
	,am.AdjustName,am.AdjustType,am.QBType,ac.ID QBName,ac1.ID as ClassName ,null
	from [QB_AdjustmentMatch] am inner join (
	select SUM(o.qty*o.Price) Adjustments,o.StoreID,mi.Department,o.RecordType from dbo.[fnOrderLineItemTable1](@BeginTime,@EndTime) o
	 inner join MenuItem mi on mi.ID=o.ItemID and mi.StoreID=o.StoreID and mi.MIType='GC'
	 where    o.OrderID not in (select orderID from ExcludeOrder)
	  group by o.StoreID,mi.Department,o.RecordType) oli 
	on am.StoreID=oli.StoreID and am.AdjustType= 'Other Income' and am.AdjustName='Gift Certificate Sales'
	inner join QB_AdjustmentCategory ac on ac.ID=am.QBID
	 inner join QB_AdjustmentCategory ac1 on ac1.ID=am.QBClassID
	where oli.RecordType <> 'VOID' and oli.RecordType <>'comp'  
	and am.StoreID in(select StoreID from QB_ProfileMachStore where ProfileID=@ProfileID)
	--and am.AdjustType in (select EventDataType from QB_EventType where RefNum=@eventID)
	group by am.AdjustName,am.AdjustType, am.QBType,ac.ID,ac1.ID 
	
	--Paid In
	Union all
	
	select @eventID EventID,@BeginTime BeginTime,@EndTime EndTime,CONVERT(decimal(18,2),isnull(SUM(ISNULL(Amount*(case when am.QBType='DEBIT' then -1 else 1 end),0)),0)) Adjustments
	,am.AdjustName,am.AdjustType,am.QBType,ac.ID QBName,ac1.ID as ClassName ,null
	from [QB_AdjustmentMatch] am inner join (select SUM(Amount) Amount,storeid from   dbo.fnPaidInTrxTable1(@BeginTime,@EndTime)
	where Status='PAID_IN' group by StoreID)  pit 
	on am.StoreID=pit.StoreID and am.AdjustType= 'Other Income' and am.AdjustName='Paid Ins'
	inner join QB_AdjustmentCategory ac on ac.ID=am.QBID
	 inner join QB_AdjustmentCategory ac1 on ac1.ID=am.QBClassID
	where 
	 am.StoreID in (select StoreID from QB_ProfileMachStore where ProfileID=@ProfileID)
	--and am.AdjustType in (select EventDataType from QB_EventType where RefNum=@eventID)
	group by am.AdjustName,am.AdjustType, am.QBType,ac.ID,ac1.ID
	
	--In House Payment Sales
	Union all
	
	select @eventID EventID,@BeginTime BeginTime,@EndTime EndTime,CONVERT(decimal(18,2),isnull(sum(Adjustments*(case when am.QBType='DEBIT' then -1 else 1 end)),0)) Adjustments
	,am.AdjustName,am.AdjustType,am.QBType,ac.ID QBName,ac1.ID as ClassName ,null
	from [QB_AdjustmentMatch] am  inner join (
	select SUM(o.qty*o.Price) Adjustments,o.StoreID,mi.Department,o.RecordType from dbo.[fnOrderLineItemTable1](@BeginTime,@EndTime) o
	 inner join MenuItem mi on mi.ID=o.ItemID and mi.StoreID=o.StoreID and mi.MIType='IHPYMNT'
	  where o.OrderID not in (select orderID from ExcludeOrder)
	  group by o.StoreID,mi.Department,o.RecordType)  oli
	on am.StoreID=oli.StoreID and am.AdjustType= 'Other Income' and am.AdjustName='In House Payments'
	inner join QB_AdjustmentCategory ac on ac.ID=am.QBID
	 inner join QB_AdjustmentCategory ac1 on ac1.ID=am.QBClassID
	where oli.RecordType <> 'VOID' and
	 am.StoreID in (select StoreID from QB_ProfileMachStore where ProfileID=@ProfileID)
	--and am.AdjustType in (select EventDataType from QB_EventType where RefNum=@eventID)
	group by am.AdjustName,am.AdjustType, am.QBType,ac.ID,ac1.ID
	
	--Advance Payment
	Union all
	select @eventID EventID,@BeginTime BeginTime,@EndTime EndTime,CONVERT(decimal(18,2),isnull(sum(p.Amount*(case when am.QBType='DEBIT' then -1 else 1 end)),0)) Adjustments
	,am.AdjustName,am.AdjustType,am.QBType,ac.ID QBName,ac1.ID as ClassName ,null
	from [QB_AdjustmentMatch] am inner join (select sum(a.Amount) Amount,a.StoreID from dbo.fnPaymentTable1(@BeginTime,@EndTime) a inner join
	dbo.fnCheckTable1(@BeginTime,@EndTime) b on a.StoreID=b.StoreID and b.ID=a.CheckID
	where b.FutureOrderAdvPayment='Y' and b.OrderID not in (select orderID from ExcludeOrder)
	 group by a.StoreID) p on p.StoreID=am.StoreID
	 inner join QB_AdjustmentCategory ac on ac.ID=am.QBID
	  inner join QB_AdjustmentCategory ac1 on ac1.ID=am.QBClassID
	where  am.AdjustType='Other Income' and am.AdjustName='Advance Payments (net)' and
	am.StoreID in (select StoreID from QB_ProfileMachStore where ProfileID=@ProfileID)
	--and am.AdjustType in (select EventDataType from QB_EventType where RefNum=@eventID)
	group by am.AdjustName,am.AdjustType, am.QBType,ac.ID,ac1.ID 
	
	--Surcharge Collected
	Union all
	select @eventID EventID,@BeginTime BeginTime,@EndTime EndTime,CONVERT(decimal(18,2),isnull(sum(tax.TaxAmt*(case when am.QBType='DEBIT' then -1 else 1 end)),0)) Adjustments
	,am.AdjustName,am.AdjustType,am.QBType,ac.ID QBName,ac1.ID as ClassName ,null
	from [QB_AdjustmentMatch] am inner join (Select isnull(Sum(ISNULL((case when ss.SurchargeGuestPays='Y' then TaxAmt else 0 end),0)),0) TaxAmt,a.StoreID
From dbo.fnTaxTable1(@BeginTime,@EndTime) A 
JOIN TaxCategory B on a.TaxCategoryID = b.ID and B.Category='SUR' and  A.Category=B.Category 
	left outer join StoreSetting as ss on A.StoreID =ss.StoreID
		where a.OrderID not in (select orderID from ExcludeOrder)
	group by A.StoreID) tax on am.StoreID=tax.StoreID 
	inner join QB_AdjustmentCategory ac on ac.ID=am.QBID
	 inner join QB_AdjustmentCategory ac1 on ac1.ID=am.QBClassID
	where  am.AdjustType='Other Income' and am.AdjustName='Surcharge Collected' and
	am.StoreID in(select StoreID from QB_ProfileMachStore where ProfileID=@ProfileID)
	--and am.AdjustType in (select EventDataType from QB_EventType where RefNum=@eventID)
	group by am.AdjustName,am.AdjustType, am.QBType ,ac.ID,ac1.ID

--Paid Out
	Union all
	
	select @eventID EventID,@BeginTime BeginTime,@EndTime EndTime,CONVERT(decimal(18,2),isnull(SUM(ISNULL(Amount*(case when am.QBType='DEBIT' then -1 else 1 end),0)),0)) Adjustments
	,am.AdjustName,am.AdjustType,am.QBType,ac.ID QBName,ac1.ID as ClassName ,null
	from [QB_AdjustmentMatch] am inner join (select SUM(Amount) Amount,storeid from dbo.fnPaidOutTrxTable1(@BeginTime,@EndTime)
	group by StoreID ) pit 
	on am.StoreID=pit.StoreID and am.AdjustType= 'Other Income' and am.AdjustName='Paid Outs'
	inner join QB_AdjustmentCategory ac on ac.ID=am.QBID
	 inner join QB_AdjustmentCategory ac1 on ac1.ID=am.QBClassID
	where 
	 am.StoreID in (select StoreID from QB_ProfileMachStore where ProfileID=@ProfileID)
	--and am.AdjustType in (select EventDataType from QB_EventType where RefNum=@eventID)
	group by am.AdjustName,am.AdjustType, am.QBType,ac.ID,ac1.ID 
	
	
	--Previous payments from Future Order
	
	Union all
	select @eventID EventID,@BeginTime BeginTime,@EndTime EndTime,CONVERT(decimal(18,2),isnull(SUM(ISNULL(Amount*(case when am.QBType='DEBIT' then -1 else 1 end),0)),0)) Adjustments
	,am.AdjustName,am.AdjustType,am.QBType,ac.ID QBName,ac1.ID as ClassName ,null
	from [QB_AdjustmentMatch] am inner join (select isnull(SUM(ISNULL(p.amount,0) ),0) Amount,p.StoreID
 From dbo.fnPaymentTable1(@BeginTime,@EndTime) as p
  inner JOIN dbo.fnCheckTable1(@BeginTime,@EndTime) as c ON p.CheckID = c.ID and p.StoreID=c.StoreID  
 inner JOIN dbo.fnOrderTable1(@BeginTime,@EndTime) as O ON c.orderid = O.ID  and O.StoreID=c.StoreID and c.BusinessDate=O.BusinessDate
 where O.FutureOrder = 'Y' and o.ID not in (select orderID from ExcludeOrder) group by p.StoreID) a
 on a.StoreID=am.StoreID
 inner join QB_AdjustmentCategory ac on ac.ID=am.QBID
  inner join QB_AdjustmentCategory ac1 on ac1.ID=am.QBClassID
 where am.AdjustType= 'Other Income' and am.AdjustName='Previous payments from Future Order' and
	am.StoreID in (select StoreID from QB_ProfileMachStore where ProfileID=@ProfileID)
	--and am.AdjustType in (select EventDataType from QB_EventType where RefNum=@eventID)
	group by am.AdjustName,am.AdjustType, am.QBType,ac.ID,ac1.ID
	
	--Tax
	Union all
	select @eventID EventID,@BeginTime BeginTime,@EndTime EndTime,CONVERT(decimal(18,2),isnull(SUM(ISNULL(TaxAmt*(case when am.QBType='DEBIT' then -1 else 1 end),0)),0)) Adjustments
	,am.AdjustName,am.AdjustType,am.QBType,ac.ID QBName,ac1.ID as ClassName ,ac2.ID
	from [QB_AdjustmentMatch] am inner join (Select tc.Name as TaxName, isnull(SUM(ISNULL(t.TaxAmt,0)),0) as TaxAmt,t.StoreID
			From dbo.fnTaxTable1(@BeginTime,@EndTime) as t inner JOIN TaxCategory tc 
				ON t.TaxCategoryID = tc.ID and t.Category COLLATE SQL_Latin1_General_CP1_CI_AS=tc.Category and tc.StoreID= t.StoreID
	Where  t.Category = 'TAX'  and t.OrderID not in (select orderID from ExcludeOrder)
	Group By tc.Name,t.StoreID) tax
	on am.StoreID=tax.StoreID and am.AdjustName=tax.TaxName
	inner join QB_AdjustmentCategory ac on ac.ID=am.QBID
	 inner join QB_AdjustmentCategory ac1 on ac1.ID=am.QBClassID
	 inner join QB_AdjustmentCategory ac2 on ac2.ID=am.QBVendorID 
	 where am.AdjustType= 'Tax'  and
	am.StoreID in (select StoreID from QB_ProfileMachStore where ProfileID=@ProfileID)
	--and am.AdjustType in (select EventDataType from QB_EventType where RefNum=@eventID)
	group by am.AdjustName,am.AdjustType, am.QBType ,ac.ID,ac1.ID,ac2.ID
	
	Union all
	--Payment
	select @eventID EventID,@BeginTime BeginTime,@EndTime EndTime,CONVERT(decimal(18,2),isnull(SUM(ISNULL(sales*(case when am.QBType='DEBIT' then -1 else 1 end),0)),0)) Adjustments
	,am.AdjustName,am.AdjustType,am.QBType,ac.ID QBName,ac1.ID as ClassName ,null
	from [QB_AdjustmentMatch] am inner join (SELECT 
	isnull(SUM(isnull(p.Amount,0)),0) AS sales,P.StoreID,pm.Name
	FROM dbo.fnPaymentTable1(@BeginTime,@EndTime) AS p 
	INNER JOIN PaymentMethod AS pm ON p.MethodID = pm.Name AND pm.StoreID = p.StoreID
		where p.CheckID not in (select CheckID from ExcludeOrder)
	GROUP BY pm.Name,P.StoreID) payment
	on am.StoreID=payment.StoreID and am.AdjustName=payment.Name
	inner join QB_AdjustmentCategory ac on ac.ID=am.QBID
	 inner join QB_AdjustmentCategory ac1 on ac1.ID=am.QBClassID
	where am.AdjustType= 'Payment'  and
	am.StoreID in (select StoreID from QB_ProfileMachStore where ProfileID=@ProfileID)
	--and am.AdjustType in (select EventDataType from QB_EventType where RefNum=@eventID)
	group by am.AdjustName,am.AdjustType, am.QBType  ,ac.ID,ac1.ID ) b
	
	if @sumValue<>0
		set @retValue='N'
	else 
		set @retValue='Y'
 	return @retValue
 END

GO
