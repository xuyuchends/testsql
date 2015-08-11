SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fn_GetParentCategory]
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
    while (select COUNT(*) from Inv_ItemCategory where ID=@CategoryID)> 0 
    begin
		set @ParentCategory=@ParentCategory+'/'+
		(select CONVERT(nvarchar(20), REVERSE(name)) from Inv_ItemCategory where ID=@CategoryID)
		select @CategoryID=ParentID from Inv_ItemCategory where ID=@CategoryID
    end

	-- Return the result of the function
	RETURN substring( REVERSE(@ParentCategory),1,len(@ParentCategory)-1)

END
GO
