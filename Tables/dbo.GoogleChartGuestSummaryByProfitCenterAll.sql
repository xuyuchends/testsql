CREATE TABLE [dbo].[GoogleChartGuestSummaryByProfitCenterAll]
(
[StoreID] [int] NOT NULL,
[RevenueCenter] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Period] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[BusinessDate] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[NumGuest] [int] NULL,
[Type] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[GoogleChartGuestSummaryByProfitCenterAll] ADD CONSTRAINT [PK_GoogleChartGuestSummaryByProfitCenterAll] PRIMARY KEY CLUSTERED  ([StoreID], [RevenueCenter], [Period], [BusinessDate], [Type]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'''DAY'',''MONTH''', 'SCHEMA', N'dbo', 'TABLE', N'GoogleChartGuestSummaryByProfitCenterAll', 'COLUMN', N'Type'
GO
