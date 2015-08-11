SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create PROCEDURE [dbo].[TranInsUpd2_Check]
@StoreID int ,
@ID bigint ,
@SaleTime datetime,
@OrderID bigint ,
@EmployeeID int ,
@Seat nvarchar(200) ,
@FutureOrderAdvPayment char(1), 
@BusinessDate datetime ,
@Status nvarchar(20)
AS
   INSERT INTO [Check](StoreID,ID,SaleTime,OrderID,EmployeeID,Seat,FutureOrderAdvPayment,BusinessDate,LastUpdate,Status)
	VALUES(@StoreID,@ID,@SaleTime,@OrderID,@EmployeeID,@Seat,@FutureOrderAdvPayment,@BusinessDate,GETDATE (),@Status)


GO
