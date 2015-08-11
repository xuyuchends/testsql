CREATE TABLE [dbo].[Check]
(
[StoreID] [int] NOT NULL,
[ID] [bigint] NOT NULL,
[SaleTime] [datetime] NULL,
[OrderID] [bigint] NOT NULL,
[EmployeeID] [int] NOT NULL,
[Seat] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[FutureOrderAdvPayment] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[BusinessDate] [datetime] NOT NULL,
[Status] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastUpdate] [datetime] NOT NULL
[LastUpdate1] [datetime]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Check] ADD CONSTRAINT [PK_Check] PRIMARY KEY CLUSTERED  ([StoreID], [ID], [BusinessDate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [BusinessDate] ON [dbo].[Check] ([BusinessDate] DESC, [Status]) INCLUDE ([FutureOrderAdvPayment], [OrderID]) ON [PRIMARY]
GO
