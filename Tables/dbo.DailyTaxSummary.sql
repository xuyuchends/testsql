CREATE TABLE [dbo].[DailyTaxSummary]
(
[StoreID] [int] NULL,
[Taxname] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TaxAmt] [decimal] (18, 2) NULL,
[OrderAmt] [decimal] (18, 2) NULL,
[BusinessDate] [datetime] NULL,
[LastUpdate] [datetime] NULL CONSTRAINT [DF_DailyTaxSummary_LastUpdate] DEFAULT (getdate())
) ON [PRIMARY]
GO
CREATE CLUSTERED INDEX [IX_DailyTaxSummary] ON [dbo].[DailyTaxSummary] ([StoreID], [BusinessDate] DESC) ON [PRIMARY]
GO
