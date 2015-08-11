SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE proc [dbo].[Rpt_AdjustmentSalesAll]
(
	@BeginDate datetime,
	@EndDate datetime,
	@storeID nvarchar(2000),
	@RecordType nvarchar(20)
)
as
declare @sql nvarchar(max)
set @sql='

if exists (select * from tempdb.dbo.sysobjects where id = object_id(N''tempdb..#tempOrder'') and type=''U'')
drop table #tempOrder

if exists (select * from tempdb.dbo.sysobjects where id = object_id(N''tempdb..#tempOrderLineItem'') and type=''U'')
drop table #tempOrderLineItem 

select * into #tempOrderLineItem from [dbo].[fnOrderLineItemTable]('''+ Convert(nvarchar,@BeginDate,120)+ ''','''+ Convert(nvarchar,@EndDate,120) + ''','''+@storeID+''')
select * into #tempOrder from [dbo].[fnOrderTable]('''+ Convert(nvarchar,@BeginDate,120)+ ''','''+ Convert(nvarchar,@EndDate,120) + ''','''+@storeID+''')

SELECT  sum(OI.qty * OI.AdjustedPrice) as AdjustAmount,v.Name AdjustName
FROM #tempOrderLineItem AS OI INNER JOIN #tempOrder AS O 
	ON OI.OrderID = O.ID AND O.StoreID = OI.StoreID and OI.BusinessDate=O.BusinessDate 
	inner join '+@RecordType+' v on v.ID=OI.AdjustID and v.StoreID=OI.StoreID  group by v.Name'

--select @sql
execute sp_executesql @sql


GO
