CREATE TABLE [dbo].[GoogleChartSetting]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Name] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Describe] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ShowType] [int] NOT NULL CONSTRAINT [DF_GoogleChartSetting_TableOrChart] DEFAULT ((1)),
[IntervalType] [int] NOT NULL CONSTRAINT [DF_GoogleChartSetting_IntervalType] DEFAULT ((1)),
[IsShow] [bit] NOT NULL CONSTRAINT [DF_GoogleChartSetting_Enable] DEFAULT ((1)),
[Display] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[GoogleChartSetting] ADD CONSTRAINT [PK_GoogleChartSetting] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'day=0,month=1,quarter=2,year=3', 'SCHEMA', N'dbo', 'TABLE', N'GoogleChartSetting', 'COLUMN', N'IntervalType'
GO
EXEC sp_addextendedproperty N'MS_Description', N'table=0,chart=1', 'SCHEMA', N'dbo', 'TABLE', N'GoogleChartSetting', 'COLUMN', N'ShowType'
GO
