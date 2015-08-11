CREATE TABLE [dbo].[GoogleChartGrossSalesByProfitCenterOld]
(
[StoreID] [int] NOT NULL,
[RevenueCenter] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Period] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[BusinessDate] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[GrossSales] [decimal] (18, 4) NULL,
[Type] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[GoogleChartGrossSalesByProfitCenterOld] ADD CONSTRAINT [PK_GoogleChartGrossSalesByProfitCenterOld] PRIMARY KEY CLUSTERED  ([StoreID], [RevenueCenter], [Period], [BusinessDate], [Type]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'''DAY'',''MONTH''', 'SCHEMA', N'dbo', 'TABLE', N'GoogleChartGrossSalesByProfitCenterOld', 'COLUMN', N'Type'
GO
