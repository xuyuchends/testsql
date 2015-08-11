SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [dbo].[Rpt_D_NumGuestByRcByDay]
	@BeginDate datetime,
	@EndDate datetime,
	@storeID nvarchar(200)
AS  
BEGIN
declare @sql nvarchar(max)
SET NOCOUNT ON;

set @sql='Select o.RevenueCenter RevenueCenter,
	--count(o.ID) as NumTables
	sum(o.GuestCount) as NumGuest   
	From [Order] as o 
	where o.BusinessDate between '''+CONVERT(nvarchar(20),@BeginDate)+''' 
	and '''+CONVERT(nvarchar(20),@EndDate)+''' and o.StoreID in ('+@storeID+')
	and o.Status=''CLOSE'''
set @sql+=' GROUP BY o.RevenueCenter '

--select @sql
exec sp_executesql @sql
end
GO
