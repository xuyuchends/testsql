SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[RptHourlySales1]
(
	@BeginDate datetime,
	@EndDage Datetime,
	@StoreID int
)
as
create table #HourlySales1 
(
    ID   int IDENTITY (1,1)     not null, 
    OrderTime  varchar(50),   
    taxTotal decimal,
    ItemCount     int,
    SalesTotal decimal,
    Comp decimal,
    Discount decimal,
    void decimal,
    AutoGrat decimal,
    CheckCount int,
    GuestCount int
)

declare @OrderTime varchar(50)
declare @taxTotal decimal
declare @ItemCount int
declare @SalesTotal decimal
declare @Comp decimal
declare @Discount decimal
declare @void decimal
declare @AutoGrat decimal
declare @CheckCount decimal
declare @GuestCount decimal

declare @TimePeriod datetime
declare cur cursor
read_only
for select top 24 convert(varchar(13),dateadd(hh,langid,'2008-07-28 04:00:00'),8) id from master..syslanguages order by langid

open cur
fetch next from cur into @TimePeriod
while(@@fetch_status=0)
begin

	drop table #OrderID
select ID into #OrderID from [Order] where DATEPART(Hour,OpenTime)=DATEPART(HOUR,@TimePeriod) and StoreID=6 and BusinessDate between '6/13/2012' and '6/13/2012'
--tax
select @taxTotal=isnull(a.taxTotal,0),@ItemCount=isnull(b.ItemCount,0),@SalesTotal=isnull(b.SalesTotal,0),@Comp=isnull(c.Comp,0),@Discount=isnull(c.Discount,0),@void=isnull(c.void,0),@AutoGrat=isnull(d.AutoGrat,0),@CheckCount=isnull(d.CheckCount,0),@GuestCount=isnull(e.GuestCount,0)  from (select  isnull(SUM(Tax.TaxAmt),0) taxTotal,Convert(nvarchar(20),DATEPART(HOUR,@TimePeriod))+':00:00' as OrderTime from Tax where OrderID in (select ID from #OrderID) and Tax.StoreID=6) as a inner join 
--Sales Total
(select isnull(SUM(Qty*Price),0) SalesTotal,sum(Qty) as ItemCount,Convert(nvarchar(20),DATEPART(HOUR,@TimePeriod))+':00:00' as OrderTime
 from OrderLineItem where OrderID in (select ID from #OrderID) and StoreID=6) as b on a.OrderTime=b.OrderTime inner join
 
 --void,comp,discount
 (select Convert(nvarchar(20),DATEPART(HOUR,@TimePeriod))+':00:00' as OrderTime,
(case when RecordType='Void' then ISNULL(SUM(Qty*Price),0) end) as void,
(case when RecordType='Discount' then ISNULL(SUM(Qty*Price),0) end) as Discount,
(case when RecordType='Comp' then ISNULL(SUM(Qty*Price),0) end) as Comp
 from OrderLineItem where OrderID in (select ID from #OrderID) and StoreID=6
 group by RecordType) as c on b.OrderTime=c.OrderTime inner join 
--payment
(select COUNT(distinct CheckID) as CheckCount,isnull(SUM(Gratuity),0) as AutoGrat,Convert(nvarchar(20),DATEPART(HOUR,@TimePeriod))+':00:00' as OrderTime from Payment p inner join [Check] c on p.CheckID=c.ID and p.StoreID=c.StoreID where 
c.OrderID in (select ID from #OrderID) and p.StoreID=6) as d on c.OrderTime=d.OrderTime inner join 

--guest
(select SUM(GuestCount) GuestCount,Convert(nvarchar(20),DATEPART(HOUR,@TimePeriod))+':00:00' as OrderTime from [Order] where ID in (select ID from #OrderID))as e on d.OrderTime=e.OrderTime 


insert into #HourlySales1 values(isnull(@OrderTime,Convert(nvarchar(20),DATEPART(HOUR,@TimePeriod))+':00:00'),isnull(@taxTotal,0),isnull(@ItemCount,0),isnull(@SalesTotal,0),isnull(@Comp,0),isnull(@Discount,0),isnull(@void,0),isnull(@AutoGrat,0),isnull(@CheckCount,0),isnull(@GuestCount,0))
fetch next from cur into @TimePeriod
end
close cur
deallocate cur

select * from #HourlySales1
drop table #HourlySales1
GO
