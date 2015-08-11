SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [dbo].[Rpt_CategorySummaryByPeriodAll]
	@BeginDate datetime,
	@EndDate datetime,
	@storeID nvarchar(2000)
AS
begin
SET NOCOUNT ON;
Select storeid, Category, isnull(sum(ttlqty),0) as TtlQty, isnull(sum(lunch),0) as  Lunch, sum(dinner) as Dinner From 
(
Select o.storeid as storeID, MI.ReportCategory as Category, 
CAST(CASE WHEN OI.parentsplitLineNum = 0 THEN OI.qty ELSE (convert(real,OI.qty)/convert(real,OI.numsplits)) END AS int) as TtlQty, 
case when O.MealPeriod = 'LUNCH' then isnull(OI.qty * (OI.price-OI.AdjustedPrice),0) else 0 end as Lunch,
case when O.MealPeriod = 'DINNER' then isnull(OI.qty * (OI.price-OI.AdjustedPrice),0) else 0 end as DINNER
From (select qty,price,AdjustedPrice,parentsplitLineNum,itemid,recordType,SI,orderid,numsplits,StoreID,BusinessDate from [dbo].[fnOrderLineItemTable](@BeginDate,@EndDate,@storeID)) as OI 
inner JOIN (select storeid,MealPeriod,ID,BusinessDate from [dbo].[fnOrderTable](@BeginDate,@EndDate,@storeID)) as O ON OI.orderid = O.ID and OI.StoreID=O.StoreID
and OI.BusinessDate=O.BusinessDate
LEFT JOIN MenuItem MI ON OI.itemid = MI.ID and o.StoreID=MI.StoreID
Where si <> 'N/A' AND MI.ReportCategory <> '' AND MI.ReportCategory IS NOT NULL and oi.recordType<>'VOID' and O.MealPeriod in ('LUNCH','DINNER') and MI.MIType NOT IN ('GC', 'IHPYMNT')
) as table1
Group by storeid, Category
end
GO
