CREATE TABLE [dbo].[EmployeeTimeSheet]
(
[StoreID] [int] NOT NULL,
[EmployeeID] [int] NOT NULL,
[ID] [int] NOT NULL,
[TimeIn] [datetime] NOT NULL,
[TimeOut] [datetime] NULL,
[CashTipsDeclared] [money] NULL,
[ChargedTipsDeclared] [money] NULL,
[ChargeSales] [money] NULL,
[Covers] [int] NULL,
[Discounts] [money] NULL,
[EntreeCount] [int] NULL,
[GCSold] [money] NULL,
[GCRedeemed] [money] NULL,
[PositionID] [int] NOT NULL,
[NetSales] [money] NULL,
[PayRate] [money] NULL,
[Numtables] [int] NULL,
[TaxCollected] [money] NULL,
[TipDeclared] [money] NULL,
[IndirectTipsDeclared] [money] NULL,
[TipPoolContribution] [money] NULL,
[BusinessDate] [datetime] NULL,
[LastUpdate] [datetime] NOT NULL,
[HoursWorked] [decimal] (18, 3) NULL,
[OT1HoursWorked] [decimal] (18, 3) NOT NULL,
[OT1Payrate] [money] NOT NULL,
[OT2HoursWorked] [decimal] (18, 3) NOT NULL,
[OT2Payrate] [money] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EmployeeTimeSheet] ADD CONSTRAINT [PK_EmployeeTimeSheet] PRIMARY KEY CLUSTERED  ([StoreID], [EmployeeID], [ID]) ON [PRIMARY]
GO
