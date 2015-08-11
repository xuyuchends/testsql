SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[DocumentCateogry_sel]
	@ID int,
	@Name nvarchar(50),
	@type int
AS
BEGIN

	if @type=1
	begin
		SELECT [ID],[Name]
		FROM [DocumentCateogry]
	end
	else if @type=2
	begin
		SELECT [ID],[Name]
		FROM [DocumentCateogry]
		where [ID]=@ID
	end
	else if @type=3
	begin
		SELECT  FilePath
		FROM  DocumentManager where CategoryID=@ID
	end
END
GO
