SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE proc [dbo].[Rpt_ReopenCheckAll]
(
	@BeginDate datetime,
	@EndDate datetime,
	@StoreID nvarchar(200)
)
as
begin
declare @tabel1 nvarchar(max)
declare @sql nvarchar(max)
SET NOCOUNT ON;
set @sql='if exists (select * from tempdb.dbo.sysobjects where id = object_id(N''tempdb..#tempOrder'') and type=''U'')
drop table #tempOrder
select * into #tempOrder from [dbo].[fnOrderTable]('''+ Convert(nvarchar,@BeginDate,120)+ ''','''+ Convert(nvarchar,@EndDate,120) + ''','''+convert(nvarchar(20),@storeID)+''')
SELECT pbh.StoreID,Store.StoreName,pbh.OrderID, 
		pbh.MethodID, 
		pbh.Amount, 
           e.FirstName + '' '+ ''' + e.LastName AS PullbackedBy,
           e1.FirstName + '' '+ ''' + e1.LastName AS ServerName, 
           pbh.checkID, 
           pbh.Seat, 
           pbh.PullBackDate,  
           pbh.ToTable , 
           o.TableName 
FROM          PullBackHistory pbh
INNER JOIN Employee e ON pbh.UserID = e.ID   and e.storeid=pbh.storeid
INNER JOIN  Employee e1 ON pbh.ServerID = e1.ID and e1.storeid=pbh.storeid
INNER JOIN #tempOrder o ON pbh.OrderID = o.ID  and o.storeid=pbh.storeid  and o.BusinessDate=Convert(nvarchar(20),pbh.PullBackDate,23)+'' 00:00:00''
inner join Store on pbh.StoreID =Store.ID
WHERE Convert(nvarchar(20),pbh.PullBackDate,23)+'' 00:00:00'' BETWEEN '''+ Convert(nvarchar,@BeginDate,120)+ ''' AND '''+ Convert(nvarchar,@EndDate,120) + '''
and pbh.StoreID in ('+CONVERT(nvarchar,@StoreID)+') ORDER BY pbh.OrderID,pbh.StoreID,Store.StoreName'
--select @sql
exec sp_executesql @sql
end

GO
