SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[TranInsUpd_PaymentMethod]
@StoreID int,
@ID int, 
@Name nvarchar(50), 
@DisplayName nvarchar(50),
@PaymentType nvarchar(50)

AS
BEGIN
 --UPDATE PaymentMethod SET Name = @Name,DisplayName=@DisplayName, PaymentType = @PaymentType,LastUpdate = getDate() WHERE StoreID = @StoreID and ID = @ID
 --if(@@rowcount=0)
 INSERT INTO PaymentMethod (StoreID,ID,Name,DisplayName,PaymentType,LastUpdate)VALUES( @StoreID, @ID, @Name, @DisplayName,@PaymentType, getDate())
END
GO
