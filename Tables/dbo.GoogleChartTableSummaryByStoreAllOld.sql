CREATE TABLE [dbo].[GoogleChartTableSummaryByStoreAllOld]
(
[StoreID] [int] NOT NULL,
[NumTable] [int] NULL,
[Period] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[BusinessDate] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Type] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[GoogleChartTableSummaryByStoreAllOld] ADD CONSTRAINT [PK_GoogleChartTableSummaryByStoreAllOld] PRIMARY KEY CLUSTERED  ([StoreID], [Period], [BusinessDate], [Type]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'''MONTH'',''DAY''', 'SCHEMA', N'dbo', 'TABLE', N'GoogleChartTableSummaryByStoreAllOld', 'COLUMN', N'Type'
GO
