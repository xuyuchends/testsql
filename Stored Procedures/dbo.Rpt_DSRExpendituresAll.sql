SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [dbo].[Rpt_DSRExpendituresAll]
	@BeginDate datetime,
	@EndDate datetime,
	@storeID nvarchar(2000)
AS
begin
declare @sql as nvarchar(max)
SET NOCOUNT ON;

 Select ISNULL(SUM(pot.Amount),0) AS TotalPaidOut From 
 (select Amount  from [dbo].[fnPaidOutTrxTable](@BeginDate,@EndDate,@storeID))  as pot

--Previous payments from future orders
 select ISNULL(SUM(p.amount),0) as PaidAdv  
 From (select Amount,CheckID,StoreID,BusinessDate from [dbo].[fnPaymentTable](@BeginDate,@EndDate,@storeID)) as p
  inner JOIN (select ID,StoreID,orderid,BusinessDate from [dbo].[fnCheckTable](@BeginDate,@EndDate,@storeID)) as c ON p.CheckID = c.ID and p.StoreID=c.StoreID  and p.BusinessDate=c.BusinessDate
 inner JOIN (select FutureOrder,ID,StoreID,BusinessDate from [dbo].[fnOrderTable](@BeginDate,@EndDate,@storeID)) as O ON c.orderid = O.ID  and O.StoreID=c.StoreID
 and c.BusinessDate=o.BusinessDate
 where O.FutureOrder = 'Y'
end
GO
