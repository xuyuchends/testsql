CREATE TABLE [dbo].[GoogleChartVoidCompDiscontOld]
(
[StoreID] [int] NOT NULL,
[AdjustedValue] [decimal] (18, 4) NULL,
[RecordType] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Period] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[BusinessDate] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Type] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[GoogleChartVoidCompDiscontOld] ADD CONSTRAINT [PK_GoogleChartVoidCompDiscontOld] PRIMARY KEY CLUSTERED  ([StoreID], [RecordType], [Period], [BusinessDate], [Type]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'''MONTH'',''DAY''', 'SCHEMA', N'dbo', 'TABLE', N'GoogleChartVoidCompDiscontOld', 'COLUMN', N'Type'
GO
