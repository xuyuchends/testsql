SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create proc [dbo].[Rpt_PaidInSummaryAll]
(
	@BeginDate datetime,
	@EndDate datetime,
	@StoreID nvarchar(200)
)
as
BEGIN
Declare @Sql as nvarchar(max)
SET NOCOUNT ON;
set @Sql='
if exists (select * from tempdb.dbo.sysobjects where id = object_id(N''tempdb..#tempPaidInTrx'') and type=''U'')
drop table #tempPaidInTrx
select * into #tempPaidInTrx from [dbo].[fnPaidInTrxTable]('''+ Convert(nvarchar,@BeginDate,120)+ ''','''+ Convert(nvarchar,@EndDate,120) + ''','''+convert(nvarchar(20),@storeID)+''')


SELECT PIT.StoreID,Store.StoreName, e1.FirstName + '' ' +''' + e1.LastName AS ManagerName,
        e2.FirstName + '' ' +''' + e2.LastName AS EmpName,	
        Pa.Name CategoryName,	
        pit.id,pit.amount,pit.Note,pit.Status,pit.LastUpdate,pit.BusinessDate
FROM	#tempPaidInTrx PIT LEFT OUTER JOIN 
        Employee e1 ON PIT.ManagerID = e1.ID and PIT.StoreID=e1.StoreID LEFT OUTER JOIN 
        Employee  e2 ON PIT.EmployeeID = e2.ID and PIT.StoreID=e2.StoreID
        inner join PaidIn pa on pa.ID=PIT.ID and pa.StoreID=PIT.StoreID
        inner join Store on PIT.StoreID=Store.ID'
--select @sql
exec sp_executesql @sql
end

GO
