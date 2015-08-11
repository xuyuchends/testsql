CREATE TABLE [dbo].[DailyPaymentSummary]
(
[StoreID] [int] NULL,
[PaymentName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[NumPayments] [int] NULL,
[Sales] [decimal] (18, 2) NULL,
[TipTotal] [decimal] (18, 2) NULL,
[TtlSrvCharge] [decimal] (18, 2) NULL,
[TtlReceived] [decimal] (18, 2) NULL,
[BusinessDate] [datetime] NULL,
[LastUpdate] [datetime] NULL CONSTRAINT [DF_DailyPaymentSummary_LastUpdate] DEFAULT (getdate())
) ON [PRIMARY]
GO
CREATE CLUSTERED INDEX [IX_DailyPaymentSummary] ON [dbo].[DailyPaymentSummary] ([StoreID], [BusinessDate] DESC) ON [PRIMARY]
GO
