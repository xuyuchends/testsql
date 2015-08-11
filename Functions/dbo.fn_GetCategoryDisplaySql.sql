SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[fn_GetCategoryDisplaySql]
(
	-- Add the parameters for the function here
	@CategoryID int
)
RETURNS nvarchar(max)
AS
BEGIN
	-- Declare the return variable here
	declare @ParentDisplaySeq nvarchar(max)
    set @ParentDisplaySeq=''
    while (select COUNT(*) from Inv_ItemCategory where ID=@CategoryID)> 0 
    begin
		set @ParentDisplaySeq=@ParentDisplaySeq+','+
		(select CONVERT(nvarchar(20), REVERSE(DisplaySeq)) from Inv_ItemCategory where ID=@CategoryID)
		select @CategoryID=ParentID from Inv_ItemCategory where ID=@CategoryID
    end

	-- Return the result of the function
	RETURN REVERSE(@ParentDisplaySeq)

END
GO
