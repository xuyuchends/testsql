SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
 
 CREATE proc [dbo].[sel_Job]
(
	@StoreID nvarchar(200),
	@JobID int,
	@jobName nvarchar(50)
)
as
declare @sql nvarchar(max)
declare @sqlwhere nvarchar(200)
set @sqlwhere=''
if ISNULL(@StoreID,'')<>''
begin
		set @sqlwhere=' where StoreID in ('+convert(nvarchar(20),@StoreID)+')'
end
if ISNULL(@jobName,'')<>''
begin
	if ISNULL(@sqlwhere,'')=''
	begin
		set @sqlwhere=' where name = '''+@jobName+''''
	end
	else
	begin
		set @sqlwhere=@sqlwhere+' and name = '''+@jobName+''''
	end
end
if ISNULL(@JobID,0)<>0
begin
	if ISNULL(@sqlwhere,'')=''
	begin
		set @sqlwhere=' where id = '+convert(nvarchar(20),@JobID)
	end
	else
	begin
		set @sqlwhere=@sqlwhere+' and id = '+convert(nvarchar(20),@JobID)
	end
end

set @sql=' select * from Position '+@sqlwhere+' order by Name'
execute sp_executesql  @sql
--select @sql

GO
