SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create PROCEDURE [dbo].[TranInsUpd_Department]
@StoreID int,
@ID int ,
@Name nvarchar(50)

AS
BEGIN
 UPDATE Department SET Name = @Name,LastUpdate = getDate() WHERE StoreID = @StoreID and ID = @ID
 if(@@rowcount=0)
 INSERT INTO Department (StoreID,ID,Name,LastUpdate) VALUES( @StoreID, @ID, @Name, getDate())
END
GO
