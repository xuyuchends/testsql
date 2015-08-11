SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create PROCEDURE [dbo].[MovePaidInTrxToArchive]
AS
BEGIN
SET NOCOUNT ON;
declare	@StoreID int 
declare	@ID int 
declare @PaidInId int
declare	@Amount money 
declare	@ManagerID int 
declare	@EmployeeID int 
declare	@Note nvarchar(max) 
declare	@Status nvarchar(50) 
declare	@BusinessDate datetime 
declare	@LastUpdate datetime 

declare cur cursor
	for SELECT StoreID,ID,Amount,ManagerID,EmployeeID,Note,Status,BusinessDate,LastUpdate,PaidInID FROM PaidInTrx
			   where CONVERT(varchar(10), BusinessDate, 120 )<DATEADD(YEAR,-2,CONVERT(varchar(10), GETDATE(), 120 ))
	open cur
	fetch next from cur into @StoreID,@ID,@Amount,@ManagerID,@EmployeeID,@Note,@Status,@BusinessDate,@LastUpdate,@PaidInId
	while(@@fetch_status=0)
	begin
		begin try
			UPDATE PaidInTrxArchive SET Amount = @Amount,ManagerID=@ManagerID,EmployeeID=@EmployeeID,Note=@Note,Status=@Status,BusinessDate=@BusinessDate,LastUpdate=@LastUpdate,PaidInID=@PaidInId
			where StoreID=@StoreID and ID=@ID
			if @@ROWCOUNT=0
			INSERT INTO PaidInTrxArchive (StoreID,ID,PaidInID,Amount,ManagerID,EmployeeID,Note,Status,BusinessDate,LastUpdate)
			VALUES
           (@StoreID,@ID,@PaidInId,@Amount,@ManagerID,@EmployeeID,@Note,@Status,@BusinessDate,@LastUpdate)
		END TRY
		BEGIN CATCH
		end  CATCH
		fetch next from cur into   @StoreID,@ID,@Amount,@ManagerID,@EmployeeID,@Note,@Status,@BusinessDate,@LastUpdate,@PaidInId
	end
close cur
deallocate cur
END


GO
