CREATE TABLE [dbo].[DailyGuestTableSummaryByPeriod]
(
[StoreID] [int] NULL,
[SaleGroup] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[RecordType] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Value] [decimal] (18, 2) NULL,
[OrderCol] [int] NULL,
[BusinessDate] [datetime] NULL,
[LastUpdate] [datetime] NULL CONSTRAINT [DF_DailyGuestTableSummaryByPeriod_LastUpdate] DEFAULT (getdate())
) ON [PRIMARY]
GO
CREATE CLUSTERED INDEX [IX_DailyGuestTableSummaryByPeriod] ON [dbo].[DailyGuestTableSummaryByPeriod] ([StoreID], [BusinessDate] DESC) ON [PRIMARY]
GO
