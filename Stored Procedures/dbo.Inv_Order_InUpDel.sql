SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Inv_Order_InUpDel]
	@ID int ,
	@StoreID int ,
	@VendorID int ,
	@PONum nvarchar(200) ,
	@OrderStatus int ,
	@PostDate datetime ,
	@EstDeliveryDate datetime ,
	@SubTotal decimal(18, 2) ,
	@Note nvarchar(max) ,
	@CreatedID int ,
	@CreatedName nvarchar(200) ,
	@EditorID int ,
	@EditorName nvarchar(200) ,
	@sqlType nvarchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    if ISNULL(@sqlType,'')='SQLINSERT'
    begin
	INSERT INTO dbo.Inv_Order(StoreID,VendorID,PONum,OrderStatus,PostDate,CreationDate,EstDeliveryDate,
		SubTotal,Note,LastUpdate,CreatedID,CreatedName,EditorID,EditorName)
    VALUES
       (@StoreID,@VendorID,@PONum,@OrderStatus,@PostDate,CONVERT(varchar(10), getdate(), 120 ),@EstDeliveryDate,
       @SubTotal,@Note,getdate(),@CreatedID,@CreatedName,@EditorID,@EditorName)
    select @@IDENTITY
	end
	else if ISNULL(@sqlType,'')='SQLUPDATE'
	UPDATE Inv_Order SET StoreID = @StoreID
      ,VendorID = @VendorID
      ,PONum = @PONum
      ,OrderStatus = @OrderStatus
      ,PostDate = @PostDate
      ,EstDeliveryDate = @EstDeliveryDate
      ,SubTotal = @SubTotal
      ,Note = @Note
      ,LastUpdate = getdate()
      ,EditorID = @EditorID
      ,EditorName = @EditorName
      where  ID=@ID
END
GO
