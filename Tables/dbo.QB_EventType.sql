CREATE TABLE [dbo].[QB_EventType]
(
[RefNum] [int] NOT NULL,
[EventDataType] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[QB_EventType] ADD CONSTRAINT [PK_QB_EventType] PRIMARY KEY CLUSTERED  ([RefNum], [EventDataType]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[QB_EventType] ADD CONSTRAINT [FK_QB_EventType_QB_Event] FOREIGN KEY ([RefNum]) REFERENCES [dbo].[QB_Event] ([RefNum])
GO
