SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create proc [dbo].[Rpt_PaidOutSummaryAll]
(
	@BeginDate datetime,
	@endDate datetime,
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

select e1.FirstName + '' ' +''' +e1.LastName AS EmpName,
        e2.FirstName+ '' ' +''' + e2.LastName AS ManagerName ,
        PaidOut.Name CategoryName,
		POT.*,
		Store.StoreName
        FROM #tempPaidOutTrx POT LEFT OUTER JOIN 
        Employee as e1 ON POT.ManagerID = e1.ID and POT.StoreID=e1.StoreID LEFT OUTER JOIN 
        Employee as e2 ON POT.EmployeeID = e2.ID  and POT.StoreID=e2.StoreID
        inner join PaidOut on PaidOut.ID=POT.ID and PaidOut.StoreID=POT.StoreID
        inner join Store on POT.StoreID=Store.ID'
--select @sql
exec sp_executesql @sql
end
        
       
GO
