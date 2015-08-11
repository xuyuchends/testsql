CREATE TABLE [dbo].[Inv_ItemCountDetail]
(
[CountID] [int] NOT NULL,
[ItemID] [int] NOT NULL,
[StockUnitQOH] [decimal] (18, 2) NULL,
[UseUnitQOH] [decimal] (18, 2) NULL,
[StockUnitTOH] [decimal] (18, 2) NULL,
[UseUnitTOH] [decimal] (18, 2) NULL,
[CountQOH] [decimal] (18, 2) NULL,
[TOH] [decimal] (18, 2) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Inv_ItemCountDetail] ADD CONSTRAINT [PK_Inv_ItemCountDetail] PRIMARY KEY CLUSTERED  ([CountID], [ItemID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Inv_ItemCountDetail] ADD CONSTRAINT [FK_Inv_ItemCountDetail_Inv_ItemCountDetail] FOREIGN KEY ([CountID], [ItemID]) REFERENCES [dbo].[Inv_ItemCountDetail] ([CountID], [ItemID])
GO
ALTER TABLE [dbo].[Inv_ItemCountDetail] ADD CONSTRAINT [FK_Inv_ItemCountDetail_Inv_Item] FOREIGN KEY ([ItemID]) REFERENCES [dbo].[Inv_Item] ([ID])
GO
