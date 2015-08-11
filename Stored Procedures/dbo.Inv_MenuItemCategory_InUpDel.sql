SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Inv_MenuItemCategory_InUpDel]
(
	@ID int,
	@Name nvarchar(200),
	@ParentID int,
	@GroupID int,
	@DisplaySeq int,
	@ShowInReport bit,
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
		select @MaxDisplaySeq=isnull(MAX(DisplaySeq),0) from Inv_MenuItemCategory
		if (@MaxDisplaySeq=null)
			set @MaxDisplaySeq=0
		set @MaxDisplaySeq+=1
		if (@ParentID=0)
			set @layer=1
		else
		begin
			select @layer=Layer from Inv_MenuItemCategory where ID=@ParentID
			set @layer+=1
		end
		INSERT INTO Inv_MenuItemCategory(Name,ParentID,GroupID,DisplaySeq,IsActive,ShowInReport,LastUpdate,Creator,Editor,Layer)
     VALUES(@Name,@ParentID,@GroupID,@MaxDisplaySeq,@IsActive,@ShowInReport,GETDATE(),@Creator,@Editor,@Layer)
		select @@IDENTITY
	end							
	else if @SQLOperationType='SQLUPDATE'
	begin
		  if (@ParentID=0)
			set @layer=1
		else
		begin
			select @layer=Layer from Inv_MenuItemCategory where ID=@ParentID
			set @layer+=1
		end
		  UPDATE Inv_MenuItemCategory SET Name = @Name,ParentID = @ParentID,GroupID = @GroupID
		  ,IsActive = @IsActive,ShowInReport = @ShowInReport,
		  LastUpdate = GETDATE(),Creator = @Creator,Editor = @Editor,Layer = @Layer
		  WHERE ID=@ID
	end
	else if @SQLOperationType='SQLDELETE'
	begin
		update [Inv_MenuItemCategory] set IsActive = 0 where ID=@ID
	end
	else if @SQLOperationType='SQLUP'
	begin
		begin tran
			select @currentDisplaySeq=DisplaySeq from Inv_MenuItemCategory where ID=@ID
			select top 1 @transferID=ID,@transferDisplaySeq= DisplaySeq from Inv_MenuItemCategory 
			where ID=
			(
				select isnull(MAX(ID),0) as ID from Inv_MenuItemCategory as t1
				where   exists (select * from  Inv_MenuItemCategory as t2 where t1.ParentID=t2.ParentID and t1.DisplaySeq<t2.DisplaySeq and t2.ID=@ID)
			)
			if (@transferID is not null)
			begin
				update Inv_MenuItemCategory set DisplaySeq=@currentDisplaySeq,Editor=@Editor,LastUpdate=GETDATE() where ID=@transferID
				update Inv_MenuItemCategory set DisplaySeq=@transferDisplaySeq,Editor=@Editor,LastUpdate=GETDATE() where ID=@ID
			end
		commit tran
	end
	else if @SQLOperationType='SQLDOWN'
	begin
		begin tran
			select @currentDisplaySeq=DisplaySeq from Inv_MenuItemCategory where ID=@ID
			select top 1 @transferID=ID,@transferDisplaySeq= DisplaySeq from Inv_MenuItemCategory 
			where ID=
			(
				select isnull(min(ID),0) as ID from Inv_MenuItemCategory as t1
				where   exists (select * from  Inv_MenuItemCategory as t2 where t1.ParentID=t2.ParentID and t1.DisplaySeq>t2.DisplaySeq and t2.ID=@ID)
			)
			if (@transferID is not null)
			begin
				update Inv_MenuItemCategory set DisplaySeq=@currentDisplaySeq,Editor=@Editor,LastUpdate=GETDATE() where ID=@transferID
				update Inv_MenuItemCategory set DisplaySeq=@transferDisplaySeq,Editor=@Editor,LastUpdate=GETDATE() where ID=@ID
			end
		commit tran
	end
	else if @SQLOperationType='SQLTOP'
	begin
		begin tran
			select @currentDisplaySeq=DisplaySeq from Inv_MenuItemCategory where ID=@ID
			select top 1 @transferID=ID,@transferDisplaySeq= DisplaySeq from Inv_MenuItemCategory 
			where ParentID =(select ParentID from Inv_MenuItemCategory where ID=@ID)
			order by DisplaySeq asc
			if (@transferID<>@ID)
			begin
				update Inv_MenuItemCategory set DisplaySeq=@currentDisplaySeq,Editor=@Editor,LastUpdate=GETDATE() where ID=@transferID
				update Inv_MenuItemCategory set DisplaySeq=@transferDisplaySeq,Editor=@Editor,LastUpdate=GETDATE() where ID=@ID
			end
		commit tran
	end
	else if @SQLOperationType='SQLBOTTOM'
	begin
		begin tran
			select @currentDisplaySeq=DisplaySeq from Inv_MenuItemCategory where ID=@ID
			select top 1 @transferID=ID,@transferDisplaySeq= DisplaySeq from Inv_MenuItemCategory 
			where ParentID =(select ParentID from Inv_MenuItemCategory where ID=@ID)
			order by DisplaySeq desc
			if (@transferID<>@ID)
			begin
				update Inv_MenuItemCategory set DisplaySeq=@currentDisplaySeq,Editor=@Editor,LastUpdate=GETDATE() where ID=@transferID
				update Inv_MenuItemCategory set DisplaySeq=@transferDisplaySeq,Editor=@Editor,LastUpdate=GETDATE() where ID=@ID
			end
		commit tran
	end
	else if @SQLOperationType='FromPOS'
	begin
		declare @CategoryName nvarchar(50)
		declare cur cursor
		read_only
		for select * from dbo.f_split(@name,'/')
		open cur
		fetch next from cur into @CategoryName
		while(@@fetch_status=0)
		begin
			declare @count int
		 select @count =COUNT(*) from Inv_MenuItemCategory where Name=@CategoryName and ParentID=@ParentID
			--select @ParentID
			if @count=0
			begin
			
				declare @MaxDisplay int
				select @MaxDisplay=isnull(MAX(DisplaySeq),0) from Inv_MenuItemCategory
				set @MaxDisplay+=1
				if (@ParentID=0)
					set @layer=1
				else
				begin
					select @layer=Layer from Inv_MenuItemCategory where ID=@ParentID
					set @layer+=1
				end
				INSERT INTO Inv_MenuItemCategory(Name,ParentID,GroupID,DisplaySeq,IsActive,ShowInReport,LastUpdate,Creator,Editor,Layer)
			 VALUES(@CategoryName,@ParentID,@GroupID,@MaxDisplay,@IsActive,@ShowInReport,GETDATE(),@Creator,@Editor,@Layer)
				set @ParentID= @@IDENTITY
				
			end
			else
			begin
				select @ParentID =ID from Inv_MenuItemCategory where Name=@CategoryName
				and ParentID=@ParentID
				
			end
			
			fetch next from cur into @CategoryName
		end
		close cur
		deallocate cur
		
		select @ParentID 
	end
END
GO
