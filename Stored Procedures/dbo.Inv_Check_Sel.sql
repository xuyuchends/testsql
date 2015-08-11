SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Inv_Check_Sel]
(
	@ID int  ,
	@InvoiceNum nvarchar(50) ,
	@Type int ,
	@CheckNum nvarchar(50) ,
	@VendorID int ,
	@Amount decimal(18, 2) ,
	@Comment nvarchar(max) ,
	@CreationDate datetime ,
	@LastUpdate datetime ,
	@Creator int ,
	@Editor int ,
	@SQLOperationType nvarchar(50)
)
as
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	if (@SQLOperationType='SQLSELECT')
		SELECT c.ID,c.InvoiceNum,c.Type,c.CheckNum,c.VendorID as VendorID, v.name as VendorName,c.Amount,c.Comment,c.CreationDate,c.LastUpdate,c.Creator,c.Editor
			FROM  Inv_Check as c inner join Inv_Vendor as v on c.VendorID=v.id
			order by LastUpdate desc	
	else if (@SQLOperationType='SQLSELECTDETAIL')
		SELECT ID,InvoiceNum,Type,CheckNum,VendorID,Amount,Comment,CreationDate,LastUpdate,Creator,Editor
		FROM  Inv_Check where ID=@ID
END
GO
