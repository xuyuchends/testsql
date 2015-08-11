SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[MoveAchiveDeleteRecords]
AS
BEGIN
	delete from Tax where exists 
(
select * from TaxArchive as a where 
a.StoreID=Tax.StoreID and a.TaxCategoryID=Tax.TaxCategoryID 
and a.CheckID=Tax.CheckID and a.OrderID=Tax.OrderID 
and a.Category=Tax.Category
)and
CONVERT(varchar(10), BusinessDate, 120 )<DATEADD(YEAR,-2,CONVERT(varchar(10), GETDATE(), 120 ))

delete from PaidOutTrx where exists 
(
select * from PaidOutTrxArchive as a where 
a.StoreID=PaidOutTrx.StoreID and a.ID=PaidOutTrx.ID 
and a.Amount=PaidOutTrx.Amount and a.ManagerID=PaidOutTrx.ManagerID
and a.EmployeeID=PaidOutTrx.EmployeeID and a.Note=PaidOutTrx.Note
and a.Status=PaidOutTrx.Status and a.BusinessDate=PaidOutTrx.BusinessDate
and a.LastUpdate=PaidOutTrx.LastUpdate
)
delete from PaidInTrx where exists 
(
select * from PaidInTrxArchive as a where 
a.StoreID=PaidInTrx.StoreID and a.ID=PaidInTrx.ID 
and a.Amount=PaidInTrx.Amount and a.ManagerID=PaidInTrx.ManagerID
and a.EmployeeID=PaidInTrx.EmployeeID and a.Note=PaidInTrx.Note
and a.Status=PaidInTrx.Status and a.BusinessDate=PaidInTrx.BusinessDate
and a.LastUpdate=PaidInTrx.LastUpdate
)
delete from Payment where exists 
(
select * from PaymentArchive as a where 
a.StoreID=Payment.StoreID and a.CheckID=Payment.CheckID
and a.LineNum=Payment.LineNum
)and
CONVERT(varchar(10), BusinessDate, 120 )<DATEADD(YEAR,-2,CONVERT(varchar(10), GETDATE(), 120 ))
delete from [Check] where exists 
(
select * from CheckArchive as a where 
a.StoreID=[Check].StoreID and a.ID=[Check].ID
)and
CONVERT(varchar(10), BusinessDate, 120 )<DATEADD(YEAR,-2,CONVERT(varchar(10), GETDATE(), 120 ))
delete from OrderLineItem where exists 
(
select * from OrderLineItemArchive as a where 
a.StoreID=OrderLineItem.StoreID and a.ID=OrderLineItem.ID
and a.OrderID=OrderLineItem.OrderID 
) and
CONVERT(varchar(10), BusinessDate, 120 )<DATEADD(YEAR,-2,CONVERT(varchar(10), GETDATE(), 120 ))
delete from [Order] where exists 
(
select * from OrderArchive as a where 
a.StoreID=[Order].StoreID and a.ID=[Order].ID 
)
and
CONVERT(varchar(10), BusinessDate, 120 )<DATEADD(YEAR,-2,CONVERT(varchar(10), GETDATE(), 120 ))
END
GO
