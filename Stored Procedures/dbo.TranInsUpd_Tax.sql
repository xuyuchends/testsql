SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[TranInsUpd_Tax]
@StoreID int ,
@TaxCategoryID int ,
@CheckID bigint ,
@OrderID bigint ,
@Category nvarchar(50) ,
@taxAmt decimal(19, 10) ,
@taxOrderAmt decimal(19, 10),
@BusinessDate datetime ,
@Status nvarchar(20)
AS
begin try
	INSERT INTO Tax(StoreID,TaxCategoryID,CheckID,OrderID,Category,
		taxAmt,TaxOrderAmt,BusinessDate,LastUpdate,Status)
	VALUES(@StoreID,@TaxCategoryID,@CheckID,@OrderID,@Category,
		@taxAmt,@taxOrderAmt,@BusinessDate,GETDATE(),@Status)
END TRY
BEGIN CATCH
	if @@ERROR <>0
		UPDATE  Tax SET taxAmt=@taxAmt ,TaxOrderAmt=@taxOrderAmt,BusinessDate=@BusinessDate ,LastUpdate=GETDATE(),Status=@Status
		where  StoreID=@StoreID and TaxCategoryID=@TaxCategoryID and CheckID=@CheckID and OrderID=@OrderID and Category=@Category
		and BusinessDate=@BusinessDate
end  CATCH
GO
