SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[sel_JobDistinctName]
	@storeID nvarchar(20)
as
declare @sqlAll nvarchar(max)
declare @Separator char(1)
declare @Input nvarchar(200)
declare @sql nvarchar(max)
declare @count int

set @Separator=','
set @Input=@storeID+','
set @count=1
set @sql=''
declare @Index int, @Entry nvarchar(max)
    set @Index = charindex(@Separator,@Input)

    while (@Index>0)
    begin
        set @Entry=ltrim(rtrim(substring(@Input, 1, @Index-1)))
        
        if @Entry<>''
        begin
			set @sql=@sql+' and name in(select name from Position po where StoreID='+@Entry+' and isnull(po.AllowShiftTrades,0)=isnull(p.AllowShiftTrades,0) and isnull(po.ManagerApprovalforTrades,0)=isnull(p.ManagerApprovalforTrades,0) and isnull(po.[View/PrintAllSchedules],0) = isnull(p.[View/PrintAllSchedules],0))'
        end

        set @Input = substring(@Input, @Index+datalength(@Separator)/2+1, len(@Input))
        set @Index = charindex(@Separator, @Input)
        set @count=@count+1
    end
   
set @sqlAll='select distinct name from Position p where StoreID in ('+@storeID+')'+@sql
--select @sqlAll
execute sp_executesql @sqlAll


GO
