SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create proc [dbo].[Rpt_PaidInDetailAll]
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


SELECT  Store.ID StoreID,Store.StoreName,e1.FirstName + '' ' +''' + e1.LastName AS ManagerName ,
		e2.FirstName + '' ' +''' +e2.LastName AS EmpName,
		e1.ID ManagerID,
		e2.ID ServerID,
		p.Name CategoryName,
		pit.id,pit.amount,pit.Note,pit.Status,pit.LastUpdate,pit.BusinessDate
FROM	#tempPaidInTrx as  pit LEFT OUTER JOIN 
        Employee as e1 ON pit.ManagerID = e1.ID and pit.StoreID=e1.StoreID LEFT OUTER JOIN
        Employee as e2 ON pit.EmployeeID = e2.ID and pit.StoreID=e2.StoreID
        inner join PaidIn p on pit.ID=p.ID and pit.StoreID=p.StoreID
        inner join Store on Store.ID=pit.StoreID'

--select @sql
exec sp_executesql @sql
end
 
GO
