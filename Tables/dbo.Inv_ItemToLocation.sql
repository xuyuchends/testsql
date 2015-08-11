CREATE TABLE [dbo].[Inv_ItemToLocation]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[StoreID] [int] NOT NULL,
[InvItemID] [int] NOT NULL,
[LocationID] [int] NOT NULL,
[DisplaySeq] [int] NOT NULL,
[Creator] [int] NOT NULL,
[Editor] [int] NULL,
[lastUpdate] [datetime] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Inv_ItemToLocation] ADD CONSTRAINT [PK_Inv_ItemToLocation] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
