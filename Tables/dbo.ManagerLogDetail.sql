CREATE TABLE [dbo].[ManagerLogDetail]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[HeaderID] [int] NOT NULL,
[ManagerLogID] [int] NOT NULL,
[UserID] [int] NULL,
[Flag] [bit] NOT NULL,
[LogEntry] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UpdateDate] [datetime] NULL CONSTRAINT [DF_ManagerLogDetail_UpdateDate] DEFAULT (getdate())
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[ManagerLogDetail] ADD CONSTRAINT [PK_ManagerLogDetail] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ManagerLogDetail] ADD CONSTRAINT [FK_ManagerLogDetail_ManagerLog] FOREIGN KEY ([ManagerLogID]) REFERENCES [dbo].[ManagerLog] ([ID])
GO
