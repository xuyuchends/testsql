SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [dbo].[fn_GetSendTo]
(
	@SendTo nvarchar(2000)
)  
 
RETURNS nvarchar(100)
 
 AS  
 
 BEGIN 
 	declare @Name varchar(100)
 	declare @StoreName nvarchar(50)
    declare @retValue nvarchar(100)
    declare @Value nvarchar(50)
    set @retValue=''
declare cur cursor
read_only
for select * from dbo.f_split(@SendTo,',')

open cur
fetch next from cur into @Name
while(@@fetch_status=0)

begin
	if ISNULL(@Name,'') <>'AllStore' and ISNULL(@Name,'') <>'EVERYONE' and substring(@Name,0,4)<>'ALL '
	and (charindex('@',@Name)=0 or charindex('.',@Name)=0)
	begin
		if substring(@Name,1,2)='s-'
		begin
		set @StoreName=''
			select @StoreName=StoreName from Store where id=substring(@Name,3,(len(@Name)-2))
			if @retValue=''
			begin
				set @retValue=@retValue+@StoreName
			end
			else
			begin
				set @retValue=@retValue+','+@StoreName
			end
		end
		else if substring(@Name,1,2)='j-'
		begin
		set @StoreName=''
			select @StoreName=Name from position where id=substring(@Name,3,(len(@Name)-2))
			if @retValue=''
			begin
				set @retValue=@retValue+'All '+@StoreName
			end
			else
			begin
				set @retValue=@retValue+','+'All '+@StoreName
			end
		end
		else if substring(@Name,1,2)='e-'
		begin
		set @StoreName=''
			select @StoreName=firstName+' '+lastname from enterpriseUser where id=substring(@Name,3,(len(@Name)-2)) 
			if @retValue=''
			begin
				set @retValue=@retValue+@StoreName
			end
			else
			begin
				set @retValue=@retValue+','+@StoreName
			end
		end
		else
		begin
			select @Value =(Firstname+' '+lastname)  from enterpriseUser where id=@name  
			if @retValue=''
			begin
				set @retValue=@retValue+@Value
			end
			else
			begin
				set @retValue=@retValue+','+@Value
			end
			
		end
	
	end
	else
	begin
		if @retValue=''
			begin
				set @retValue=@retValue+@Name
			end
			else
			begin
				set @retValue=@retValue+','+@Name
			end
	end
fetch next from cur into @Name
end
close cur
deallocate cur
 
 	RETURN @retValue
 
 END
 
GO
