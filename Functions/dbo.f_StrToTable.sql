SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE Function [dbo].[f_StrToTable](@str nvarchar(2000))
Returns @tableName Table
(
   str varchar(50)
)
As
--该函数用于把一个用逗号分隔的多个数据字符串变成一个表的一列，例如字符串'1,2,3,4,5' 将编程一个表，这个表(sample (1,3,4,5)
Begin
	set @str= LEFT(@str,LEN(@str)-1)
	set @str= right(@str,LEN(@str)-1)
	set @str = @str+','
Declare @insertStr nvarchar(50) --截取后的第一个字符串
Declare @newstr nvarchar(2000) --截取第一个字符串后剩余的字符串
set @insertStr = left(@str,charindex(',',@str)-1)
set @newstr = stuff(@str,1,charindex(',',@str),'')
Insert @tableName Values(@insertStr)
while(len(@newstr)>0)
begin
   set @insertStr = left(@newstr,charindex(',',@newstr)-1)
   Insert @tableName Values(@insertStr)
   set @newstr = stuff(@newstr,1,charindex(',',@newstr),'')
end
Return
End
GO
