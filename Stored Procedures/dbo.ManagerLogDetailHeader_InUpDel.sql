SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[ManagerLogDetailHeader_InUpDel]
@ID int,
@ManagerLogID int,
@UserID int,
@StoreID int,
@logDate datetime,
@SQLOperationType nvarchar(50)

AS
BEGIN
	SET NOCOUNT ON;
	if @SQLOperationType='SQLInsert'
	begin
		insert into ManagerLogDetailHeader (ManagerLogID,UserID,StoreID,UpdateDate,LogDate)
		values(@ManagerLogID,@UserID,@StoreID,GETDATE(),@logDate)
		return @@IDENTITY
	end
	else if @SQLOperationType='SQLUpdate'
	begin
		UPDATE ManagerLogDetailHeader SET  UserID = @UserID, StoreID=@StoreID,UpdateDate=GETDATE(),LogDate=@logDate WHERE ID=@ID
		select @@ERROR
	end
	else if @SQLOperationType='SQLDelete'
	begin
		begin try
			begin tran
		
			delete from ManagerLogDetail where headerID =@ID
			delete from ManagerLogDetailHeader where ID=@ID
			select @@ERROR
		commit tran
		end try
		begin catch
			rollback tran
			select @@ERROR
		end catch
	end 
END
GO
