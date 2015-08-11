SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Inv_ItemToLocation_InUpDel] 
	-- Add the parameters for the stored procedure here
	@StoreID int,
	@InvItemID int,
	@LocationID int,
	@Creator int,
	@Editor int,
	@sqlType nvarchar(200)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    if ISNULL(@sqlType,'')='SQLINSERT'
    begin
		
		INSERT INTO [Inv_ItemToLocation]
			   ([StoreID]
			   ,[InvItemID]
			   ,[LocationID]
			   ,[DisplaySeq]
			   ,[Creator]
			   ,[Editor]
			   ,[lastUpdate])
		 VALUES (@StoreID,@InvItemID,@LocationID,(select isnull(MAX(DisplaySeq),0) from [Inv_ItemToLocation])+1,@Creator,@Editor,GETDATE())
     end
     if ISNULL(@sqlType,'')='SQLUPDATE'
     begin
		declare @count int
		select @count = count(*) from [Inv_ItemToLocation] where [StoreID]=@StoreID and [InvItemID]=@InvItemID
		if @count>0
		update [Inv_ItemToLocation] set [LocationID]=@LocationID,Editor=@Editor where [StoreID]=@StoreID and [InvItemID]=@InvItemID
		else
		begin
			INSERT INTO [Inv_ItemToLocation]
			   ([StoreID]
			   ,[InvItemID]
			   ,[LocationID]
			   ,[DisplaySeq]
			   ,[Creator]
			   ,[Editor]
			   ,[lastUpdate])
		 VALUES (@StoreID,@InvItemID,@LocationID,(select isnull(MAX(DisplaySeq),0) from [Inv_ItemToLocation])+1,@Editor,@Creator,GETDATE())
		end
     end
END
GO
