SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create PROCEDURE [dbo].[MovePaidOutTrxToArchive]
AS
BEGIN
SET NOCOUNT ON;
declare	@StoreID int 
declare	@ID int 
declare @PaidOutID int
declare	@Amount money 
declare	@ManagerID int 
declare	@EmployeeID int 
declare	@Note nvarchar(max) 
declare	@Status nvarchar(50) 
declare	@BusinessDate datetime 
declare	@LastUpdate datetime 

declare cur cursor
	for SELECT StoreID,ID,Amount,ManagerID,EmployeeID,Note,Status,BusinessDate,LastUpdate,paidoutID FROM PaidOutTrx
			   where CONVERT(varchar(10), BusinessDate, 120 )<DATEADD(YEAR,-2,CONVERT(varchar(10), GETDATE(), 120 ))
	open cur
	fetch next from cur into @StoreID,@ID,@Amount,@ManagerID,@EmployeeID,@Note,@Status,@BusinessDate,@LastUpdate,@PaidOutID
	while(@@fetch_status=0)
	begin
		begin try
			UPDATE PaidOutTrxArchive SET Amount = @Amount,ManagerID=@ManagerID,EmployeeID=@EmployeeID,Note=@Note,Status=@Status,BusinessDate=@BusinessDate,LastUpdate=@LastUpdate,PaidOutID=@PaidOutID
			where StoreID=@StoreID and ID=@ID
			if @@ROWCOUNT=0
			INSERT INTO PaidOutTrxArchive (StoreID,ID,PaidOutID,Amount,ManagerID,EmployeeID,Note,Status,BusinessDate,LastUpdate)
			VALUES
           (@StoreID,@ID,@PaidOutID,@Amount,@ManagerID,@EmployeeID,@Note,@Status,@BusinessDate,@LastUpdate)
		END TRY
		BEGIN CATCH
		end  CATCH
		fetch next from cur into   @StoreID,@ID,@Amount,@ManagerID,@EmployeeID,@Note,@Status,@BusinessDate,@LastUpdate,@PaidOutID
	end
close cur
deallocate cur
END
GO
