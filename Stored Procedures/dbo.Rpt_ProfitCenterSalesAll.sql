SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[Rpt_ProfitCenterSalesAll]
 @beginDate datetime,    -- Begind date
 @StoreID int
 --@otherDB varchar(50)     -- name of database to pull the information from

AS

Declare @sqlOutput nvarchar(max)

Declare @day1 as nvarchar(20)
Declare @day2 as nvarchar(20)
Declare @day3 as nvarchar(20)
Declare @day4 as nvarchar(20)
Declare @day5 as nvarchar(20)
Declare @day6 as nvarchar(20)
Declare @day7 as nvarchar(20)

Set @day1 = @beginDate
Set @day2 = dateadd(day,1,@day1)
Set @day3 = dateadd(day,2,@day1)
Set @day4 = dateadd(day,3,@day1)
Set @day5 = dateadd(day,4,@day1)
Set @day6 = dateadd(day,5,@day1)
Set @day7 = dateadd(day,6,@day1)
if exists (select * from tempdb.dbo.sysobjects where id = object_id(N'tempdb..#tempOrder') and type='U')
drop table #tempOrder
select * into #tempOrder from [dbo].[fnOrderTable](@beginDate,DATEADD(day,6,@beginDate),@StoreID)

if exists (select * from sysobjects where id = object_id(N'tempdb..#tempOrderLineItem') and type='U')
drop table #tempOrderLineItem 
select * into #tempOrderLineItem from [dbo].[fnOrderLineItemTable](@beginDate,DATEADD(day,6,@beginDate),@StoreID)

Select MealPeriod,RevenueCenter as Dining_Room,
Day1 as Day1,Day2 as Day2,Day3 as Day3,Day4 as Day4,
Day5 as Day5,Day6 as Day6,Day7 as Day7
From
 (select DayPart as MealPeriod  , 

 RevenueCenter,Begin_Date,isnull(sum(amount),0) amount
from (
 Select dbo.[f_GetOrderMealPeriodRpt](o.OpenTime,o.StoreID) as DayPart, 
 o.RevenueCenter as  RevenueCenter,
 Case  When o.BusinessDate =  @day1  Then 'Day1'
  When o.BusinessDate =  @day2  Then 'Day2'
  When o.BusinessDate =  @day3  Then 'Day3'
  When o.BusinessDate =  @day4  Then 'Day4'
  When o.BusinessDate =  @day5  Then 'Day5'
  When o.BusinessDate =  @day6  Then 'Day6'
  When o.BusinessDate =  @day7  Then 'Day7'
  End as Begin_Date,  
 isnull(sum(oli.Qty * (oli.Price-AdjustedPrice)),0) as amount

 FROM #tempOrder o 
 INNER JOIN #tempOrderLineItem oli ON oli.OrderID = o.ID and o.StoreID=oli.StoreID
 and o.BusinessDate=oli.BusinessDate
 INNER JOIN MenuItem ON oli.ItemID = MenuItem.ID and MenuItem.StoreID=o.StoreID

 WHERE o.BusinessDate  between @day1 and @day7 
 and o.StoreID=@StoreID
  AND oli.RecordType <> 'VOID'
 AND  MIType NOT IN ('GC','IHPYMNT')  
 group by o.RevenueCenter, o.BusinessDate,o.OpenTime,o.StoreID ) as t
 group by t.DayPart,t.RevenueCenter,t.Begin_Date
 
 union all     
 select 'DAILY' as MealPeriod ,RevenueCenter,Begin_Date,isnull(sum(amount),0) amount
from (
 Select dbo.[f_GetOrderMealPeriodRpt](o.OpenTime,o.StoreID) as DayPart, 
 o.RevenueCenter as  RevenueCenter,
 Case  When o.BusinessDate =  @day1  Then 'Day1'
  When o.BusinessDate =  @day2  Then 'Day2'
  When o.BusinessDate =  @day3  Then 'Day3'
  When o.BusinessDate =  @day4  Then 'Day4'
  When o.BusinessDate =  @day5  Then 'Day5'
  When o.BusinessDate =  @day6  Then 'Day6'
  When o.BusinessDate =  @day7  Then 'Day7'
  End as Begin_Date,  
 isnull(sum(oli.Qty * (oli.Price-AdjustedPrice)),0) as amount

 FROM #tempOrder o 
 INNER JOIN #tempOrderLineItem oli ON oli.OrderID = o.ID and o.StoreID=oli.StoreID
 and o.BusinessDate=oli.BusinessDate
 INNER JOIN MenuItem ON oli.ItemID = MenuItem.ID and MenuItem.StoreID=o.StoreID

 WHERE o.BusinessDate  between @day1 and @day7 
 and o.StoreID=@StoreID
  AND oli.RecordType <> 'VOID'
 AND  MIType NOT IN ('GC','IHPYMNT')  
 group by o.RevenueCenter, o.BusinessDate,o.OpenTime,o.StoreID ) as t
 group by t.RevenueCenter,t.Begin_Date) a

PIVOT (sum(amount) for Begin_Date in (Day1,Day2,Day3,Day4,Day5,Day6,Day7)) p

GO
