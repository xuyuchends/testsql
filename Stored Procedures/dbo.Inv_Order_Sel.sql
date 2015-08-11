SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Inv_Order_Sel]
(
	@ID int,
	@StoreID int ,
	@VendorID int ,
	@PONum nvarchar(200) ,
	@OrderStatus int ,
	@PostDate datetime ,
	@CreationDate datetime ,
	@EstDeliveryDate datetime ,
	@CreatedID int ,
	@CreatedName nvarchar(200) ,
	@SubTotal decimal(18, 2) ,
	@Note nvarchar(max) ,
	@LastUpdate datetime ,
	@Creator int ,
	@Editor int ,
	@SQLOperationType nvarchar(50)
)
as
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	if (@SQLOperationType='SQLSELECT')
		begin
			set @CreationDate= dbo.fn_GetWeekEnding(@CreationDate)
			SELECT o.ID,VendorID,v.Name as VendorName, PONum,OrderStatus,o.LastUpdate,EstDeliveryDate ,o.CreationDate ,o.PostDate from Inv_Order as o
			inner join  Inv_Vendor as v on v.ID=o.VendorID
			where o. StoreID=@StoreID and CreationDate between DATEADD(day,-6,@CreationDate) and @CreationDate
		end
	else if (@SQLOperationType='SQLSELECTDETAIL')
		SELECT o.ID,o.StoreID,o.VendorID,v.Name as VendorName, o.PONum,o.OrderStatus,o.PostDate,o.CreationDate,o.EstDeliveryDate,o.CreatedID
		,o.CreatedName,o.SubTotal,o.Note,o.LastUpdate,o.EditorID,o.EditorName from Inv_Order as o 
		inner join Inv_Vendor as v on v.ID=o.VendorID
		where o.ID=@ID
	else if (@SQLOperationType='SQLGetPostedOrder')
		begin
			SELECT top 10 o.ID,VendorID,v.Name as VendorName, PONum,OrderStatus,o.LastUpdate,EstDeliveryDate ,o.CreationDate ,o.PostDate from Inv_Order as o
			inner join  Inv_Vendor as v on v.ID=o.VendorID
			where o. StoreID=@StoreID and OrderStatus=@OrderStatus
		end
END
GO
