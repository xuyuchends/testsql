CREATE TABLE [dbo].[DailyCheckOuts]
(
[StoreID] [int] NOT NULL,
[CheckOutID] [int] NOT NULL,
[RunDate] [datetime] NULL,
[RunTime] [datetime] NULL,
[BusinessDate] [datetime] NULL,
[ServerID] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserID] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NumSaleRec] [int] NULL,
[TotalSales] [money] NULL,
[TotalTip] [money] NULL,
[TotalPymnt] [money] NULL,
[Status] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CashSales] [money] NULL,
[ChargeSales] [money] NULL,
[NetSales] [money] NULL,
[ActualBusinessDate] [datetime] NULL,
[CashDue] [money] NOT NULL,
[CashReceived] [money] NOT NULL,
[ActualCashEntered] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Covers] [bigint] NULL,
[Discounts] [money] NULL,
[EntreeCount] [bigint] NULL,
[GCSold] [money] NULL,
[GCRedeemed] [money] NULL,
[NumTables] [bigint] NULL,
[TaxCollected] [money] NULL,
[OtherSales] [money] NULL,
[ChargeTips] [money] NULL,
[CompleteStatus] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TipWithheld] [money] NULL,
[LastUpdate] [datetime] NOT NULL CONSTRAINT [DF_DailyCheckOuts_LastUpdate] DEFAULT (getdate())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DailyCheckOuts] ADD CONSTRAINT [PK_DailyCheckOuts] PRIMARY KEY CLUSTERED  ([StoreID], [CheckOutID]) ON [PRIMARY]
GO
