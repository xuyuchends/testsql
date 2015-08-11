SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE proc [dbo].[Rpt_D_NumGuestSummaryByStoreAll]
(
	@BeginDate datetime,
	@EndDate datetime,
	@storeID nvarchar(200),
	@ByYear char(1),
	@ByWeek char(1)
)
as
declare @sql nvarchar(max)
declare @selSql nvarchar(max)
declare @groupBySql nvarchar(max)
declare @jonTable nvarchar(max)
declare @colSql nvarchar(max)
declare @SalesTypeSql nvarchar(max)
declare @colName nvarchar(20)
SET NOCOUNT ON;
set @groupBySql=''
set @selSql=''
set @jonTable=''
set @SalesTypeSql=''
set @colName=''
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
select @colSql= dbo.fn_GetStoreName(@storeID)
set @sql='

if exists (select * from tempdb.dbo.sysobjects where id = object_id(N''tempdb..#tempOrder'') and type=''U'')  
drop table #tempOrder

select * into #tempOrder from [dbo].[fnOrderTable]('''+ Convert(nvarchar,@BeginDate,120)+ ''','''+ Convert(nvarchar,@EndDate,120) + ''','''+@storeID+''')
select * from (Select s.StoreName as StoreName'+@selSql+',
sum(o.GuestCount) as NumGuests
From #tempOrder as o inner join Store as s ON o.StoreID = s.ID  Group by s.StoreName'+@groupBySql+') a pivot (sum(NumGuests) for StoreName in('+@colSql+')) b order by periodID'


execute sp_executesql @sql
--select @sql

GO
