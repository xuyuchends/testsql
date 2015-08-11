CREATE TABLE [dbo].[DailyDepartmentSales]
(
[StoreID] [int] NULL,
[Department] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Category] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MenuItem] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GrossSales] [decimal] (18, 4) NULL,
[Voids] [decimal] (18, 4) NULL,
[Comps] [decimal] (18, 4) NULL,
[Discount] [decimal] (18, 4) NULL,
[BusinessDate] [datetime] NULL,
[LastUpdate] [datetime] NULL CONSTRAINT [DF_DailyDepartmentSales_LastUpdate] DEFAULT (getdate()),
[Returns] [decimal] (18, 2) NULL
) ON [PRIMARY]
GO
CREATE CLUSTERED INDEX [IX_DailyDepartmentSales] ON [dbo].[DailyDepartmentSales] ([StoreID], [BusinessDate] DESC) ON [PRIMARY]
GO
