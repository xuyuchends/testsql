CREATE TABLE [dbo].[DailyGuestTableSummaryByPC]
(
[StoreID] [int] NULL,
[RevenueCenterName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NumTables] [int] NULL,
[NumGuest] [int] NULL,
[NumChecks] [int] NULL,
[ProfitTotal] [decimal] (18, 4) NULL,
[BusinessDate] [datetime] NULL,
[LastUpdate] [datetime] NULL CONSTRAINT [DF_DailyGuestTableSummaryByPC_LastUpdate] DEFAULT (getdate())
) ON [PRIMARY]
GO
CREATE CLUSTERED INDEX [IX_DailyGuestTableSummaryByPC] ON [dbo].[DailyGuestTableSummaryByPC] ([StoreID], [BusinessDate] DESC) ON [PRIMARY]
GO
