CREATE TABLE [dbo].[GoogleChartLaborByStoreOld]
(
[StoreID] [int] NOT NULL,
[Period] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[BusinessDate] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Labor] [decimal] (18, 2) NULL,
[Sales] [decimal] (18, 4) NULL,
[LaborPercent] [decimal] (18, 2) NULL,
[Type] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[GoogleChartLaborByStoreOld] ADD CONSTRAINT [PK_GoogleChartLaborByStoreOld] PRIMARY KEY CLUSTERED  ([StoreID], [Period], [BusinessDate], [Type]) ON [PRIMARY]
GO
