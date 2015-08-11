SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Inv_MenuItemMap_sel]
(
	@StoreID int,
	@InvMID int,
	@stMID int,
	@SQLOperationType nvarchar(50)
)
as
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	if (@SQLOperationType='SQLSELECT')
		SELECT mp.[StoreID],[InvMID],[stMID],mi.Department+'/'+mi.Category as category FROM [Inv_MenuItemMap] mp
inner join MenuItem mi on mi.ID=mp.stMID and mi.StoreID=mp.StoreID
		where mp.InvMID=@InvMID
END
GO
