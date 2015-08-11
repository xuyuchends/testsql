CREATE TABLE [dbo].[DailyCategorySummaryByPC]
(
[StoreID] [int] NULL,
[RevenueCenter] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Category] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CatTotal] [decimal] (18, 4) NULL,
[BusinessDate] [datetime] NULL,
[LastUpdate] [datetime] NULL CONSTRAINT [DF_DailyCategorySummaryByPC_LastUpdate] DEFAULT (getdate())
) ON [PRIMARY]
GO
CREATE CLUSTERED INDEX [IX_DailyCategorySummaryByPC] ON [dbo].[DailyCategorySummaryByPC] ([StoreID], [BusinessDate] DESC) ON [PRIMARY]
GO
