SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Inv_ItemCostingSetup_InUpDel]
(
	@Name nvarchar(50),
	@Value nvarchar(50),
	@LastUpdate datetime,
	@Creator int,
	@Editor int,
	@SQLOperationType nvarchar(50)
)
as
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	if (@SQLOperationType='INORUP')
		begin
			update Inv_ItemCostingSetup set Value=@Value,Editor=@Editor,LastUpdate=GETDATE() from  Inv_ItemCostingSetup
			where Name = @Name
			if (@@ROWCOUNT=0)
			INSERT INTO [Inv_ItemCostingSetup]([Name],[Value],[LastUpdate],[Creator],[Editor]) VALUES
           (@Name,@Value,GETDATE(),@Creator,@Creator)
		end
END
GO
