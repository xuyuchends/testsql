CREATE TABLE [dbo].[CheckArchive]
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
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CheckArchive] ADD CONSTRAINT [PK_CheckArchive] PRIMARY KEY CLUSTERED  ([StoreID], [ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [BusinessDate] ON [dbo].[CheckArchive] ([BusinessDate] DESC, [Status]) INCLUDE ([FutureOrderAdvPayment], [OrderID]) ON [PRIMARY]
GO
