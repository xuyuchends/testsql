CREATE TABLE [dbo].[DailySaleDetails]
(
[StoreID] [int] NULL,
[GCSales] [decimal] (18, 4) NULL,
[TotalPaidIn] [decimal] (18, 2) NULL,
[InHousePaymentSales] [decimal] (18, 4) NULL,
[advPayment] [decimal] (18, 2) NULL,
[surchageamt] [decimal] (18, 2) NULL,
[TotalPaidOut] [decimal] (18, 2) NULL,
[PaidAdv] [decimal] (18, 2) NULL,
[ReimbursementTtl] [decimal] (18, 2) NULL,
[Tipwithheld] [decimal] (18, 2) NULL,
[CashDeposit] [decimal] (18, 2) NULL,
[GrossCash] [decimal] (18, 2) NULL,
[CCTipTtl] [decimal] (18, 2) NULL,
[TtlSrvCharge] [decimal] (18, 2) NULL,
[GCChangeTTL] [decimal] (18, 2) NULL,
[NetCash] [decimal] (18, 2) NULL,
[OtherPayments] [decimal] (18, 2) NULL,
[CashOverShort] [decimal] (18, 2) NULL,
[BusinessDate] [datetime] NULL,
[NetSaleTotal] [decimal] (18, 4) NULL,
[TaxTotal] [decimal] (18, 2) NULL,
[CashSrvChargeTTL] [decimal] (18, 2) NULL,
[LastUpdate] [datetime] NULL CONSTRAINT [DF_DailySaleDetails_LastUpdate] DEFAULT (getdate()),
[ReturnsTotal] [decimal] (18, 2) NULL
) ON [PRIMARY]
GO
CREATE CLUSTERED INDEX [IX_DailySaleDetails] ON [dbo].[DailySaleDetails] ([StoreID], [BusinessDate] DESC) ON [PRIMARY]
GO
