CREATE TABLE [dbo].[OrderLineItemArchive]
(
[StoreID] [int] NOT NULL,
[ID] [bigint] NOT NULL,
[OrderID] [bigint] NOT NULL,
[RecordType] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ItemID] [int] NOT NULL,
[Price] [money] NOT NULL,
[Qty] [decimal] (10, 4) NOT NULL,
[Seat] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[AdjustedPrice] [money] NULL,
[AdjustID] [int] NULL,
[EmployeeID] [int] NULL,
[TimeOrdered] [datetime] NULL,
[ParentSplitLineNum] [int] NOT NULL,
[NumSplits] [smallint] NOT NULL,
[SI] [nvarchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SIText] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AsEntree] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BusinessDate] [datetime] NOT NULL,
[Status] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastUpdate] [datetime] NOT NULL,
[TaxCat] [nvarchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[OrderLineItemArchive] ADD CONSTRAINT [PK_OrderLineItemArchive_1] PRIMARY KEY CLUSTERED  ([StoreID], [ID], [OrderID], [BusinessDate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [BusinessDate] ON [dbo].[OrderLineItemArchive] ([BusinessDate], [Status]) INCLUDE ([AdjustedPrice], [AdjustID], [ItemID], [NumSplits], [ParentSplitLineNum], [Price], [Qty], [RecordType], [SI]) ON [PRIMARY]
GO
