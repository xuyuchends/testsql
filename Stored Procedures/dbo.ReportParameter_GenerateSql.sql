SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[ReportParameter_GenerateSql]

as
declare @sql nvarchar(max)
declare @ParaID int
declare @ReportDetailID int
declare @ParaName nvarchar(50)
declare @Desc nvarchar(50)
set @sql=''
declare cur cursor  for select paraID,reportDetailID,ParaName,Description from ReportParameter
open cur
fetch next from cur into @ParaID,@ReportDetailID,@ParaName,@Desc
while @@FETCH_STATUS=0
begin
	set @sql=@sql+'insert into ReportParameter values('+CONVERT(nvarchar(20),@ParaID)+','+CONVERT(nvarchar(20),@ReportDetailID)+','''
	+@ParaName+''','''+@Desc+''')'
	fetch next from cur into @ParaID,@ReportDetailID,@ParaName,@Desc
end
close cur
deallocate cur
select @sql
GO
