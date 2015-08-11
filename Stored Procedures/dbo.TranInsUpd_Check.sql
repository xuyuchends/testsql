SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[TranInsUpd_Check]
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
begin try
   INSERT INTO [Check](StoreID,ID,SaleTime,OrderID,EmployeeID,Seat,FutureOrderAdvPayment,
		BusinessDate,LastUpdate,Status)
	VALUES(@StoreID,@ID,@SaleTime,@OrderID,@EmployeeID,@Seat,@FutureOrderAdvPayment,
		@BusinessDate,GETDATE (),@Status)
END TRY
BEGIN CATCH
	if @@ERROR <>0
		UPDATE [Check] SET SaleTime=@SaleTime,OrderID=@OrderID,EmployeeID=@EmployeeID,Seat=@Seat,FutureOrderAdvPayment=@FutureOrderAdvPayment,BusinessDate=@BusinessDate,
		LastUpdate=GETDATE (),Status=@Status
		where StoreID=@StoreID and ID=@id and BusinessDate=@BusinessDate
end  CATCH

GO
