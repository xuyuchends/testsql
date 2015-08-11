SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[sel_AdjustmentRpt]
(
	@storeID int,
	@AdjustType nvarchar(20)
)
as
begin
set nocount on
declare @sql nvarchar(max)
set @sql ='select distinct Name+'''+'('+@AdjustType+')'+''' as Name  from  '+@AdjustType
if @storeID>0
begin
	set @sql+= ' where storeID='+CONVERT(nvarchar,@storeID) 
end
exec sp_executesql @sql
end 
GO
