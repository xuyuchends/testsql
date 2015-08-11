SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Rpt_OrderSearchAll]
(
	@StoreID int,
	@OrderID int,
	@BeginDate datetime,
	@EndDate Datetime
)
as

if exists (select * from tempdb.dbo.sysobjects where id = object_id(N'tempdb..#tempOrder') and type='U')
drop table #tempOrder
select * into #tempOrder from [dbo].[fnOrderTable](@BeginDate,@EndDate,@StoreID)

if exists (select * from sysobjects where id = object_id(N'tempdb..#tempOrderLineItem') and type='U')
drop table #tempOrderLineItem 
select * into #tempOrderLineItem from [dbo].[fnOrderLineItemTable](@BeginDate,@EndDate,@StoreID)

if exists (select * from sysobjects where id = object_id(N'tempdb..#tempCheck') and type='U')
drop table #tempCheck
select * into #tempCheck from [dbo].[fnCheckTable](@BeginDate,@EndDate,@StoreID)

if exists (select * from sysobjects where id =object_id(N'tempdb..#tempPayment') and type='U')
drop table #tempPayment
select * into #tempPayment from [dbo].[fnPaymentTable](@BeginDate,@EndDate,@StoreID)

if exists (select * from sysobjects where id = object_id(N'tempdb..#tempTax') and type='U')
drop table #tempTax 
select * into #tempTax from [dbo].[fnTaxTable](@BeginDate,@EndDate,@StoreID)


if exists (select * from sysobjects where id = object_id(N'tempdb..#tempPaidInTrx') and type='U')
drop table #tempPaidInTrx 
select * into #tempPaidInTrx from [dbo].[fnPaidInTrxTable](@BeginDate,@EndDate,@StoreID)


--order Information
select o.ID as OrderID,CONVERT(varchar(10), o.BusinessDate,23) Date ,
		convert(varchar(2),DATEPART(HOUR,OpenTime))+':'+convert(varchar(2),DATEPART(minute,OpenTime) ) StartTime,
		DATEDIFF(MINUTE,OpenTime,CloseTime) Duration,
		o.GuestCount,
		e.FirstName+' '+e.LastName as ServerName,
		'Table '+ TableName as TableName
from #tempOrder o inner join Employee e on e.StoreID=o.StoreID and o.EmpIDClose=e.ID 
where o.StoreID=@StoreID and o.ID=@OrderID

--Payment Information
select p.CheckID,MethodID as PaymentType , Amount,Tip,(AmountReceived-Amount) as Change from #tempPayment p inner join #tempCheck c on p.CheckID=c.ID and p.StoreID=c.StoreID and p.businessDate=c.businessDate
 where c.OrderID=@OrderID and c.StoreID=@StoreID

--sales Total of order

select SUM(Qty*Price) as GrossSales,
		(select isnull(SUM(Qty*AdjustedPrice),0) from #tempOrderLineItem where OrderID=oli.OrderID and RecordType='DISCOUNT'
		and StoreID=oli.StoreID) as		 Discount,
		(select isnull(SUM(Qty*AdjustedPrice),0) from #tempOrderLineItem where OrderID=oli.OrderID and RecordType='VOID'
		and StoreID=oli.StoreID) as			Voids,
		(select isnull(SUM(Qty*AdjustedPrice),0) from #tempOrderLineItem where OrderID=oli.OrderID and RecordType='COMP'
		and StoreID=oli.StoreID) as			Comps,
		(select isnull(SUM(Qty*AdjustedPrice),0) from #tempOrderLineItem where OrderID=oli.OrderID and RecordType='COUPON'
		and StoreID=oli.StoreID) as			Coupon,
		isnull(SUM(Qty*(Price - AdjustedPrice)),0) as NetSales,
		(select  isnull(SUM(#tempTax.TaxAmt),0) from #tempTax where #tempTax.OrderID=oli.OrderID and #tempTax.StoreID=oli.StoreID) as Taxes,
		(select isnull(SUM(Gratuity),0) from #tempPayment p inner join #tempCheck c on p.CheckID=c.ID and p.StoreID=c.StoreID and p.businessDate=c.businessDate where		c.OrderID=oli.OrderID and c.StoreID=oli.StoreID) as ServiceCharge,
		(select isnull(SUM(Amount),0) from #tempPayment p inner join #tempCheck c on p.CheckID=c.ID and p.StoreID=c.StoreID and p.businessDate=c.businessDate where c.OrderID=oli.OrderID and c.StoreID=oli.StoreID)  as Payment
 from #tempOrderLineItem oli where oli.StoreID=@StoreID and oli.OrderID=@OrderID
 group by oli.OrderID,oli.StoreID

--order details

select isnull(SUM(Qty),0) Qty,
	ItemName,
	isnull(SUM(Amount),0) Amount,
	ISNULL(SUM(AdjustedPrice),0) AdjustedPrice,
	AdjustmentReason
	 from(
	 select case when oli.SI='N/A' then 1 else oli.Qty end Qty,mi.ReportName ItemName,
		oli.Price*oli.Qty Amount,
		oli.AdjustedPrice,
		case when oli.RecordType='VOID' then (select Name from Void where ID=oli.AdjustID and StoreID=oli.StoreID)
			when oli.RecordType='DISCOUNT' then (select Name from Discount where ID=oli.AdjustID and StoreID=oli.StoreID)
			when oli.RecordType='COMP' then (select Name from Comp where ID=oli.AdjustID and StoreID=oli.StoreID)
			when oli.RecordType='COUPON' then (select Name from Coupon where ID=oli.AdjustID and StoreID=oli.StoreID) end as AdjustmentReason from #tempOrderLineItem oli inner join MenuItem mi on oli.ItemID=mi.ID and oli.StoreID=mi.StoreID 
	where oli.StoreID=@StoreID and oli.OrderID=@OrderID	) as Tab1	
	group by ItemName,AdjustmentReason
	
	
	
GO
