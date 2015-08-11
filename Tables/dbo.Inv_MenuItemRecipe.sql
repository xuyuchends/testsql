CREATE TABLE [dbo].[Inv_MenuItemRecipe]
(
[InvMID] [int] NOT NULL,
[InvItemID] [int] NOT NULL,
[Qty] [decimal] (5, 2) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Inv_MenuItemRecipe] ADD CONSTRAINT [PK_Inv_MenuItemRecipe_1] PRIMARY KEY CLUSTERED  ([InvMID], [InvItemID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Inv_MenuItemRecipe] ADD CONSTRAINT [FK_Inv_MenuItemRecipe_Inv_Item] FOREIGN KEY ([InvItemID]) REFERENCES [dbo].[Inv_Item] ([ID])
GO
ALTER TABLE [dbo].[Inv_MenuItemRecipe] ADD CONSTRAINT [FK_Inv_MenuItemRecipe_Inv_MenuItem] FOREIGN KEY ([InvMID]) REFERENCES [dbo].[Inv_MenuItem] ([ID])
GO
