CREATE TABLE [dbo].[CDM_TransferEvent]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[EditorID] [int] NOT NULL,
[EditorName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CreateTime] [datetime] NOT NULL,
[LastUpdate] [datetime] NOT NULL,
[StoreIDs] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BeginTime] [datetime] NULL,
[EndTime] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[CDM_TransferEvent] ADD CONSTRAINT [PK_CDMTransferEvent] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
