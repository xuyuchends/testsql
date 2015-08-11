SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[Inv_ItemCount_InUpDel]
	@StoreID int ,
	@WeekEnding datetime,
	@CountType int,
	@Creator int ,
	@Editor int,
	@sqlType nvarchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	set @WeekEnding=dateadd(day,1-(datepart(weekday,@WeekEnding))+6,@WeekEnding)
    -- Insert statements for procedure here
    if (@sqlType='SQLINSERT')
    begin
    begin tran
		delete from Inv_ItemCountDetail where CountID=(select CountID from Inv_ItemCount where StoreID=@StoreID and WeekEnding=@WeekEnding)
		delete from Inv_ItemCount where StoreID=@StoreID and WeekEnding=@WeekEnding
		INSERT INTO Inv_ItemCount(StoreID,WeekEnding,CountType,LastUpdate,Creator,Editor)
		VALUES(@StoreID,@WeekEnding,@CountType,GETDATE(),@Creator,@Editor)
	select @@IDENTITY
    commit tran
    end
    else
    begin
		update Inv_ItemCount set CountType=@CountType,LastUpdate=GETDATE(),Creator=@Creator,Editor=@Editor
		where StoreID=@StoreID and WeekEnding=@WeekEnding
		select countid from Inv_ItemCount where  StoreID=@StoreID and WeekEnding=@WeekEnding
    end
END
GO
