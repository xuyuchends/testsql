CREATE TABLE [dbo].[GoogleChartNumberByPaymentTypeAllOld]
(
[StoreID] [int] NOT NULL,
[Payment] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Period] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[BusinessDate] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[NumPayment] [int] NULL,
[Type] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[GoogleChartNumberByPaymentTypeAllOld] ADD CONSTRAINT [PK_GoogleChartNumberByPaymentTypeAllOld] PRIMARY KEY CLUSTERED  ([StoreID], [Payment], [Period], [BusinessDate], [Type]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'''MONTH'',''DAY''', 'SCHEMA', N'dbo', 'TABLE', N'GoogleChartNumberByPaymentTypeAllOld', 'COLUMN', N'Type'
GO
