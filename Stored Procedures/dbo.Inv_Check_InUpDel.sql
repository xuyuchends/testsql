SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Inv_Check_InUpDel]
	@ID int  ,
	@InvoiceNum nvarchar(50) ,
	@Type int ,
	@CheckNum nvarchar(50) ,
	@VendorID int ,
	@Amount decimal(18, 2) ,
	@Comment nvarchar(max) ,
	@CreationDate datetime ,
	@LastUpdate datetime ,
	@Creator int ,
	@Editor int ,
	@SQLOperationType nvarchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    if @SQLOperationType='SQLINSERT'
    begin
		INSERT INTO Inv_Check(InvoiceNum,Type,CheckNum,VendorID,Amount,Comment,CreationDate,LastUpdate,Creator,Editor)
		VALUES(@InvoiceNum,@Type,@CheckNum,@VendorID,@Amount,@Comment,@CreationDate,getdate(),@Creator,@Editor)
		select @@IDENTITY
	end
	else if @SQLOperationType='SQLUPDATE'
	UPDATE Inv_Check set InvoiceNum = @InvoiceNum,Type = @Type,CheckNum = @CheckNum,VendorID = @VendorID
      ,Amount = @Amount,Comment = @Comment,CreationDate=@CreationDate,LastUpdate = GETDATE(),Editor = @Editor
END
GO
