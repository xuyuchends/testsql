CREATE TABLE [dbo].[GoogleChartTableSummaryByPeriodAll]
(
[StoreID] [int] NOT NULL,
[MealPriod] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Period] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[BusinessDate] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[NumTables] [int] NULL,
[Type] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[GoogleChartTableSummaryByPeriodAll] ADD CONSTRAINT [PK_GoogleChartTableSummaryByPeriodAll] PRIMARY KEY CLUSTERED  ([StoreID], [MealPriod], [Period], [BusinessDate], [Type]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'''MONTH'',''DAY''', 'SCHEMA', N'dbo', 'TABLE', N'GoogleChartTableSummaryByPeriodAll', 'COLUMN', N'Type'
GO
