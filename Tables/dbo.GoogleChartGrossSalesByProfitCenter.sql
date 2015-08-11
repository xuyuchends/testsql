CREATE TABLE [dbo].[GoogleChartGrossSalesByProfitCenter]
(
[StoreID] [int] NOT NULL,
[RevenueCenter] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Period] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[BusinessDate] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[GrossSales] [decimal] (18, 4) NULL,
[Type] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[GoogleChartGrossSalesByProfitCenter] ADD CONSTRAINT [PK_GoogleChartGrossSalesByProfitCenter] PRIMARY KEY CLUSTERED  ([StoreID], [RevenueCenter], [Period], [BusinessDate], [Type]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'''DAY'',''MONTH''', 'SCHEMA', N'dbo', 'TABLE', N'GoogleChartGrossSalesByProfitCenter', 'COLUMN', N'Type'
GO
