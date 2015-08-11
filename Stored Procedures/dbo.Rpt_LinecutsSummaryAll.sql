SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [dbo].[Rpt_LinecutsSummaryAll]
	@BeginDate datetime,
	@EndDate datetime,
	@Linecut varchar(10),
	@storeID nvarchar(200)
AS
begin
Declare @Sql as nvarchar(max)
	SET @Sql = ' 
	select v.Name as AdjustedName,
	SUM(oli.qty * oli.AdjustedPrice) as Total,
	COUNT(*) as  count
	from (select qty,AdjustedPrice,AdjustID,storeid,RecordType,itemid from [dbo].[fnOrderLineItemTable]('''+ Convert(nvarchar,@BeginDate,120)+ ''','''+ Convert(nvarchar,@EndDate,120) + ''','''+@storeID+''')) as oli inner join '+@Linecut+' as v on oli.AdjustID=v.ID and oli.StoreID=v.StoreID			
	LEFT outer JOIN menuItem MI ON MI.ID = oli.itemid and mi.StoreID=oli.StoreID
	where oli.RecordType = '''+@Linecut+''' AND MI.MIType <>''IHPYMNT'' '
	set @Sql+=' group by v.Name'

--select @Sql
exec sp_executesql @sql
end
GO
