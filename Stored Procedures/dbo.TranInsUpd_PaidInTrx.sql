SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[TranInsUpd_PaidInTrx]
@StoreID int ,
@ID int ,
@PaidInID int,
@Amount money ,
@ManagerID int ,
@EmployeeID int ,
@Note nvarchar(max) ,
@Status nvarchar(50),
@BusinessDate datetime
AS
    
	UPDATE PaidInTrx SET ID=@ID,Amount=@Amount,ManagerID=@ManagerID,EmployeeID=@EmployeeID,
		Note=@Note,[Status]=@Status,BusinessDate=@BusinessDate,LastUpdate=GETDATE()
		where StoreID=@StoreID and PaidInID=@PaidInID   and  BusinessDate=@BusinessDate 

	if @@ROWCOUNT =0
		INSERT INTO PaidInTrx(StoreID,ID,PaidInID,Amount,ManagerID,EmployeeID,
	Note,[Status], BusinessDate, LastUpdate)
VALUES(@StoreID,@ID,@PaidInID,@Amount,@ManagerID,@EmployeeID,
	@Note,@Status,@BusinessDate,GETDATE())  


GO
