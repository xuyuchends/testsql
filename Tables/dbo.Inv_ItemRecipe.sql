CREATE TABLE [dbo].[Inv_ItemRecipe]
(
[RecipeItemID] [int] NOT NULL,
[InvItemID] [int] NOT NULL,
[Qty] [decimal] (18, 2) NOT NULL,
[LastUpdate] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Inv_ItemRecipe] ADD CONSTRAINT [PK_Inv_ItemRecipe_1] PRIMARY KEY CLUSTERED  ([RecipeItemID], [InvItemID]) ON [PRIMARY]
GO
