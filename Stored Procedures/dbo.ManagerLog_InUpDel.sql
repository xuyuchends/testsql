SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[ManagerLog_InUpDel]
@ID int,
@Name  nvarchar(50),
@UserID int,
@ParentID int,
@AllowFlagging bit,
@EntryField bit, 
@Description text,
@Sequence int,--序列
@SQLOperationType nvarchar(50)
AS
BEGIN
	SET NOCOUNT ON;
	declare @innerSequence int
		declare @innerID int
		declare @HeaderId int
	if @SQLOperationType='SQLInsert'
	begin
		declare @maxSequence int
		if (@ParentID=0)
		begin
			INSERT INTO ManagerLog (Name,UserID,ParentID,AllowFlagging,MultiEntryField,[Description],Sequence)
			VALUES(@Name,@UserID,@ParentID,@AllowFlagging,@EntryField,@Description,null)
			return @@IDENTITY
		end
		else
		begin
			select @maxSequence=MAX(Sequence) from ManagerLog  where ParentID=@ParentID
			if @maxSequence is null
			begin
				set @maxSequence=1
			end
			else
			begin
				set @maxSequence=@maxSequence+1
			end
			INSERT INTO ManagerLog (Name,UserID,ParentID,AllowFlagging,MultiEntryField,[Description],Sequence)
			VALUES(@Name,@UserID,@ParentID,@AllowFlagging,@EntryField,@Description,@maxSequence)
			return @@IDENTITY
		end
	end
	else if @SQLOperationType='SQLUpdate'
	begin
		update ManagerLog set Name=@Name,AllowFlagging=@AllowFlagging,
						MultiEntryField=@EntryField,[Description]=@Description
						 where ID=@ID
	end
	else if @SQLOperationType='SQLDelete'
	begin try
	begin tran
		select @HeaderId=ID from ManagerLogDetailHeader where ManagerLogID=@ID
		print @HeaderId
		delete from ManagerLogDetail where headerID in (select HeaderID   from ManagerLogDetailHeader  where ManagerLogID =@ID)
		print 1
		delete from ManagerLogDetailHeader where ManagerLogID =@ID
		print 2
		delete from ManagerLog where ID=@ID or ParentID=@ID
		print 3
	commit tran
	end try
	begin catch
		rollback tran
	end catch
	else if (@SQLOperationType='SQLSequenceUp')--给Log标题排序，上移
	begin
		
	select @innerSequence= min(Sequence) from ManagerLog where ParentID=@ParentID
		if @Sequence>@innerSequence
		begin try
			begin tran
				select top 1 @innerSequence=Sequence,@innerID=ID from ManagerLog where Sequence < @Sequence and ParentID=@ParentID order by Sequence DESC 
				UPDATE ManagerLog SET Sequence=@Sequence where ID=@innerID
				UPDATE ManagerLog SET Sequence = @innerSequence where ID=@ID
			commit tran
		end try
		begin catch
			rollback tran
		end catch
	end
	else if (@SQLOperationType='SQLSequenceDown') --给Log标题排序，下移
	begin
	select @innerSequence= MAX(Sequence) from ManagerLog where ParentID=@ParentID
		if @Sequence<@innerSequence
		begin try
			begin tran
				select top 1 @innerSequence=Sequence,@innerID=ID from ManagerLog where Sequence > @Sequence and ParentID=@ParentID order by Sequence asc 
				UPDATE ManagerLog SET Sequence = @Sequence where ID=@innerID
				UPDATE ManagerLog SET Sequence = @innerSequence where ID=@ID
			commit tran
		end try
		begin catch
			rollback tran
		end catch
		end
END

GO
