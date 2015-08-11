SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Inv_Invoice_Sel]
(
	@ID int,
	@InvOrderID int,
	@StoreID int,
	@VendorID int,
	@Num nvarchar(50) ,
	@Status int,
	@DueDate datetime ,
	@DeliveryDate datetime ,
	@InvoiceDate datetime ,
	@WeekEnding datetime ,
	@ReceivedByID int,
	@InvoiceTotal money,
	@DiscountTotal money ,
	@TaxTotal money ,
	@ShippingTotal money ,
	@PaidTotal money ,
	@TenderTypeID int,
	@CheckNum nvarchar(50) ,
	@Comment nvarchar(max) ,
	@LastUpdate datetime ,
	@CreatedID int,
	@CreatedName nvarchar(200),
	@EditorID int ,
	@EditorName nvarchar(200) ,
	@SQLOperationType nvarchar(50)
)
as
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	 if (@SQLOperationType='SQLSELECTDETAIL')
		SELECT i.[ID],[InvOrderID],[VendorID],i.[StoreID],[Num],[Status],[DueDate],[DeliveryDate]
      ,[InvoiceDate],[WeekEnding],[ReceivedByID],[InvoiceTotal],[DiscountTotal],[TaxTotal],[ShippingTotal]
      ,[PaidTotal],[TenderTypeID],[CheckNum],[Comment],i.[LastUpdate],[CreatedID],[CreatedName]
      ,[EditorID],[EditorName],[CreationDate],t.Name TenderTypeName,i.SubTotal,v.Name VendorName 
      ,eu.FirstName,eu.LastName from Inv_Invoice i
      inner join Inv_TenderType t on i.TenderTypeID=t.ID
      inner join Inv_Vendor v on v.ID=i.VendorID
      inner join EnterpriseUser eu on eu.ID=i.ReceivedByID  where i.id=@id
	else if (@SQLOperationType='SQLSELECT')
	begin
		--declare @WeekEndingShow datetime
		declare @WeekStartDay int =0
		select top 1 @WeekStartDay =WeekStartDay from  LaborWeekStart
		if (@WeekStartDay<0)
				set @WeekStartDay=7-@WeekStartDay
		--set @WeekEndingShow=dateadd(day,case when datepart(weekday,@WeekEnding)=1 then 0 
		--else 1-(datepart(weekday,@WeekEnding)) +6+@WeekStartDay end,@WeekEnding)
		
		SELECT i.[ID],[InvOrderID],i.[VendorID],i.[StoreID],[Num],[Status],[DueDate],[DeliveryDate]
      ,[InvoiceDate],[WeekEnding],[ReceivedByID],[InvoiceTotal],[DiscountTotal],[TaxTotal],[ShippingTotal]
      ,[PaidTotal],[TenderTypeID],[CheckNum],[Comment],i.[LastUpdate],i.[CreatedID],i.[CreatedName]
      ,i.[EditorID],i.[EditorName],i.[CreationDate],t.Name TenderTypeName,i.SubTotal,v.Name VendorName 
      ,eu.FirstName,eu.LastName,InvoiceTotal-ShippingTotal-i.SubTotal-TaxTotal+DiscountTotal as Unallocated
      ,o.PONum
      from Inv_Invoice i
      inner join Inv_TenderType t on i.TenderTypeID=t.ID
      inner join Inv_Vendor v on v.ID=i.VendorID
      inner join EnterpriseUser eu on eu.ID=i.ReceivedByID 
      inner join Inv_Order o on o.ID=i.InvOrderID
      where 
      WeekEnding =DATEADD(day,-@WeekStartDay, @WeekEnding)
      and i.StoreID=@StoreID
	end
END
GO
