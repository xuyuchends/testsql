CREATE TABLE [dbo].[Inv_ItemToStore]
(
[ItemID] [int] NOT NULL,
[StoreID] [int] NOT NULL,
[UnitOnHand] [decimal] (18, 4) NULL,
[LastUnitPrice] [decimal] (18, 2) NULL,
[Creator] [int] NOT NULL,
[Editor] [int] NULL,
[IsActive] [bit] NULL,
[LastUpdate] [datetime] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Inv_ItemToStore] ADD CONSTRAINT [PK_Inv_ItemStore] PRIMARY KEY CLUSTERED  ([ItemID], [StoreID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Inv_ItemToStore] ADD CONSTRAINT [FK_Inv_ItemStore_Inv_Item] FOREIGN KEY ([ItemID]) REFERENCES [dbo].[Inv_Item] ([ID])
GO
