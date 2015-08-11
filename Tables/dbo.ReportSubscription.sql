CREATE TABLE [dbo].[ReportSubscription]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReportDetailID] [int] NULL,
[Frequency] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StartDate] [datetime] NULL,
[EndDate] [datetime] NULL,
[SendTime] [datetime] NULL,
[SendToMe] [bit] NULL,
[SendTo] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FileType] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastSendDate] [datetime] NULL,
[CreatedDate] [datetime] NULL,
[UserID] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[ReportSubscription] ADD CONSTRAINT [PK_Subscription] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ReportSubscription] ADD CONSTRAINT [FK_ReportSubscription_ReportDetail] FOREIGN KEY ([ReportDetailID]) REFERENCES [dbo].[ReportDetail] ([ID])
GO
