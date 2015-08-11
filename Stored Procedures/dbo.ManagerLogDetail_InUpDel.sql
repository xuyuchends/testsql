SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[ManagerLogDetail_InUpDel]
@ID int,
@ManagerLogID int,
@HeaderID int,
@UserID int,
@Flag bit,
@LogEntry text,
@UpdateDate datetime,
@SQLOperationType nvarchar(50)

AS
BEGIN
	SET NOCOUNT ON;
	if @SQLOperationType='SQLInsert'
	begin
		--declare @storeID int
		--declare @stroreName nvarchar(50)
		--declare @storeNumber nvarchar(20)
		--select @storeID=StoreID from ManagerLogDetailHeader where ID=@HeaderID
		
		--select @stroreName=StoreName,@storeNumber=StoreNumber from Store where ID=@storeID
		
		INSERT INTO ManagerLogDetail
           (HeaderId,ManagerLogID,UserID,Flag,LogEntry,UpdateDate)
		VALUES
           (@HeaderID,@ManagerLogID,@UserID,@Flag,@LogEntry,@UpdateDate)
	end
	else if @SQLOperationType='SQLUpdate'
	begin
		UPDATE ManagerLogDetail SET    UserID = @UserID
									  ,Flag = @Flag
									  ,LogEntry=@LogEntry
									  ,UpdateDate=@UpdateDate
	WHERE ID=@ID
	end
	else if @SQLOperationType='SQLDelete'
	begin
		delete from ManagerLogDetail where ID=@ID
	end 
	
END
GO
