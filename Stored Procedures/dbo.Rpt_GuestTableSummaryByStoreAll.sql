SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create proc [dbo].[Rpt_GuestTableSummaryByStoreAll]
(
	@BeginDate datetime,
	@EndDate datetime,
	@storeID nvarchar(200)
)
as
declare @sql nvarchar(max)
set @sql='
if exists (select * from tempdb.dbo.sysobjects where id = object_id(N''tempdb..#tempOrder'') and type=''U'')
drop table #tempOrder
select * into #tempOrder from [dbo].[fnOrderTable]('''+ Convert(nvarchar,@BeginDate,120)+ ''','''+ Convert(nvarchar,@EndDate,120) + ''','''+@storeID+''')


Select s.StoreName as StoreName,count(o.ID) as NumTables,sum(o.GuestCount) as NumGuest   From #tempOrder as o inner join Store as s ON o.StoreID = s.ID      Group by s.StoreName'

--select @sql
execute sp_executesql @sql

GO
