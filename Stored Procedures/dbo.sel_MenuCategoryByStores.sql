SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[sel_MenuCategoryByStores]
	@storeID nvarchar(20)
as
declare @sqlAll nvarchar(max)
declare @Separator char(1)
declare @Input nvarchar(200)
declare @sql nvarchar(max)
declare @count int

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
			set @sql=@sql+' and ReportCategory in(select ReportCategory from MenuItem where StoreID='+@Entry+')'
        end

        set @Input = substring(@Input, @Index+datalength(@Separator)/2+1, len(@Input))
        set @Index = charindex(@Separator, @Input)
    end
   
set @sqlAll='select distinct ReportCategory,ReportDepartment,ReportDepartment+''/''+ReportCategory  CateAndDept from MenuItem where StoreID in ('+@storeID+')'+@sql
--select @sqlAll
execute sp_executesql @sqlAll
GO
