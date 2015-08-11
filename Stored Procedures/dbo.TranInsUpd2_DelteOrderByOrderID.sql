SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[TranInsUpd2_DelteOrderByOrderID]
@StoreID int,
@OrderID int ,
@BusinessDate datetime
AS
delete from Tax where StoreID=@StoreID and BusinessDate=@BusinessDate and OrderID=@OrderID 
delete from Payment where StoreID=@StoreID and BusinessDate=@BusinessDate and CheckID in (select ID from [check] where   StoreID=@StoreID and BusinessDate=@BusinessDate and OrderID=@OrderID)
delete from [check] where StoreID=@StoreID and BusinessDate=@BusinessDate and OrderID=@OrderID 
delete from Inv_ItemUsages where StoreID=@StoreID and BusinessDate=@BusinessDate and OrderID=@OrderID
delete from Inv_StoreOrderItemCost where StoreID=@StoreID and OrderID=@OrderID
delete from OrderLineItem where StoreID=@StoreID and BusinessDate=@BusinessDate and OrderID=@OrderID 
delete from [Order] where StoreID=@StoreID and BusinessDate=@BusinessDate and ID=@OrderID 



delete from TaxArchive where StoreID=@StoreID and BusinessDate=@BusinessDate and OrderID=@OrderID 
delete from PaymentArchive where StoreID=@StoreID and BusinessDate=@BusinessDate and CheckID in (select ID from [checkArchive] where   StoreID=@StoreID and BusinessDate=@BusinessDate and OrderID=@OrderID)
delete from [checkArchive] where StoreID=@StoreID and BusinessDate=@BusinessDate and OrderID=@OrderID 
delete from OrderLineItemArchive where StoreID=@StoreID and BusinessDate=@BusinessDate and OrderID=@OrderID 
delete from [OrderArchive] where StoreID=@StoreID and BusinessDate=@BusinessDate and ID=@OrderID 


GO
