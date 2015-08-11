SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[TranInsUpd_Void]
@StoreID int,
@ID int, 
@Name nvarchar(50)

AS
BEGIN
 --UPDATE Void SET Name = @Name,LastUpdate = getDate() WHERE StoreID = @StoreID and ID = @ID
 --if(@@rowcount=0)
 INSERT INTO Void (StoreID,ID,Name,LastUpdate) VALUES( @StoreID, @ID, @Name, getDate())
END
GO
