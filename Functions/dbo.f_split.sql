SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE function [dbo].[f_split]
(
@s     varchar(8000),  --需要分割的字符串
@split varchar(10)  --分割字符   
)returns table --返回分割后的table 例如：例如字符串'1,2,3,4,5' 将编程一个表，这个表(sample (1,3,4,5)
as
 return
 (
  select substring(@s,number,charindex(@split,@s+@split,number)-number)as col
  from master..spt_values
  where type='p' and number<=len(@s+'a') 
  and charindex(@split,@split+@s,number)=number
  )
  
GO
