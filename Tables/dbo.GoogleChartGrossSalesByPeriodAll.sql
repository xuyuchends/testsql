CREATE TABLE [dbo].[GoogleChartGrossSalesByPeriodAll]
(
[StoreID] [int] NOT NULL,
[MealPriod] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Period] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[BusinessDate] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[GrossSales] [decimal] (18, 4) NULL,
[Type] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[GoogleChartGrossSalesByPeriodAll] ADD CONSTRAINT [PK_GoogleChartGrossSalesByPeriodAll] PRIMARY KEY CLUSTERED  ([StoreID], [MealPriod], [Period], [BusinessDate], [Type]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'''MONTH'',''DAY''', 'SCHEMA', N'dbo', 'TABLE', N'GoogleChartGrossSalesByPeriodAll', 'COLUMN', N'Type'
GO
