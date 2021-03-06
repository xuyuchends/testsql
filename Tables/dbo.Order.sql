CREATE TABLE [dbo].[Order]
(
[StoreID] [int] NOT NULL,
[ID] [bigint] NOT NULL,
[OpenTime] [datetime] NOT NULL,
[CloseTime] [datetime] NOT NULL,
[EmpIDOpen] [int] NOT NULL,
[EmpIDClose] [int] NOT NULL,
[TableName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[GuestCount] [int] NOT NULL,
[RevenueCenter] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MealPeriod] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LineItemCount] [int] NULL,
[CheckCount] [int] NULL,
[PaymentCount] [int] NULL,
[TaxCount] [int] NULL,
[FutureOrder] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BusinessDate] [datetime] NOT NULL,
[LastUpdate] [datetime] NOT NULL,
[Status] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Order] ADD CONSTRAINT [PK_Order] PRIMARY KEY CLUSTERED  ([StoreID], [ID], [BusinessDate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [BusinessDate] ON [dbo].[Order] ([BusinessDate] DESC, [Status]) INCLUDE ([FutureOrder], [GuestCount], [MealPeriod], [OpenTime], [RevenueCenter]) ON [PRIMARY]
GO
