SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Inv_invoiceHistory_Sel]
(
	@InvoiceID int,
	@SQLOperationType nvarchar(50)
)
as
BEGIN
	SET NOCOUNT ON;
	 if (@SQLOperationType='SQLSELECT')
SELECT i.ID
      ,i.InvoiceID
      ,i.Discount
      ,i.SubTotal
      ,   isnull((
      select top 1 case when ( hi.SubTotal-hi.Discount+hi.Shipping+hi.Tax )=0 then 0 else
       i.SubTotal-i.Discount+i.Shipping+i.Tax-(hi.SubTotal-hi.Discount+hi.Shipping+hi.Tax) end  from Inv_invoiceHistory as hi 
      where hi.InvoiceID=i.InvoiceID and hi.ID<i.ID order by ID desc),0) as DiffTotal
      ,i.Shipping
      ,i.Tax
      ,i.CheckNum
      ,i.Status
      ,i.PaidDate
      ,i.CreationDate
      ,i.UserID
      ,i.UserName
      ,i.Num
      ,i.LastUpdate
      ,i.PaidTotal
  FROM Inv_invoiceHistory as i where i.InvoiceID=@InvoiceID
END
GO
