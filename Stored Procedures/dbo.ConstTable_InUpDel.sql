SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create PROCEDURE [dbo].[ConstTable_InUpDel]
	@ID [int],
	@value [nvarchar](50),
	@category [nvarchar](50),
	@SQLOperationType [nvarchar](50)
WITH EXECUTE AS CALLER
AS
BEGIN

	SET NOCOUNT ON;
	if (@SQLOperationType='SQLUpdate')
		UPDATE [ConstTable] SET [Value] = @value WHERE Category =@category and ID=@ID
END
GO
