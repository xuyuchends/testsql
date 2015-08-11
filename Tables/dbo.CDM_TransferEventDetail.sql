CREATE TABLE [dbo].[CDM_TransferEventDetail]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[EventID] [int] NOT NULL,
[StoreID] [int] NOT NULL,
[BeginTime] [datetime] NULL,
[EndTime] [datetime] NULL,
[Status] [int] NOT NULL,
[LastUpdate] [datetime] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CDM_TransferEventDetail] ADD CONSTRAINT [PK_CDMTransferEventDetail_1] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CDM_TransferEventDetail] ADD CONSTRAINT [FK_CDMTransferEventDetail_CDMTransferEvent] FOREIGN KEY ([EventID]) REFERENCES [dbo].[CDM_TransferEvent] ([ID])
GO
