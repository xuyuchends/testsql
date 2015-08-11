SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
create FUNCTION [dbo].[fn_GetParentMenuItemCategory]
(
	-- Add the parameters for the function here
	@CategoryID bigint
)
RETURNS nvarchar(max)
AS
BEGIN
	-- Declare the return variable here
	declare @ParentCategory nvarchar(max)
    set @ParentCategory=''
    while (select COUNT(*) from Inv_menuItemCategory where ID=@CategoryID)> 0 
    begin
		set @ParentCategory=@ParentCategory+'/'+
		(select CONVERT(nvarchar(20), REVERSE(name)) from Inv_menuItemCategory where ID=@CategoryID)
		select @CategoryID=ParentID from Inv_menuItemCategory where ID=@CategoryID
    end

	-- Return the result of the function
	RETURN substring( REVERSE(@ParentCategory),1,len(@ParentCategory)-1)

END
GO
