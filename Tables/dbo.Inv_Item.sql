CREATE TABLE [dbo].[Inv_Item]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Description] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RefNum] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CategoryID] [int] NOT NULL,
[HotItem] [bit] NOT NULL,
[RecipeUnitID] [int] NOT NULL,
[InitialCost] [decimal] (18, 2) NULL,
[CountPeriod] [int] NULL,
[CountUnitID] [int] NOT NULL,
[UPC] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WastePercent] [decimal] (18, 3) NULL,
[PrepItem] [bit] NOT NULL,
[AlertQty] [int] NULL,
[PreferredVendorID] [int] NULL,
[IsActive] [bit] NOT NULL,
[LastUpdate] [datetime] NULL,
[Creator] [int] NOT NULL,
[Editor] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Inv_Item] ADD CONSTRAINT [PK_Inv_Item] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Inv_Item] ADD CONSTRAINT [FK_Inv_Item_Inv_ItemCategory] FOREIGN KEY ([CategoryID]) REFERENCES [dbo].[Inv_ItemCategory] ([ID])
GO
ALTER TABLE [dbo].[Inv_Item] ADD CONSTRAINT [FK_Inv_Item_Inv_CountPeriods] FOREIGN KEY ([CountPeriod]) REFERENCES [dbo].[Inv_CountPeriods] ([ID])
GO
ALTER TABLE [dbo].[Inv_Item] ADD CONSTRAINT [FK_Inv_Item_Inv_UnitOfMeasures1] FOREIGN KEY ([CountUnitID]) REFERENCES [dbo].[Inv_UnitOfMeasures] ([ID])
GO
ALTER TABLE [dbo].[Inv_Item] ADD CONSTRAINT [FK_Inv_Item_Inv_Vendor] FOREIGN KEY ([PreferredVendorID]) REFERENCES [dbo].[Inv_Vendor] ([ID])
GO
ALTER TABLE [dbo].[Inv_Item] ADD CONSTRAINT [FK_Inv_Item_Inv_UnitOfMeasures] FOREIGN KEY ([RecipeUnitID]) REFERENCES [dbo].[Inv_UnitOfMeasures] ([ID])
GO
