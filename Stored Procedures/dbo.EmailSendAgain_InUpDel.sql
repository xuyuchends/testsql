SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[EmailSendAgain_InUpDel]
	@SQLOperationType nvarchar(50),
	@ID int,
	@Type nvarchar(50),
	@Subject nvarchar(200),
	@ContentText nvarchar(max),
	@AddressTo nvarchar(max),
	@HasSend bit,
	@StoreID int,
	@FromUserID int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	if	@SQLOperationType='SQLInsert'
	begin
		INSERT INTO [EmailSendAgain]
           ([Type]
           ,[Subject]
           ,[ContentText]
           ,[AddressTo]
           ,sendtime
           ,HasSend
           ,StoreID
           ,FromUserID
           )
     VALUES
           (@Type
           ,@Subject
           ,@ContentText
           ,@AddressTo
           ,GETDATE()
           ,@HasSend
           ,@StoreID
           ,@FromUserID
           )
	end
END
GO
