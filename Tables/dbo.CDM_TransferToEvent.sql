CREATE TABLE [dbo].[CDM_TransferToEvent]
(
[EventID] [int] NOT NULL,
[TransferTable] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TransferTableID] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CDM_TransferToEvent] ADD CONSTRAINT [PK_CDMTransferToEvent] PRIMARY KEY CLUSTERED  ([EventID], [TransferTable], [TransferTableID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CDM_TransferToEvent] ADD CONSTRAINT [FK_CDMTransferToEvent_CDMTransferEvent] FOREIGN KEY ([EventID]) REFERENCES [dbo].[CDM_TransferEvent] ([ID])
GO
