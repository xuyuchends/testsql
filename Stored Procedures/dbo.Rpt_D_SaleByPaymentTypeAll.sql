SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE Procedure [dbo].[Rpt_D_SaleByPaymentTypeAll]
	@BeginDate datetime,	
	@EndDate datetime,
	@storeID nvarchar(200),
	@ByYear char(1),
	@ByWeek char(1)
AS
begin
declare @sql as nvarchar(max)
SET NOCOUNT ON;
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
select  @colName =dbo.fn_GetPaymentName(@storeID)

if ISNULL(@ByYear,'')='Y'
begin
	set @groupBySql=@groupBySql+',datepart(m, p.BusinessDate)'
	set @selSql=@selSql+',    case when datepart(m, p.BusinessDate)=1 then ''Jan'' 
				when datepart(m, p.BusinessDate)=2 then ''Feb'' 
				when datepart(m, p.BusinessDate)=3 then ''March''
				when datepart(m, p.BusinessDate)=4 then ''April''
				when datepart(m, p.BusinessDate)=5 then ''May''
				when datepart(m, p.BusinessDate)=6 then ''June''
				when datepart(m, p.BusinessDate)=7 then ''July''
				when datepart(m, p.BusinessDate)=8 then ''Aug''
				when datepart(m, p.BusinessDate)=9 then ''Sep''
				when datepart(m, p.BusinessDate)=10 then ''Oct''
				when datepart(m, p.BusinessDate)=11 then ''Nov''
				when datepart(m, p.BusinessDate)=12 then ''Dec'' end period ,datepart(m, p.BusinessDate) periodID'
	
end
if ISNULL(@ByWeek,'')='Y'
begin
	set @groupBySql=@groupBySql+',datepart(WEEKDAY,p.BusinessDate)'
	set @selSql=@selSql+',case when DATEPART(WEEKDAY,p.BusinessDate)=1 then ''SUNDAY''
							when DATEPART(WEEKDAY,p.BusinessDate)=2 then ''MONDAY''
							when DATEPART(WEEKDAY,p.BusinessDate)=3 then ''TUESDAY''
							when DATEPART(WEEKDAY,p.BusinessDate)=4 then ''WEDNESDAY''
							when DATEPART(WEEKDAY,p.BusinessDate)=5 then ''THURSDAY''
							when DATEPART(WEEKDAY,p.BusinessDate)=6 then ''FRIDAY''
							when DATEPART(WEEKDAY,p.BusinessDate)=7 then ''SATURDAY'' end period,datepart(WEEKDAY, p.BusinessDate) periodID'
end

set @sql='  
if exists (select * from tempdb.dbo.sysobjects where id = object_id(N''tempdb..#tempPayment'') and type=''U'') 
drop table #tempPayment
select * into #tempPayment from [dbo].[fnPaymentTable]('''+ Convert(nvarchar,@BeginDate,120)+ ''','''+ Convert(nvarchar,@EndDate,120) + ''','''+@storeID+''')

select * from (SELECT pm.Name as PaymentName'+@selSql+', 
isnull(SUM(p.Amount),0) AS Sales
FROM  #tempPayment AS p 
	INNER JOIN PaymentMethod AS pm ON p.MethodID = pm.Name AND pm.StoreID = p.StoreID '
set @sql+=' GROUP BY pm.Name '+@groupBySql+')a pivot (sum(Sales) for PaymentName in('+@colName+')) b order by periodID'


exec sp_executesql @sql
--select @sql
end
GO
