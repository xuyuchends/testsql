SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Inv_ItemCategory_InUpDel]
(
	@ID int, 
	@Name nvarchar(200), 
	@ParentID int, 
	@GroupID int, 
	@GLAccount nvarchar(200), 
	@DisplaySeq int, 
	@IsActive bit, 
	@LastUpdate datetime, 
	@Creator int, 
	@Editor int,
	@SQLOperationType nvarchar(50)
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	declare @currentDisplaySeq int
	declare @transferID int
	declare @transferDisplaySeq int
	declare @layer int
	if(@SQLOperationType='SQLINSERT')
	begin
		declare @MaxDisplaySeq int
		select @MaxDisplaySeq=isnull(MAX(DisplaySeq),0) from Inv_ItemCategory
		set @MaxDisplaySeq+=1
		if (@ParentID=0)
			set @layer=1
		else
		begin
			select @layer=Layer from Inv_ItemCategory where ID=@ParentID
			set @layer+=1
		end
		INSERT INTO [Inv_ItemCategory]([Name],[ParentID],[GroupID],[GLAccount],[DisplaySeq],[IsActive],[LastUpdate],
		[Creator],[Editor],Layer)VALUES (@Name,@ParentID,@GroupID,@GLAccount,@MaxDisplaySeq,@IsActive,GETDATE(),@Creator,@Editor,@layer)
		select @@IDENTITY
	end							
	else if @SQLOperationType='SQLUPDATE'
	begin
		  if (@ParentID=0)
			set @layer=1
		else
		begin
			select @layer=Layer from Inv_ItemCategory where ID=@ParentID
			set @layer+=1
		end
		  update Inv_ItemCategory SET [Name] = @Name,[ParentID] = @ParentID,[GroupID] = @GroupID,
		  [GLAccount] = @GLAccount,[IsActive] = @IsActive,[LastUpdate] = GETDATE(),
		  [Editor] = @Editor,Layer=@layer
		  WHERE ID=@ID
	end
	else if @SQLOperationType='SQLDELETE'
	begin
		update Inv_ItemCategory set [IsActive]=0,LastUpdate=GETDATE(),Editor=@Editor WHERE ID=@ID
	end
	else if @SQLOperationType='SQLUP'
	begin
		begin tran
			select @currentDisplaySeq=DisplaySeq from Inv_ItemCategory where ID=@ID
			select top 1 @transferID=ID,@transferDisplaySeq= DisplaySeq from Inv_ItemCategory 
			where ID=
			(
				select MAX(ID) as ID from Inv_ItemCategory as t1
				where   exists (select * from  Inv_ItemCategory as t2 where t1.ParentID=t2.ParentID and t1.DisplaySeq<t2.DisplaySeq and t2.ID=@ID)
			)
			if (@transferID is not null)
			begin
				update Inv_ItemCategory set DisplaySeq=@currentDisplaySeq,Editor=@Editor,LastUpdate=GETDATE() where ID=@transferID
				update Inv_ItemCategory set DisplaySeq=@transferDisplaySeq,Editor=@Editor,LastUpdate=GETDATE() where ID=@ID
			end
		commit tran
	end
	else if @SQLOperationType='SQLDOWN'
	begin
		begin tran
			select @currentDisplaySeq=DisplaySeq from Inv_ItemCategory where ID=@ID
			select top 1 @transferID=ID,@transferDisplaySeq= DisplaySeq from Inv_ItemCategory 
			where ID=
			(
				select min(ID) as ID from Inv_ItemCategory as t1
				where   exists (select * from  Inv_ItemCategory as t2 where t1.ParentID=t2.ParentID and t1.DisplaySeq>t2.DisplaySeq and t2.ID=@ID)
			)
			if (@transferID is not null)
			begin
				update Inv_ItemCategory set DisplaySeq=@currentDisplaySeq,Editor=@Editor,LastUpdate=GETDATE() where ID=@transferID
				update Inv_ItemCategory set DisplaySeq=@transferDisplaySeq,Editor=@Editor,LastUpdate=GETDATE() where ID=@ID
			end
		commit tran
	end
	else if @SQLOperationType='SQLTOP'
	begin
		begin tran
			select @currentDisplaySeq=DisplaySeq from Inv_ItemCategory where ID=@ID
			select top 1 @transferID=ID,@transferDisplaySeq= DisplaySeq from Inv_ItemCategory 
			where ParentID =(select ParentID from Inv_ItemCategory where ID=@ID)
			order by DisplaySeq asc
			if (@transferID<>@ID)
			begin
				update Inv_ItemCategory set DisplaySeq=@currentDisplaySeq,Editor=@Editor,LastUpdate=GETDATE() where ID=@transferID
				update Inv_ItemCategory set DisplaySeq=@transferDisplaySeq,Editor=@Editor,LastUpdate=GETDATE() where ID=@ID
			end
		commit tran
	end
	else if @SQLOperationType='SQLBOTTOM'
	begin
		begin tran
			select @currentDisplaySeq=DisplaySeq from Inv_ItemCategory where ID=@ID
			select top 1 @transferID=ID,@transferDisplaySeq= DisplaySeq from Inv_ItemCategory 
			where ParentID =(select ParentID from Inv_ItemCategory where ID=@ID)
			order by DisplaySeq desc
			if (@transferID<>@ID)
			begin
				update Inv_ItemCategory set DisplaySeq=@currentDisplaySeq,Editor=@Editor,LastUpdate=GETDATE() where ID=@transferID
				update Inv_ItemCategory set DisplaySeq=@transferDisplaySeq,Editor=@Editor,LastUpdate=GETDATE() where ID=@ID
			end
		commit tran
	end
END
GO
