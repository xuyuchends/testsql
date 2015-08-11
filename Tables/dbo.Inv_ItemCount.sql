CREATE TABLE [dbo].[Inv_ItemCount]
(
[CountID] [int] NOT NULL IDENTITY(1, 1),
[WeekEnding] [datetime] NOT NULL,
[StoreID] [int] NOT NULL,
[CountType] [int] NOT NULL,
[LastUpdate] [datetime] NOT NULL,
[Creator] [int] NOT NULL,
[Editor] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Inv_ItemCount] ADD CONSTRAINT [CK_Inv_ItemCount] CHECK ((datepart(weekday,[WeekEnding])=(7)))
GO
ALTER TABLE [dbo].[Inv_ItemCount] ADD CONSTRAINT [PK_Inv_ItemCount] PRIMARY KEY CLUSTERED  ([WeekEnding], [StoreID]) ON [PRIMARY]
GO
