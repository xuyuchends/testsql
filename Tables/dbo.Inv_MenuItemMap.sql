CREATE TABLE [dbo].[Inv_MenuItemMap]
(
[StoreID] [int] NULL,
[InvMID] [int] NOT NULL,
[stMID] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Inv_MenuItemMap] ADD CONSTRAINT [FK_Inv_MenuItemMap_Inv_MenuItem] FOREIGN KEY ([InvMID]) REFERENCES [dbo].[Inv_MenuItem] ([ID])
GO
