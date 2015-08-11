CREATE TABLE [dbo].[GoogleChartPositionSetting]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[StoreID] [int] NULL,
[PositionID] [int] NULL,
[ReportName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IntervalType] [int] NULL,
[IsShow] [bit] NULL,
[Display] [int] NULL,
[lastUpdate] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[GoogleChartPositionSetting] ADD CONSTRAINT [PK_GoogleChartPositionSetting] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
