SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE Procedure [dbo].[Rpt_D_TableSummaryByPeriodAll]
	@BeginDate datetime,
	@EndDate datetime,
	@storeID nvarchar(200),
	@ByYear char(1),
	@ByWeek char(1)
AS
begin
Declare @Sql as nvarchar(max)
Declare @Table1 as nvarchar(max)
declare @selSql nvarchar(max)
declare @groupBySql nvarchar(max)
declare @jonTable nvarchar(max)
declare @colSql nvarchar(max)
declare @SalesTypeSql nvarchar(max)
declare @colName nvarchar(200)
set @groupBySql=''
set @selSql=''
set @jonTable=''
set @SalesTypeSql=''
select  @colName =dbo.fn_GetMealPeriod(@storeID)

if ISNULL(@ByYear,'')='Y'
begin
	set @groupBySql=@groupBySql+',datepart(m, o.BusinessDate)'
	set @selSql=@selSql+',    case when datepart(m, o.BusinessDate)=1 then ''Jan'' 
				when datepart(m, o.BusinessDate)=2 then ''Feb'' 
				when datepart(m, o.BusinessDate)=3 then ''March''
				when datepart(m, o.BusinessDate)=4 then ''April''
				when datepart(m, o.BusinessDate)=5 then ''May''
				when datepart(m, o.BusinessDate)=6 then ''June''
				when datepart(m, o.BusinessDate)=7 then ''July''
				when datepart(m, o.BusinessDate)=8 then ''Aug''
				when datepart(m, o.BusinessDate)=9 then ''Sep''
				when datepart(m, o.BusinessDate)=10 then ''Oct''
				when datepart(m, o.BusinessDate)=11 then ''Nov''
				when datepart(m, o.BusinessDate)=12 then ''Dec'' end period ,datepart(m, o.BusinessDate) periodID'
	
end
if ISNULL(@ByWeek,'')='Y'
begin
	set @groupBySql=@groupBySql+',datepart(WEEKDAY,o.BusinessDate)'
	set @selSql=@selSql+',case when DATEPART(WEEKDAY,o.BusinessDate)=1 then ''SUNDAY''
							when DATEPART(WEEKDAY,o.BusinessDate)=2 then ''MONDAY''
							when DATEPART(WEEKDAY,o.BusinessDate)=3 then ''TUESDAY''
							when DATEPART(WEEKDAY,o.BusinessDate)=4 then ''WEDNESDAY''
							when DATEPART(WEEKDAY,o.BusinessDate)=5 then ''THURSDAY''
							when DATEPART(WEEKDAY,o.BusinessDate)=6 then ''FRIDAY''
							when DATEPART(WEEKDAY,o.BusinessDate)=7 then ''SATURDAY'' end period,datepart(WEEKDAY, o.BusinessDate) periodID'
end
SET @Sql = '

if exists (select * from tempdb.dbo.sysobjects where id = object_id(N''tempdb..#tempOrder'') and type=''U'') 
drop table #tempOrder

select *,dbo.[f_GetOrderMealPeriodRpt](OpenTime,StoreID) SaleGroup into #tempOrder from [dbo].[fnOrderTable]('''+ Convert(nvarchar,@BeginDate,120)+ ''','''+ Convert(nvarchar,@EndDate,120) + ''','''+@storeID+''')
		
	select * from (	 Select o.SaleGroup MealPriod'+@selSql+',
	count(o.ID) as NumTables
	--sum(o.GuestCount) as NumGuest   
	From #tempOrder as o  '
set @Sql+=' group by SaleGroup '+@groupBySql+')a pivot (sum(NumTables) for MealPriod in('+@colName+')) b order by periodID'
--select @Sql
exec sp_executesql @sql
end
GO
