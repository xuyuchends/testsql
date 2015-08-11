CREATE TABLE [dbo].[CDM_TransferEventErrorLog]
(
[EventDetailID] [int] NOT NULL,
[StoreID] [int] NOT NULL,
[ErrorTable] [int] NOT NULL,
[ErrorID] [int] NULL,
[ErrorMessage] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreateTime] [datetime] NOT NULL,
[Status] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[CDM_TransferEventErrorLog] ADD CONSTRAINT [PK_CDMTransferEventErrorLog] PRIMARY KEY CLUSTERED  ([EventDetailID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CDM_TransferEventErrorLog] ADD CONSTRAINT [FK_CDMTransferEventErrorLog_CDMTransferEventDetail] FOREIGN KEY ([EventDetailID]) REFERENCES [dbo].[CDM_TransferEventDetail] ([ID])
GO
EXEC sp_addextendedproperty N'MS_Description', N'New,Close', 'SCHEMA', N'dbo', 'TABLE', N'CDM_TransferEventErrorLog', 'COLUMN', N'Status'
GO
