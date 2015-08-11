CREATE TABLE [dbo].[GoogleChartSalesByStoreALLOld]
(
[StoreID] [int] NOT NULL,
[Period] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[BusinessDate] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Sales] [decimal] (18, 4) NULL,
[Type] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SalesType] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[GoogleChartSalesByStoreALLOld] ADD CONSTRAINT [PK_GoogleChartSalesByStoreALLOld] PRIMARY KEY CLUSTERED  ([StoreID], [Period], [BusinessDate], [Type], [SalesType]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'''GROSSSALES'',''NETSALES''', 'SCHEMA', N'dbo', 'TABLE', N'GoogleChartSalesByStoreALLOld', 'COLUMN', N'SalesType'
GO
EXEC sp_addextendedproperty N'MS_Description', N'''MONTH'',''DAY''', 'SCHEMA', N'dbo', 'TABLE', N'GoogleChartSalesByStoreALLOld', 'COLUMN', N'Type'
GO
