CREATE TABLE [dbo].[Inv_ItemUsages]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[StoreID] [int] NOT NULL,
[InvItemID] [int] NOT NULL,
[Usage] [decimal] (18, 2) NOT NULL,
[UnitCostPerUnit] [decimal] (18, 2) NOT NULL,
[StMID] [int] NOT NULL,
[LineItemID] [int] NOT NULL,
[OrderID] [bigint] NOT NULL,
[BusinessDate] [datetime] NOT NULL,
[CreationDate] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Inv_ItemUsages] ADD CONSTRAINT [PK_Inv_ItemUsages] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
