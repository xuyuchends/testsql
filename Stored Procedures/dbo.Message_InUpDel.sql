SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Message_InUpDel]
@SQLOperationType nvarchar(50),
@ID int,
@Subject nvarchar(50),
@Content nvarchar(max),
@UserID  int,
@ParentID int,
@SendTo nvarchar(max),
@StoreID int,
@DelUserID nvarchar(20)
AS
BEGIN
	declare @oldDelUserID nvarchar(2000)
	if @SQLOperationType='SQLInsert'
	begin
		insert  into  MessageManager
			(MsgSubject,
			MsgContent,
			UserID,
			ParentID,
			SendTo,
			StoreID,
			SendDate,
			DelUserID)
		values (@Subject,@Content,@UserID,@ParentID,@SendTo,@StoreID,GETDATE(),'')
	select @@IDENTITY
	end
	else if @SQLOperationType='SQLUpdate'
	begin
		select @oldDelUserID =DelUserID from MessageManager where ID=@ID
		if ISNULL(@oldDelUserID,'')<>''
		begin
			set @DelUserID=@oldDelUserID+','+@DelUserID
		end
		update MessageManager 
		set  MsgSubject=@Subject,MsgContent=@Content,UserID=@UserID,ParentID=@ParentID,SendTo=@SendTo,StoreID=@StoreID,DelUserID=@DelUserID
		where ID=@ID
	end
	else if @SQLOperationType='SQLDelete'
	begin
		delete from MessageManager where ID=@ID
	end
END
GO
