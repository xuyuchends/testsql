SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[TranInsUpd_EmployeeOtherWage]
@StoreID int,
@ID int, 
@EmployeeID int, 
@OtherWage money, 
@BusinessDate datetime

AS
BEGIN
 begin try
 INSERT INTO [EmployeeOtherWage]
           ([StoreID]
           ,[ID]
           ,[EmployeeID]
           ,[OtherWage]
           ,[BusinessDate])
     VALUES
           (@StoreID
           ,@ID
           ,@EmployeeID
           ,@OtherWage
           ,@BusinessDate)
end try
begin catch
	if @@ERROR<>0
	begin
		UPDATE [EmployeeOtherWage]
	   SET [EmployeeID] = @EmployeeID
		  ,[OtherWage] = @OtherWage
		  ,[BusinessDate] = @BusinessDate
	 WHERE StoreID=@StoreID and ID=@ID
	end
end catch
END
GO
