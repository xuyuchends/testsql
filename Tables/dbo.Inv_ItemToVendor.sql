CREATE TABLE [dbo].[Inv_ItemToVendor]
(
[ItemID] [int] NOT NULL,
[VendorID] [int] NOT NULL,
[SupplierCode] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastUnitPrice] [decimal] (18, 2) NULL,
[OrderUnit] [int] NOT NULL,
[StockPerOrder] [decimal] (18, 2) NULL,
[ReceipePerStock] [decimal] (18, 2) NULL,
[UPC] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DisplaySeq] [int] NOT NULL,
[LastUpdate] [datetime] NOT NULL,
[Creator] [int] NOT NULL,
[Editor] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Inv_ItemToVendor] ADD CONSTRAINT [PK_Inv_ItemToVendor] PRIMARY KEY CLUSTERED  ([ItemID], [VendorID], [OrderUnit]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Inv_ItemToVendor] ADD CONSTRAINT [FK_Inv_ItemToVendor_Inv_Item] FOREIGN KEY ([ItemID]) REFERENCES [dbo].[Inv_Item] ([ID])
GO
ALTER TABLE [dbo].[Inv_ItemToVendor] ADD CONSTRAINT [FK_Inv_ItemToVendor_Inv_UnitOfMeasures] FOREIGN KEY ([OrderUnit]) REFERENCES [dbo].[Inv_UnitOfMeasures] ([ID])
GO
ALTER TABLE [dbo].[Inv_ItemToVendor] ADD CONSTRAINT [FK_Inv_ItemToVendor_Inv_Vendor] FOREIGN KEY ([VendorID]) REFERENCES [dbo].[Inv_Vendor] ([ID])
GO
