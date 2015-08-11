CREATE TABLE [dbo].[Inv_ItemToStoreArchive]
(
[ItemID] [int] NOT NULL,
[StoreID] [int] NOT NULL,
[UnitOnHand] [decimal] (18, 4) NULL,
[LastUnitPrice] [decimal] (18, 2) NOT NULL,
[BusinessDate] [datetime] NOT NULL,
[LastUpdate] [datetime] NULL
) ON [PRIMARY]
GO
