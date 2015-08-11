SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Inv_CountPeriods_InUpDel]
(
	@ID int,
	@Name nvarchar(200),
	@Period int,
	@DayofWeek int,
	@LastUpdate datetime,
	@Creator int,
	@Editor int,
	@SQLOperationType nvarchar(50)
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	if(@SQLOperationType='SQLINSERT')
	begin
		INSERT INTO [Inv_CountPeriods]([Name],[Period],[DayofWeek],[LastUpdate],[Creator],[Editor])
		VALUES(@Name,@Period,@DayofWeek, GETDATE(), @Creator,@Creator)
		select @@IDENTITY
	end
	else if @SQLOperationType='SQLUPDATE'
	begin
		UPDATE [Inv_CountPeriods] SET [Name] = @Name,[Period] = @Period,[DayofWeek] = @DayofWeek,[LastUpdate] = GETDATE(),[Editor] = @Editor 
		WHERE ID=@ID
	end
	else if @SQLOperationType='SQLDELETE'
	begin
		delete from [Inv_CountPeriods] WHERE ID=@ID
	end
END
GO
