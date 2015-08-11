SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[TranInsUpd_PaidOutTrx]
@StoreID int ,
@ID int ,
@PaidOutID int,
@Amount money ,
@ManagerID int ,
@EmployeeID int ,
@Note nvarchar(max) ,
@Status nvarchar(50),
@BusinessDate datetime
AS
    
	UPDATE PaidOutTrx SET ID=@ID,Amount=@Amount,ManagerID=@ManagerID,EmployeeID=@EmployeeID,
		Note=@Note,[Status]=@Status,LastUpdate=GETDATE()
		where StoreID=@StoreID and PaidOutID=@PaidOutID   and BusinessDate= @BusinessDate
	if @@ROWCOUNT =0
		INSERT INTO PaidOutTrx(StoreID,ID,PaidOutID,Amount,ManagerID,EmployeeID,
	Note,[Status], BusinessDate, LastUpdate)
VALUES(@StoreID,@ID,@PaidOutID,@Amount,@ManagerID,@EmployeeID,
	@Note,@Status,@BusinessDate,GETDATE())  

GO
