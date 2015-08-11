SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Inv_ItemCount_Sel]
	@StoreID int ,
	@WeekEnding datetime,
	@CountType int ,
	@Creator int,
	@Editor int,
	@sqlType nvarchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	set @WeekEnding= dbo.fn_GetWeekEnding(@WeekEnding)
    -- Insert statements for procedure here
    if (@sqlType='SQLSELECT')
    begin
		SELECT top 1 StoreID,countid, WeekEnding,CountType,LastUpdate,Creator,Editor FROM Inv_ItemCount
		where WeekEnding between DATEADD(day,-6,@WeekEnding) and @WeekEnding and StoreID=@StoreID
		order by LastUpdate desc
	end
END
GO
