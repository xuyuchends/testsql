SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Rpt_HourlySalesAll]
(
	@BeginDate datetime,
	@EndDate Datetime,
	@storeid int,
	@RevenueCenter nvarchar(20)
	)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

--declare @StoreName nvarchar(50)
--select @StoreName=StoreName from Store where ID=@storeid

declare @sqlAll nvarchar(max)
declare @sqlTable nvarchar(max)
declare @sqlWhere nvarchar(max)
declare @sqlWhere1 nvarchar(max)
set @sqlWhere=''
set @sqlWhere1=''
declare @sqlAll1 nvarchar(max)
if ISNULL(@RevenueCenter,'')<>''
begin
	set @sqlWhere='and o.RevenueCenter='''+@RevenueCenter+''''
	set @sqlWhere1='and o1.RevenueCenter='''+@RevenueCenter+''''
end

set @sqlAll ='if exists (select * from sysobjects where id=object_id(''#Order'')) drop table #Order
select * into #Order from [dbo].[fnOrderTable]('''+ Convert(nvarchar,@BeginDate,120)+ ''','''+ Convert(nvarchar,@EndDate,120) + ''','''+convert(nvarchar(2000),@storeID)+''')
if exists(select * from sysobjects where id=object_id(''#OrderLineItem'')) drop table #OrderLineItem 
select * into #OrderLineItem from [dbo].[fnOrderLineItemTable]('''+ Convert(nvarchar,@BeginDate,120)+ ''','''+ Convert(nvarchar,@EndDate,120) + ''','''+convert(nvarchar(2000),@storeID)+''')
if exists (select * from sysobjects where id=object_id(''#Check'')) drop table #Check
select * into #Check from [dbo].[fnCheckTable]('''+ Convert(nvarchar,@BeginDate,120)+ ''','''+ Convert(nvarchar,@EndDate,120) + ''','''+convert(nvarchar(2000),@storeID)+''')
if exists(select * from sysobjects where id=object_id(''#Payment'')) drop table #Payment
select * into #Payment from [dbo].[fnPaymentTable]('''+ Convert(nvarchar,@BeginDate,120)+ ''','''+ Convert(nvarchar,@EndDate,120) + ''','''+convert(nvarchar(2000),@storeID)+''')
if exists(select * from sysobjects where id=object_id(''#Tax'')) drop table #Tax 
select * into #Tax from [dbo].[fnTaxTable]('''+ Convert(nvarchar,@BeginDate,120)+ ''','''+ Convert(nvarchar,@EndDate,120) + ''','''+convert(nvarchar(2000),@storeID)+''')
if exists(select * from sysobjects where id=object_id(''#temp1'')) drop table #temp1
'
set @sqlAll1='
select top 24 convert(varchar(13),dateadd(hh,langid,''1900-01-01 04:00:00''),8) as Time into #temp1 from master..syslanguages order by langid   
select '+CONVERT(nvarchar(10),@storeid)+' StoreID,(select StoreName from Store where ID=6) StoreName,#temp1.time,isnull(Void,0) Void,
isnull(Comp,0) Comp,isnull(Discount,0) Discount,isnull(SalesTotal,0) SalesTotal,isnull(itemCount,0) itemCount,
isnull(GuestCount,0) GuestCount,isnull(taxTotal,0) taxTotal,isnull(autoGrat,0) autoGrat,
isnull(CheckCount,0) CheckCount from(select orderTime ,SUM(Void) Void,SUM(Comp) Comp,SUM(Discount) Discount, 
SUM(SalesTotal) SalesTotal,SUM(itemCount) itemCount,SUM(GuestCount) GuestCount,SUM(taxTotal) taxTotal,
SUM(autoGrat)autoGrat,isnull(sum(CheckCount),0) CheckCount from
(select (case when len(CONVERT(nvarchar,DATEPART(hh,oli.TimeOrdered)))=1 then ''0''+CONVERT(nvarchar,DATEPART(hh,oli.TimeOrdered)) else 
CONVERT(nvarchar, DATEPART(hh, oli.TimeOrdered)) end) + '':00:00'' orderTime,
(select sum(Qty*AdjustedPrice) from #OrderLineItem oli1 inner join #Order o1 on o1.StoreID=oli1.StoreID and 
o1.ID=oli1.OrderID and o1.BusinessDate=oli1.BusinessDate where DATEPART(hh,TimeOrdered)=DATEPART(hh,oli.TimeOrdered) and 
oli1.BusinessDate=oli.BusinessDate '+@sqlWhere1+' and RecordType=''VOID'') Void,
(select sum(Qty*AdjustedPrice)from #OrderLineItem oli1 inner join #Order o1 on o1.StoreID=oli1.StoreID and 
o1.ID=oli1.OrderID and o1.BusinessDate=oli1.BusinessDate where DATEPART(hh,TimeOrdered)=DATEPART(hh,oli.TimeOrdered) and 
oli1.BusinessDate=oli.BusinessDate '+@sqlWhere1+' and RecordType=''COMP'') Comp,
(select sum(Qty*AdjustedPrice) from #OrderLineItem oli1 inner join #Order o1 on o1.StoreID=oli1.StoreID 
and o1.ID=oli1.OrderID and o1.BusinessDate=oli1.BusinessDate  where DATEPART(hh,TimeOrdered)=DATEPART(hh,oli.TimeOrdered) and 
oli1.BusinessDate=oli.BusinessDate ' +@sqlWhere1+' and RecordType=''DISCOUNT'') Discount, 
sum(oli.Qty*(oli.Price-oli.AdjustedPrice)) as SalesTotal,count(oli.id) itemCount,(select sum(o1.GuestCount) 
from #Order o1 where DATEPART(hh,o1.OpenTime)=DATEPART(hh,oli.TimeOrdered) '+@sqlWhere1+' and o1.BusinessDate=oli.BusinessDate) GuestCount,
(select count(c.ID) from #Check c inner join #Order o1 on o1.id=c.OrderID and o1.StoreID=c.StoreID 
and o1.BusinessDate=c.BusinessDate where DATEPART(hh,c.SaleTime)=DATEPART(hh,oli.TimeOrdered) ' +@sqlWhere1+' and 
c.BusinessDate=oli.BusinessDate) CheckCount,(select sum(TaxAmt) from #Tax t inner join #Order o1 
on t.OrderID=o1.ID and t.StoreID=o1.StoreID and t.BusinessDate=o1.BusinessDate 
where DATEPART(hh,o1.OpenTime)=DATEPART(hh,oli.TimeOrdered) '+ @sqlWhere1+' and o1.BusinessDate=oli.BusinessDate) taxTotal,
(SELECT SUM(p.Gratuity) Expr1 FROM #Payment AS p INNER JOIN  #Check c ON p.CheckID = c.ID AND p.StoreID = c.StoreID and p.BusinessDate = c.BusinessDate 
inner join #Order o1 on o1.id=c.OrderID and o1.StoreID=c.StoreID and o1.BusinessDate=c.BusinessDate where 
DATEPART(hh, c.SaleTime)=DATEPART(hh, oli.TimeOrdered) '+@sqlWhere1+'  and c.BusinessDate=oli.BusinessDate) 
autoGrat from #OrderLineItem oli inner join #Order o on o.id=oli.OrderID and o.StoreID=oli.StoreID
and o.BusinessDate=oli.BusinessDate where 1=1 '+@sqlWhere+' group by DATEPART(hh,oli.TimeOrdered),oli.BusinessDate) a group by orderTime) t right join #temp1  
on #temp1.time=t.orderTime 
'




set @sqlAll=@sqlAll+@sqlAll1
execute sp_executesql @sqlAll

END

GO
