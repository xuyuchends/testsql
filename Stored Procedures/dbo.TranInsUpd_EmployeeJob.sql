SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[TranInsUpd_EmployeeJob]
@StoreID int,
@ID int ,
@EmployeeID int, 
@PositionID int, 
@Wage money, 
@OvertimeWage money,
@WageType nvarchar(50),
@OverTimeRate money

AS
BEGIN
 --UPDATE EmployeeJob SET EmployeeID = @EmployeeID,PositionID = @PositionID,Wage = @Wage,OvertimeWage = @OvertimeWage,LastUpdate = getDate(),WageType=@WageType,OverTimeRate=@OverTimeRate WHERE StoreID = @StoreID and ID = @ID
 --if(@@rowcount=0)
 INSERT INTO EmployeeJob (StoreID,ID,EmployeeID,PositionID,Wage,OvertimeWage,LastUpdate,WageType,OverTimeRate) VALUES( @StoreID, @ID, @EmployeeID, @PositionID, @Wage, @OvertimeWage, getDate(),@WageType,@OverTimeRate)
END
GO
