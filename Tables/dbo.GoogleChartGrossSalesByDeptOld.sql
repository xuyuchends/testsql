CREATE TABLE [dbo].[GoogleChartGrossSalesByDeptOld]
(
[StoreID] [int] NOT NULL,
[Department] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Period] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[BusinessDate] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[GrossSales] [decimal] (18, 4) NULL,
[Type] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[GoogleChartGrossSalesByDeptOld] ADD CONSTRAINT [PK_GoogleChartGrossSalesOld] PRIMARY KEY CLUSTERED  ([StoreID], [Department], [Period], [BusinessDate], [Type]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'dbo', 'TABLE', N'GoogleChartGrossSalesByDeptOld', 'COLUMN', N'StoreID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'''DAY'',''MONTH''', 'SCHEMA', N'dbo', 'TABLE', N'GoogleChartGrossSalesByDeptOld', 'COLUMN', N'Type'
GO
