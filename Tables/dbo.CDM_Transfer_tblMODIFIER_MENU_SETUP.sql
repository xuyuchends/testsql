CREATE TABLE [dbo].[CDM_Transfer_tblMODIFIER_MENU_SETUP]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[ModifierMenuID] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Language_1_Name] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Language_2_Name] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Language_3_Name] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Language_4_Name] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Language_5_Name] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ForceModifier] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ModifierMenuType] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Limit_Num_Allowed] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ShortCut_Menu] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ModifierMenuCategory] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[last_update] [datetime] NULL,
[Num_Free] [int] NULL,
[ModFilename] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CDMOperate] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EditorID] [int] NULL,
[EditorName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GUID] [uniqueidentifier] NOT NULL,
[TransferState] [int] NOT NULL CONSTRAINT [DF_CDM_Transfer_tblMODIFIER_MENU_SETUP_TransferState] DEFAULT ((1))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CDM_Transfer_tblMODIFIER_MENU_SETUP] ADD CONSTRAINT [PK_CDM_Transfer_tblMODIFIER_MENU_SETUP] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of Modifiers Free', 'SCHEMA', N'dbo', 'TABLE', N'CDM_Transfer_tblMODIFIER_MENU_SETUP', 'COLUMN', N'Num_Free'
GO
