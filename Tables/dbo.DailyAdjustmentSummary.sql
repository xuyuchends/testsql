CREATE TABLE [dbo].[DailyAdjustmentSummary]
(
[StoreID] [int] NULL,
[AdjustType] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AdjustName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Total] [decimal] (18, 4) NULL,
[Count] [int] NULL,
[BusinessDate] [datetime] NULL,
[Lastupdate] [datetime] NULL CONSTRAINT [DF_DailyAdjustmentSummary_lastupdate] DEFAULT (getdate())
) ON [PRIMARY]
GO
CREATE CLUSTERED INDEX [IX_DailyAdjustmentSummary] ON [dbo].[DailyAdjustmentSummary] ([StoreID], [BusinessDate] DESC) ON [PRIMARY]
GO
