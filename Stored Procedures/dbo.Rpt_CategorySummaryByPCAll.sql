SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [dbo].[Rpt_CategorySummaryByPCAll]
	@BeginDate datetime,					-- begin date
	@EndDate datetime,					-- end date
	@StoreID int
AS
BEGIN
Select o.RevenueCenter, 
MI.ReportCategory,
isnull(SUM(OI.qty * (OI.price-OI.AdjustedPrice)),0) as CatTotal
From (select orderid,StoreID,qty,price,AdjustedPrice,itemid,SI,BusinessDate from [dbo].[fnOrderLineItemTable](@BeginDate,@EndDate,@StoreID)) as OI 
inner JOIN (select RevenueCenter,StoreID,ID,BusinessDate from [dbo].[fnOrderTable](@BeginDate,@EndDate,@StoreID))as O ON OI.orderid = O.ID
and OI.StoreID=O.StoreID and OI.BusinessDate=O.BusinessDate
LEFT JOIN MenuItem MI ON OI.itemid = MI.ID AND MI.ReportCategory <> '''' AND MI.ReportCategory IS NOT NULL
and O.StoreID=MI.StoreID
Where si <> 'N/A'  and MI.MIType NOT IN ('GC', 'IHPYMNT')
Group By o.RevenueCenter, MI.ReportCategory
end

GO
