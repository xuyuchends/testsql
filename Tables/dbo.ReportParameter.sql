CREATE TABLE [dbo].[ReportParameter]
(
[ParaID] [int] NOT NULL,
[ReportDetailID] [int] NOT NULL,
[ParaName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ID] [int] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ReportParameter] ADD CONSTRAINT [PK_ReportParameter] PRIMARY KEY CLUSTERED  ([ParaID], [ReportDetailID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ReportParameter] ADD CONSTRAINT [FK_ReportParameter_ReportDetail] FOREIGN KEY ([ReportDetailID]) REFERENCES [dbo].[ReportDetail] ([ID])
GO
