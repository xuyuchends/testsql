SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[TranInsUpd_FoundationMessageLog]
@storeid int,
@IsCalculating bit
AS
BEGIN
	declare @PreTime datetime
	declare @LastTime datetime
	select @PreTime=PreTime,@LastTime=LastTime from FoundationMessageLog where storeid=@storeid
	if @@ROWCOUNT>0
	begin
		update FoundationMessageLog set PreTime=@LastTime,LastTime=GETDATE(),IsCalculating=@IsCalculating where storeID=@storeid
	end
	else
	begin
		insert into FoundationMessageLog (storeid,PreTime,LastTime,IsCalculating) values (@storeid,GETDATE(),GETDATE(),@IsCalculating)
	end
END
GO
