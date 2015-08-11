CREATE TABLE [dbo].[QB_Event]
(
[RefNum] [int] NOT NULL IDENTITY(1, 1),
[ProfileID] [int] NOT NULL,
[BeginTime] [datetime] NOT NULL,
[EndTime] [datetime] NOT NULL,
[State] [int] NOT NULL,
[EditorID] [int] NOT NULL,
[EditorName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LastUpdate] [datetime] NOT NULL,
[DownLoadUserName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsBalance] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[QB_Event] ADD CONSTRAINT [PK_QB_Event_1] PRIMARY KEY CLUSTERED  ([RefNum]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[QB_Event] ADD CONSTRAINT [FK_QB_Event_QB_Event] FOREIGN KEY ([ProfileID]) REFERENCES [dbo].[QB_Profile] ([ID])
GO
