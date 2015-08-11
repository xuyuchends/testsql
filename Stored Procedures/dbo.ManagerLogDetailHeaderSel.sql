SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE proc [dbo].[ManagerLogDetailHeaderSel]
(
	@StoreID int,
	@ParentManagerLog int,
	@Year int,
	@month int
)
as
declare @sql nvarchar(max)
declare @sqlWhere nvarchar(200)
set @sqlWhere=''
if ISNULL(@Year,0)<>0
begin
	set @sqlWhere=' and DATEPART(Year,mh.LogDate)='+convert(nvarchar(20),@Year)
	
end
if ISNULL(@month,0)<>0
begin
	set @sqlWhere=@sqlWhere+' and DATEPART(MONTH,mh.LogDate)='+convert(nvarchar(20),@month)
end

if ISNULL(@sqlWhere,'')<>''
begin
	set @sql='
select  mh.*,
		ml.Name,
		eu.FirstName+'' ''+eu.LastName as UserName
from ManagerLogDetailHeader mh
inner join EnterpriseUser eu on eu.ID=mh.UserID 
left join ManagerLog ml on mh.ManagerLogID=ml.ID
where mh.ManagerLogID='+convert(nvarchar(20),@ParentManagerLog )+'
and mh.StoreID='+convert(nvarchar(20),@StoreID)+' '+@sqlWhere
end
else
begin
	set @sql='
select  mh.*,
		ml.Name,
		eu.FirstName+'' ''+eu.LastName as UserName
from ManagerLogDetailHeader mh
inner join EnterpriseUser eu on eu.ID=mh.UserID 
left join ManagerLog ml on mh.ManagerLogID=ml.ID
where mh.ManagerLogID='+convert(nvarchar(20),@ParentManagerLog )+'
and mh.StoreID='+convert(nvarchar(20),@StoreID)
end

set @sql=@sql+' order by mh.UpdateDate desc'

print @sql
--select @sql
execute sp_executesql @sql
GO
