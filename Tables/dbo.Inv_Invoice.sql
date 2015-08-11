CREATE TABLE [dbo].[Inv_Invoice]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[InvOrderID] [int] NOT NULL,
[Num] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Status] [int] NOT NULL,
[DueDate] [datetime] NULL,
[DeliveryDate] [datetime] NULL,
[InvoiceDate] [datetime] NULL,
[WeekEnding] [datetime] NULL,
[ReceivedByID] [int] NOT NULL,
[InvoiceTotal] [decimal] (18, 2) NOT NULL,
[DiscountTotal] [decimal] (18, 2) NULL,
[TaxTotal] [decimal] (18, 2) NULL,
[ShippingTotal] [decimal] (18, 2) NULL,
[PaidTotal] [decimal] (18, 2) NULL,
[TenderTypeID] [int] NOT NULL,
[CheckNum] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Comment] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastUpdate] [datetime] NULL,
[CreatedID] [int] NOT NULL,
[CreatedName] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[EditorID] [int] NULL,
[EditorName] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreationDate] [datetime] NULL,
[storeid] [int] NOT NULL,
[vendorid] [int] NOT NULL,
[SubTotal] [decimal] (18, 2) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create TRIGGER [dbo].[tgr_MoveToInv_invoiceHistory]
   ON  [dbo].[Inv_Invoice]
   AFTER INSERT,DELETE,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	-- insert 
if exists (select *  from inserted) and not exists(select *  from deleted)
begin
	INSERT INTO Inv_invoiceHistory 
	select ID,DiscountTotal,SubTotal,ShippingTotal,TaxTotal,CheckNum,Status,InvoiceDate,CreationDate,
	EditorID,EditorName,Num,LastUpdate,PaidTotal  from inserted
end
-- update 
else if  exists (select *  from inserted) and  exists(select *  from deleted)
begin
	INSERT INTO Inv_invoiceHistory 
	select i.ID,i.DiscountTotal,i.SubTotal,i.ShippingTotal,i.TaxTotal,i.CheckNum,i.Status,i.InvoiceDate,
	i.CreationDate,i.EditorID,i.EditorName,i.Num,i.LastUpdate,i.PaidTotal from inserted as i
	inner join deleted as d on i.ID=d.ID and (i.DiscountTotal != d.DiscountTotal or i.SubTotal!=d.SubTotal 
	or i.ShippingTotal!=d.ShippingTotal or i.TaxTotal!=d.TaxTotal or i.CheckNum!=d.CheckNum or
	 i.Status!=d.Status
	or i.InvoiceDate!=d.InvoiceDate or i.CreationDate!=d.CreationDate or i.EditorID!=d.EditorID 
	or i.EditorName!=d.EditorName or i.Num!=d.Num or i.PaidTotal!=d.PaidTotal
	)
end	
else if not  exists (select *  from inserted) and  exists(select *  from deleted)
begin
	INSERT INTO Inv_invoiceHistory 
	select ID,DiscountTotal,SubTotal,ShippingTotal,TaxTotal,CheckNum,Status,InvoiceDate,CreationDate,
	EditorID,EditorName,Num,LastUpdate,PaidTotal  from deleted
end

END
GO
ALTER TABLE [dbo].[Inv_Invoice] ADD CONSTRAINT [PK_Inv_Invoice] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Inv_Invoice] ADD CONSTRAINT [FK_Inv_Invoice_Inv_Order] FOREIGN KEY ([InvOrderID]) REFERENCES [dbo].[Inv_Order] ([ID])
GO
ALTER TABLE [dbo].[Inv_Invoice] ADD CONSTRAINT [FK_Inv_Invoice_Inv_TenderType] FOREIGN KEY ([TenderTypeID]) REFERENCES [dbo].[Inv_TenderType] ([ID])
GO
