CREATE TABLE [dbo].[ReportDetail]
(
[ID] [int] NOT NULL,
[Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DisplayName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Describe] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReportListID] [int] NOT NULL,
[OrganizationID] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ReportDetail] ADD CONSTRAINT [PK_ReportDetail] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ReportDetail] ADD CONSTRAINT [FK_ReportDetail_ReportList] FOREIGN KEY ([OrganizationID]) REFERENCES [dbo].[Organization] ([ID])
GO
