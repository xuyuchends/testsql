SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Rpt_D_NumTableSummaryByStoreByDay]
(
	@BeginDate datetime,
	@EndDate datetime,
	@storeID nvarchar(200)
)
as
declare @sql nvarchar(max)
SET NOCOUNT ON;
set @sql='Select s.StoreName as StoreName,
count(o.ID) as NumTables
From [Order] as o inner join Store as s ON o.StoreID = s.ID 
WHERE  BusinessDate between '''+CONVERT(nvarchar(20),@BeginDate)+''' and '''+CONVERT(nvarchar(20),@EndDate)+''' and o.StoreID in ('+@storeID+') 
and o.status=''CLOSE''
Group by s.StoreName'

execute sp_executesql @sql
--select @sql
GO
