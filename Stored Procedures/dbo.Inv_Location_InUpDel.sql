SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Inv_Location_InUpDel]
(
	@ID int,
	@Name nvarchar(200),
	@ParentID int,
	@StoreID nvarchar(200),
	@Creator int,
	@Editor int,
	@sqlType nvarchar(200),
	@Operate nvarchar(20)
)
as
declare @DisplaySeqMin int
declare @currDisplaySeq int
declare @DisplaySeqMax int
declare @ExchangeID int
declare @ParentIDCurr int
declare @layer int
if ISNULL(@sqlType,'')='SQLINSERT'
begin
	select @DisplaySeqMax=isnull(max([DisplaySeq]),0) from [Inv_Location]
	if (@ParentID=0)
		set @layer=1
	else
		begin
			select @layer=Layer from Inv_Location where ID=@ParentID
			set @layer+=1
		end
	INSERT INTO [Inv_Location]
           ([Name]
           ,[ParentID]
           ,[StoreID]
           ,[DisplaySeq]
           ,[LastUpdate]
           ,[Creator]
           ,[Editor]
           ,Layer)
     VALUES (@Name,@ParentID,@StoreID,@DisplaySeqMax+1,GETDATE(),@Creator,@Editor,@layer)
     select @@IDENTITY
end
else if ISNULL(@sqlType,'')='SQLUPDATE'
begin
	if ISNULL(@Operate,'')='Top'
	begin
		select @currDisplaySeq=DisplaySeq,@ParentIDCurr=[ParentID] from Inv_Location  where ID=@ID
		select @DisplaySeqMin=min(DisplaySeq) from Inv_Location where [ParentID]=@ParentIDCurr
		if @DisplaySeqMin is not null
		begin
		update Inv_Location set DisplaySeq=@DisplaySeqMin where ID=@ID 
		update Inv_Location set DisplaySeq=DisplaySeq+1 where DisplaySeq<@currDisplaySeq and id<>@ID and [ParentID]=@ParentIDCurr
		end	
	end
	else if ISNULL(@Operate,'')='Bottom'
	begin
		select @currDisplaySeq=DisplaySeq,@ParentIDCurr=[ParentID] from Inv_Location  where ID=@ID 
		select @DisplaySeqMax=max(DisplaySeq) from Inv_Location where [ParentID]=@ParentIDCurr
		if @ParentIDCurr is not null
		begin
		update Inv_Location set DisplaySeq=@DisplaySeqMax where ID=@ID 
		update Inv_Location set DisplaySeq=DisplaySeq-1 where DisplaySeq>@currDisplaySeq and ID<>@ID and [ParentID]=@ParentIDCurr
		end	
	end
	else if ISNULL(@Operate,'')='up'
	begin
		select @currDisplaySeq=DisplaySeq,@ParentIDCurr=[ParentID] from Inv_Location  where ID=@ID
		select @DisplaySeqMax=max(DisplaySeq),@ExchangeID=MAX(ID) from Inv_Location where DisplaySeq<@currDisplaySeq and [ParentID]=@ParentIDCurr
		if 	@DisplaySeqMax is not null
		begin
		update Inv_Location set DisplaySeq=@DisplaySeqMax where ID=@ID
		update Inv_Location set DisplaySeq=@currDisplaySeq where id=@ExchangeID
		end
	end
	else if ISNULL(@Operate,'')='Down'
	begin
		select @currDisplaySeq=DisplaySeq,@ParentIDCurr=[ParentID] from Inv_Location  where ID=@ID
		select @DisplaySeqMin=min(DisplaySeq),@ExchangeID=min(ID) from Inv_Location where DisplaySeq>@currDisplaySeq and [ParentID]=@ParentIDCurr
		if 	@DisplaySeqMin is not null
		begin
		update Inv_Location set DisplaySeq=@DisplaySeqMin where ID=@ID
		update Inv_Location set DisplaySeq=@currDisplaySeq where id=@ExchangeID
		end
	end
	else
	begin
		  if (@ParentID=0)
			set @layer=1
		else
		begin
			select @layer=Layer from Inv_ItemCategory where ID=@ParentID
			set @layer+=1
		end
		update Inv_Location set Name=@Name,ParentID=@ParentID,[Editor]=@Editor,LastUpdate=GETDATE() where id=@ID
	end
end

GO
