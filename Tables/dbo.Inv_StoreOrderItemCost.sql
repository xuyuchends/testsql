CREATE TABLE [dbo].[Inv_StoreOrderItemCost]
(
[StoreID] [int] NOT NULL,
[OrderID] [bigint] NOT NULL,
[LineItemID] [int] NOT NULL,
[TtlCost] [money] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Inv_StoreOrderItemCost] ADD CONSTRAINT [PK_Inv_StoreOrderItemCost] PRIMARY KEY CLUSTERED  ([StoreID], [OrderID], [LineItemID]) ON [PRIMARY]
GO
