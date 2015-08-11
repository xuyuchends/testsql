SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create proc [dbo].[Rpt_PaidOutDetailAll]
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
if exists (select * from tempdb.dbo.sysobjects where id = object_id(N''tempdb..#tempPaidOutTrx'') and type=''U'')
drop table #tempPaidOutTrx
select * into #tempPaidOutTrx from [dbo].[fnPaidOutTrxTable]('''+ Convert(nvarchar,@BeginDate,120)+ ''','''+ Convert(nvarchar,@EndDate,120) + ''','''+convert(nvarchar(20),@storeID)+''')
SELECT  Store.ID StoreID,Store.StoreName,e1.FirstName  + '' ' +''' + e1.LastName AS ManagerName,
		e2.FirstName  + '' ' +''' +  e2.LastName AS EmpName, 
		PaidOut.Name CategoryName,
		pot.id,pot.amount,pot.Note,pot.Status,pot.LastUpdate,pot.BusinessDate
FROM #tempPaidOutTrx as pot LEFT OUTER JOIN 
        Employee e1 ON pot.ManagerID = e1.ID and pot.StoreID=e1.StoreID LEFT OUTER JOIN
        Employee e2 ON pot.EmployeeID = e2.ID and pot.StoreID=e2.StoreID
        inner join PaidOut on pot.ID=PaidOut.ID and pot.StoreID=PaidOut.StoreID
        inner join Store on pot.StoreID=Store.ID'
set @Sql+=' order by BusinessDate'
--select @sql
exec sp_executesql @sql
end

GO
