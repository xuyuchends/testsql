CREATE TABLE [dbo].[CDM_Transfer_HotItem]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[HotItem] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[EditorID] [int] NULL,
[EditorName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GUID] [uniqueidentifier] NOT NULL,
[TransferState] [int] NOT NULL CONSTRAINT [DF_CDM_Transfer_HotItem_TransferState] DEFAULT ((1))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CDM_Transfer_HotItem] ADD CONSTRAINT [PK_CDM_Transfer_HotItem] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
