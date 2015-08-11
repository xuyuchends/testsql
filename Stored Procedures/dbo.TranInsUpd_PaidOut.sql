SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create PROCEDURE [dbo].[TranInsUpd_PaidOut]
@StoreID int,
@ID int, 
@Name nvarchar(50)

AS
BEGIN
 UPDATE PaidOut SET Name = @Name,LastUpdate = getDate() WHERE StoreID = @StoreID and ID = @ID
 if(@@rowcount=0)
 INSERT INTO PaidOut(StoreID,ID,Name,LastUpdate) VALUES( @StoreID, @ID, @Name, getDate())
END
GO
