SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create proc [dbo].[Rpt_D_GrossSalesByDeptAll]
(
@BeginDate datetime,					-- begin date
	@EndDate datetime,					-- end date
	@storeID int,
	@ByYear char(1),
	@ByWeek char(1)
)
AS
begin
SET NOCOUNT ON;

declare @sql nvarchar(max)
declare @selSql nvarchar(max)
declare @groupBySql nvarchar(max)
declare @jonTable nvarchar(max)
declare @colSql nvarchar(max)
declare @SalesTypeSql nvarchar(max)
declare @colName nvarchar(2000)
SET NOCOUNT ON;
set @groupBySql=''
set @selSql=''
set @jonTable=''
set @SalesTypeSql=''
set @colName=''
if ISNULL(@ByYear,'')='Y'
begin
	set @groupBySql=@groupBySql+',datepart(m, OI.BusinessDate)'
	set @selSql=@selSql+',    case when datepart(m, OI.BusinessDate)=1 then ''Jan'' 
				when datepart(m, OI.BusinessDate)=2 then ''Feb'' 
				when datepart(m, OI.BusinessDate)=3 then ''March''
				when datepart(m, OI.BusinessDate)=4 then ''April''
				when datepart(m, OI.BusinessDate)=5 then ''May''
				when datepart(m, OI.BusinessDate)=6 then ''June''
				when datepart(m, OI.BusinessDate)=7 then ''July''
				when datepart(m, OI.BusinessDate)=8 then ''Aug''
				when datepart(m, OI.BusinessDate)=9 then ''Sep''
				when datepart(m, OI.BusinessDate)=10 then ''Oct''
				when datepart(m, OI.BusinessDate)=11 then ''Nov''
				when datepart(m, OI.BusinessDate)=12 then ''Dec'' end period ,datepart(m, OI.BusinessDate) periodID'
	
end
if ISNULL(@ByWeek,'')='Y'
begin
	set @groupBySql=@groupBySql+',datepart(WEEKDAY,OI.BusinessDate)'
	set @selSql=@selSql+',case when DATEPART(WEEKDAY,OI.BusinessDate)=1 then ''SUNDAY''
							when DATEPART(WEEKDAY,OI.BusinessDate)=2 then ''MONDAY''
							when DATEPART(WEEKDAY,OI.BusinessDate)=3 then ''TUESDAY''
							when DATEPART(WEEKDAY,OI.BusinessDate)=4 then ''WEDNESDAY''
							when DATEPART(WEEKDAY,OI.BusinessDate)=5 then ''THURSDAY''
							when DATEPART(WEEKDAY,OI.BusinessDate)=6 then ''FRIDAY''
							when DATEPART(WEEKDAY,OI.BusinessDate)=7 then ''SATURDAY'' end period,datepart(WEEKDAY, OI.BusinessDate) periodID'
end
select @colSql= dbo.[fn_GetAllDepartment](@storeID)

set @sql='
if exists (select * from tempdb.dbo.sysobjects where id = object_id(N''tempdb..#tempOrderLineItem'') and type=''U'')  
drop table #tempOrderLineItem 
select * into #tempOrderLineItem from [dbo].[fnOrderLineItemTable]('''+ Convert(nvarchar,@BeginDate,120)+ ''','''+ Convert(nvarchar,@EndDate,120) + ''','''+convert(nvarchar(20),@storeID)+''')

select * from (Select mi.ReportDepartment as Department'+@selSql+',
isnull(SUM(OI.qty * OI.price),0) as GrossSales
From #tempOrderLineItem OI    
LEFT JOIN MenuItem MI ON OI.itemid = MI.ID and oi.StoreID=MI.StoreID  
Where si <> ''N/A''  AND MI.ReportCategory <> ''''    AND MI.ReportCategory IS NOT NULL  and MI.MIType NOT IN (''GC'', ''IHPYMNT'')    Group By mi.ReportDepartment '+@groupBySql+' ) a pivot (sum(GrossSales) for Department in('+@colSql+')) b order by periodID'

--select @sql
exec sp_executesql @sql

end

GO
