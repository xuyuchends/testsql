SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[EmailSendAgain_Sel]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
SELECT id
      ,[Type]
      ,[Subject]
      ,[ContentText]
      ,[AddressTo]
      ,[SendTime]
      ,[HasSend]
      ,StoreID as storeID
      ,[FromUserID]
       FROM EmailSendAgain
 where [HasSend]=0
END
GO
