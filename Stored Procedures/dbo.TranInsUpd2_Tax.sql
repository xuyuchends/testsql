SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


create PROCEDURE [dbo].[TranInsUpd2_Tax]
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
	INSERT INTO Tax(StoreID,TaxCategoryID,CheckID,OrderID,Category,taxAmt,TaxOrderAmt,BusinessDate,LastUpdate,Status)
	VALUES(@StoreID,@TaxCategoryID,@CheckID,@OrderID,@Category,@taxAmt,@taxOrderAmt,@BusinessDate,GETDATE(),@Status)

GO
