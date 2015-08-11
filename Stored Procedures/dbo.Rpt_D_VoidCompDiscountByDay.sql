SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE Procedure [dbo].[Rpt_D_VoidCompDiscountByDay]
	@BeginDate datetime,
	@EndDate datetime,
	@storeID nvarchar(200)
AS  
BEGIN
declare @sql nvarchar(max)
SET NOCOUNT ON;

set @sql='
	select isnull(table2.AdjustedValue,0) as AdjustedValue,table1.t as RecordType from
(
  select ''Comp'' as t
  union
  select ''Void'' as t
  union
  select ''Discount'' as t
 )
as table1
left outer join
	(SELECT 
	SUM(isnull(OI.qty * OI.AdjustedPrice,0)) as AdjustedValue,
	oi.RecordType
	FROM OrderLineItem AS OI 
	INNER JOIN MenuItem AS MI ON OI.ItemID = MI.ID AND MI.ReportDepartment <> ''MODIFIER'' and OI.SI<>''N/A'' AND MI.StoreID = OI.StoreID
	inner join store as s on s.id=oi.storeID 
	WHERE MI.MIType NOT IN (''GC'', ''IHPYMNT'') and BusinessDate between '''+CONVERT(nvarchar(20),@BeginDate)+''' and '''+CONVERT(nvarchar(20),@EndDate)+''' and oi.StoreID in ('+@storeID+') 
	and RecordType in (''Void'',''COMP'',''Discount'') and oi.Status=''CLOSE'''
set @sql +=' GROUP BY oi.RecordType) as table2 on table1.t=table2.RecordType'

--select @sql
exec sp_executesql @sql
end

GO
