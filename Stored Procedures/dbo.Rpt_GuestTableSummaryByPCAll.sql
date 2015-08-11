SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [dbo].[Rpt_GuestTableSummaryByPCAll]
	@BeginDate datetime,
	@EndDate datetime,
	@storeID nvarchar(2000)
AS
begin
Select RevenueCenterName, SUM(NumTables) as NumTables, SUM(NumGuest)as NumGuest, SUM(NumChecks) as NumChecks, SUM(ProfitTotal) as ProfitTotal from 
(
(
 select RevenueCenter as RevenueCenterName,count(ID) as NumTables ,sum(GuestCount)  as NumGuest,NULL AS NumChecks, NULL AS ProfitTotal from [dbo].[fnOrderTable](@BeginDate,@EndDate,@storeID)
 where status<>'TRANSFERRED' Group by RevenueCenter
)UNION 
(
Select o.RevenueCenter as RevenueCenterName,NULL AS NumTables, NULL AS NumGuest,
COUNT(p.CheckID) AS NumChecks, NULL as ProfitTotal
From (select RevenueCenter,StoreID,ID,status,BusinessDate from [dbo].[fnOrderTable](@BeginDate,@EndDate,@storeID)) as  O
inner JOIN (select ID,StoreID,orderid,BusinessDate  from [dbo].[fnCheckTable](@BeginDate,@EndDate,@storeID)) as c ON O.ID = c.orderid and O.StoreID=c.StoreID
and O.BusinessDate=C.BusinessDate
inner JOIN (select CheckID,StoreID  from [dbo].[fnPaymentTable](@BeginDate,@EndDate,@storeID)) as p ON p.CheckID = c.ID and c.StoreID=p.StoreID 
where status<>'TRANSFERRED'
Group by o.RevenueCenter
) UNION
(
Select o.RevenueCenter as RevenueCenterName, NULL AS NumTables, NULL AS NumGuest,
NULL AS NumChecks, SUM(qty * (price-AdjustedPrice)) as ProfitTotal
From (select RevenueCenter,ID,StoreID,status,BusinessDate  from [dbo].[fnOrderTable](@BeginDate,@EndDate,@storeID)) as O
inner JOIN (select orderid,StoreID,qty,price,AdjustedPrice,BusinessDate  from [dbo].[fnOrderLineItemTable](@BeginDate,@EndDate,@storeID)
) as OI ON O.ID = OI.orderid  and O.StoreID=OI.StoreID and O.BusinessDate=OI.BusinessDate where o.status<>'TRANSFERRED'
 Group by o.RevenueCenter
)
) as table1
Group by RevenueCenterName
end
GO
