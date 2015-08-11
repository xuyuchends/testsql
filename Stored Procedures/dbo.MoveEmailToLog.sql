SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[MoveEmailToLog] 
AS
BEGIN
SET NOCOUNT ON;
declare @ID int
declare @Type nvarchar(50)
declare @Subject nvarchar(200)
declare @ContentText nvarchar(max)
declare @AddressTo nvarchar(max)
declare @SendTime datetime 
declare @HasSend bit
declare @StoreID int
declare @FromUserID int
declare @ErrorMessage nvarchar(max)

declare cur cursor
	for SELECT [ID],[Type],[Subject],[ContentText],[AddressTo],[SendTime],[HasSend],[StoreID],[FromUserID],[ErrorMessage] FROM [EmailSendAgain]
	open cur
	fetch next from cur into @ID,@Type,@Subject,@ContentText,@AddressTo,@SendTime,@HasSend,@StoreID,@FromUserID,@ErrorMessage
	while(@@fetch_status=0)
	begin
		begin try
		if (DATEDIFF(day, @SendTime, GETDATE())>3)
			INSERT INTO [EmailSendAgainLog](ID,[Type],[Subject],[ContentText],[AddressTo],[SendTime],[HasSend],[StoreID],[FromUserID],[ErrorMessage],MoveTime)
			VALUES (@ID,@Type,@Subject,@ContentText,@AddressTo,@SendTime,@HasSend,@StoreID,@FromUserID,@ErrorMessage,GETDATE())
		END TRY
		BEGIN CATCH
		end  CATCH
		fetch next from cur into @ID,@Type,@Subject,@ContentText,@AddressTo,@SendTime,@HasSend,@StoreID,@FromUserID,@ErrorMessage
	end
close cur
deallocate cur
delete from EmailSendAgain where exists (select * from EmailSendAgainLog where EmailSendAgainLog.id=EmailSendAgain.id)
END

GO
