SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE proc [dbo].[QB_GetNotBalanceOrder]
(
	@BeginDate datetime,
	@EndDate datetime,
	@EventID int
)
as
 select orderID,isnull(sum(sales+Tax),0)  GrossSales ,StoreID,BusinessDate
into #tempOrder
from ( 
Select o.StoreID, o.id OrderID , 
--case when oi.RecordType='RETURN' then sum(round(qty*oi.Price,2)) else sum(round(Qty*(OI.price-OI.AdjustedPrice),2)) end as Sales,
case when oi.RecordType='RETURN' then sum(round(qty*oi.Price,2)) else sum(round(Qty*OI.price,2))-sum(round(Qty*OI.AdjustedPrice,2)) end as Sales,
0 tax,o.BusinessDate
 From OrderLineItem OI 
JOIN [order] O ON OI.orderid = O.ID 
AND o.BusinessDate=oi.BusinessDate  and o.storeid=oi.StoreID
JOIN MenuItem MI ON OI.itemid = MI.ID AND MI.Department <> 'MODIFIER' and mi.StoreID=o.StoreID
Where OI.Status = 'CLOSE' And MI.MIType NOT IN ('IHPYMNT') and RecordType<>'GC'
AND O.status = 'CLOSE' 
AND OI.BusinessDate BETWEEN @BeginDate AND @EndDate
Group by o.ID,o.BusinessDate,o.StoreID,oi.RecordType

union 
select StoreID, orderid,0 sales, isnull(sum(TaxAmt),0) tax,BusinessDate from Tax where Status='valid' 
and BusinessDate  BETWEEN @BeginDate AND @EndDate
group by OrderID,BusinessDate,StoreID
) b group by StoreID,OrderID ,BusinessDate
order by StoreID,OrderID 


Select o.ID OrderID, 
isnull(sum(SD.amount),0) as sales,sd.BusinessDate,o.StoreID into #tempCheck
From [order] O 
JOIN [Check] SH on O.id = SH.orderid and o.storeid=sh.StoreID 
and o.BusinessDate=SH.BusinessDate
 JOIN Payment SD 
on SD.CheckID = SH.ID AND sd.StoreID=sh.StoreID and SH.BusinessDate=sd.BusinessDate
Where SD.status = 'CLOSED' and O.status = 'CLOSE' and
SD.BusinessDate BETWEEN @BeginDate AND @EndDate 
Group By o.ID,sd.BusinessDate,o.StoreID


SELECT   o.orderID as orderID into #tempSame
FROM      #tempOrder as o inner  JOIN   
                #tempCheck as s ON o.orderID = s.orderID
                and o.GrossSales=s.sales and o.StoreID=s.StoreID

--select o.orderID,GrossSales from #tempOrder as o where orderID not in (select orderID from #tempSame)
 insert into QB_ExcludeOrder select orderID,BusinessDate,storeid,eventID from
 (
  select s.orderID,BusinessDate,storeid,@EventID eventID  from #tempCheck as s where orderID 
not in (select orderID from #tempSame)
union 
select s.orderID,BusinessDate,storeid,@EventID  from #tempOrder as s where orderID 
not in (select orderID from #tempSame)
)b


drop table #tempCheck
drop table #tempOrder
drop table #tempSame

GO
