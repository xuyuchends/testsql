CREATE TABLE [dbo].[GoogleChartTableSummaryByProfitCenterAllOld]
(
[StoreID] [int] NOT NULL,
[RevenueCenter] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Period] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[BusinessDate] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[NumTables] [int] NULL,
[Type] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[GoogleChartTableSummaryByProfitCenterAllOld] ADD CONSTRAINT [PK_GoogleChartTableSummaryByProfitCenterAllOld] PRIMARY KEY CLUSTERED  ([StoreID], [RevenueCenter], [Period], [BusinessDate], [Type]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'''DAY'',''MONTH''', 'SCHEMA', N'dbo', 'TABLE', N'GoogleChartTableSummaryByProfitCenterAllOld', 'COLUMN', N'Type'
GO
