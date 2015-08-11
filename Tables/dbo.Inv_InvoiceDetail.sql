CREATE TABLE [dbo].[Inv_InvoiceDetail]
(
[InvoiceID] [int] NOT NULL,
[InvItemID] [int] NOT NULL,
[ItemLineID] [int] NOT NULL,
[Qty] [decimal] (18, 2) NULL,
[UnitPrice] [decimal] (18, 2) NULL,
[OrderUnitID] [int] NOT NULL,
[DiscountAmt] [decimal] (18, 2) NULL,
[ShoppingAmt] [decimal] (18, 2) NULL,
[TaxAmt] [decimal] (18, 2) NULL,
[LedgerID] [int] NULL,
[IsReceived] [bit] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Inv_InvoiceDetail] ADD CONSTRAINT [PK_Inv_InvoiceDetail_1] PRIMARY KEY CLUSTERED  ([InvoiceID], [InvItemID], [OrderUnitID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Inv_InvoiceDetail] ADD CONSTRAINT [FK_Inv_InvoiceDetail_Inv_Item] FOREIGN KEY ([InvItemID]) REFERENCES [dbo].[Inv_Item] ([ID])
GO
ALTER TABLE [dbo].[Inv_InvoiceDetail] ADD CONSTRAINT [FK_Inv_InvoiceDetail_Inv_Invoice] FOREIGN KEY ([InvoiceID]) REFERENCES [dbo].[Inv_Invoice] ([ID])
GO
