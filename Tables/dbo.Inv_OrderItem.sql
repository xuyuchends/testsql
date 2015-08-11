CREATE TABLE [dbo].[Inv_OrderItem]
(
[OrderID] [int] NOT NULL,
[ItemID] [int] NOT NULL,
[ItemLineID] [int] NOT NULL,
[Qty] [decimal] (18, 2) NOT NULL,
[UnitPrice] [decimal] (18, 2) NOT NULL,
[OrderUnitID] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Inv_OrderItem] ADD CONSTRAINT [PK_Inv_OrderItem] PRIMARY KEY CLUSTERED  ([OrderID], [ItemID], [OrderUnitID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Inv_OrderItem] ADD CONSTRAINT [FK_Inv_OrderItem_Inv_Item] FOREIGN KEY ([ItemID]) REFERENCES [dbo].[Inv_Item] ([ID])
GO
ALTER TABLE [dbo].[Inv_OrderItem] ADD CONSTRAINT [FK_Inv_OrderItem_Inv_Order] FOREIGN KEY ([OrderID]) REFERENCES [dbo].[Inv_Order] ([ID])
GO
