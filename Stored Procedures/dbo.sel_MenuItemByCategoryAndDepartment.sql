SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[sel_MenuItemByCategoryAndDepartment]
	@storeID nvarchar(20),
	@Category nvarchar(50),
	@Department nvarchar(50)
as
declare @sqlAll nvarchar(max)
declare @Separator char(1)
declare @Input nvarchar(200)
declare @sql nvarchar(max)
declare @count int
set @count=0
declare @sqlWhere nvarchar(200)
set @sqlWhere=''
if ISNULL(@Department,'')<>''
begin
	set @sqlWhere=@sqlWhere+' and ReportDepartment='''+@Department+''''
end
if ISNULL(@Category,'')<>''
begin
	set @sqlWhere=@sqlWhere+' and ReportCategory='''+@Category+''''
end

set @Separator=','
set @Input=@storeID+','
set @sql=''
declare @Index int, @Entry nvarchar(max)
    set @Index = charindex(@Separator,@Input)

    while (@Index>0)
    begin
        set @Entry=ltrim(rtrim(substring(@Input, 1, @Index-1)))
        
        if @Entry<>''
        begin
			set @sql=@sql+' and ReportName in(select ReportName from MenuItem where StoreID='+@Entry+' and ReportDepartment = '''+@Department+''' and ReportCategory='''+@Category+''')'
        end

        set @Input = substring(@Input, @Index+datalength(@Separator)/2+1, len(@Input))
        set @Index = charindex(@Separator, @Input)
    end
   
set @sqlAll='select distinct ReportName,ReportCategory,ReportDepartment from MenuItem where StoreID in ('+@storeID+') '+@sqlWhere+@sql
--select @sqlAll
execute sp_executesql @sqlAll
GO
