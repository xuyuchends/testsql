SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Inv_TransferDetailInUpDel]
	-- Add the parameters for the stored procedure here
	@TransferID int,
	@InvItemID int,
	@Qty decimal(18,2),
	@sqlType nvarchar(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    if @sqlType='SQLINSERT'
	insert into Inv_TransferDetail values(@TransferID,@InvItemID,@Qty)
	else if @sqlType='SQLDELETE'
	delete from Inv_TransferDetail where TransferID=@TransferID
END
GO
