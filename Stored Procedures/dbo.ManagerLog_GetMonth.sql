SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[ManagerLog_GetMonth]
(
	@StoreID nvarchar(20),
	@Year int,
	@ManagerLogID int
)
as
declare @sql nvarchar(2000)
declare @sqlWhere nvarchar(200)
if ISNULL(@Year,0)<>0
begin
	set @sqlWhere='and DATEPART(YEAR,LogDate)='+convert(nvarchar(10),@Year)
end
set @sql='
select  DATEPART(MONTH, LogDate) as Month from ManagerLogDetailHeader  
where StoreID in ('+@StoreID+') and ManagerLogID ='+convert(nvarchar(10),@ManagerLogID)

if ISNULL(@sqlWhere,'')<>''
begin
	set @sql=@sql+@sqlWhere+' group by DATEPART(MONTH,LogDate)'
end
else
begin
	set @sql=@sql+' group by DATEPART(MONTH,LogDate)'
end
execute sp_executesql @sql

GO
