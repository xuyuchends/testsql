SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[TranInsUpd_Position]
@StoreID int,
@ID int, 
@Name nvarchar(50)

AS
BEGIN
 UPDATE Position SET Name = @Name,[status]='Normal',LastUpdate = getDate() WHERE StoreID = @StoreID and ID = @ID
 if(@@rowcount=0)
 INSERT INTO Position (StoreID,ID,Name,[status],LastUpdate) VALUES( @StoreID, @ID, @Name,'Normal', getDate())
END
GO
