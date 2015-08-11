SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create proc [dbo].[Rpt_PaidInDetailManagerInfoAll]
(
	@BeginDate datetime,
	@EndDate datetime,
	@StoreID int
)
as

if exists (select * from sysobjects where id = object_id('#tempPaidInTrx'))
drop table #tempPaidInTrx 
select * into #tempPaidInTrx from [dbo].[fnPaidInTrxTable](@BeginDate,@EndDate,@StoreID)
SELECT  distinct e1.ID ManagerID,e1.FirstName+''+e1.LastName as ManagerName
FROM	#tempPaidInTrx as  pit LEFT OUTER JOIN 
        Employee as e1 ON pit.ManagerID = e1.ID and pit.StoreID=e1.StoreID 
WHERE   pit.BusinessDate BETWEEN @BeginDate AND @EndDate and pit.StoreID=@StoreID
GO
