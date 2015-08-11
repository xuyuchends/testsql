CREATE TABLE [dbo].[Inv_VendorTotenderType]
(
[VendorID] [int] NOT NULL,
[TenderTypeID] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Inv_VendorTotenderType] ADD CONSTRAINT [PK_Inventory_VendorTotenderType] PRIMARY KEY CLUSTERED  ([VendorID], [TenderTypeID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Inv_VendorTotenderType] ADD CONSTRAINT [FK_Inventory_VendorTotenderType_Inventory_TenderType] FOREIGN KEY ([TenderTypeID]) REFERENCES [dbo].[Inv_TenderType] ([ID])
GO
ALTER TABLE [dbo].[Inv_VendorTotenderType] ADD CONSTRAINT [FK_Inventory_VendorTotenderType_Inventory_Vendor] FOREIGN KEY ([VendorID]) REFERENCES [dbo].[Inv_Vendor] ([ID])
GO
