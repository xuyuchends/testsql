CREATE TABLE [dbo].[Tax]
(
[StoreID] [int] NOT NULL,
[TaxCategoryID] [int] NOT NULL,
[CheckID] [bigint] NOT NULL,
[OrderID] [bigint] NOT NULL,
[Category] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TaxAmt] [decimal] (19, 10) NOT NULL,
[TaxOrderAmt] [decimal] (19, 10) NOT NULL,
[BusinessDate] [datetime] NOT NULL,
[LastUpdate] [datetime] NOT NULL,
[Status] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Tax] ADD CONSTRAINT [PK_Tax_1] PRIMARY KEY CLUSTERED  ([StoreID], [TaxCategoryID], [CheckID], [OrderID], [Category], [BusinessDate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [BusinessDate] ON [dbo].[Tax] ([BusinessDate] DESC) INCLUDE ([TaxAmt]) ON [PRIMARY]
GO
