CREATE TABLE [dbo].[DailyCategorySummaryByPeriod]
(
[StoreID] [int] NULL,
[Category] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TtlQty] [decimal] (18, 4) NULL,
[AdjustedTotal] [decimal] (18, 4) NULL,
[MealPeriod] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BusinessDate] [datetime] NULL,
[LastUpdate] [datetime] NULL CONSTRAINT [DF_DailyCategorySummaryByPeriod_LastUpdate] DEFAULT (getdate())
) ON [PRIMARY]
GO
CREATE CLUSTERED INDEX [IX_DailyCategorySummaryByPeriod] ON [dbo].[DailyCategorySummaryByPeriod] ([StoreID], [BusinessDate] DESC) ON [PRIMARY]
GO
