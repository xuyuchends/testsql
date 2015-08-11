CREATE TABLE [dbo].[CDM_tblMENU_EVENTS]
(
[pk] [bigint] NOT NULL IDENTITY(1, 1),
[menu_event] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[return_value] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[use_same_as_dining] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_CDM_tblMENU_EVENTS_use_same_as_dining] DEFAULT ('N'),
[EditorID] [int] NULL,
[EditorName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastUpdate] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CDM_tblMENU_EVENTS] ADD CONSTRAINT [PK_CDM_tblMENU_EVENTS] PRIMARY KEY CLUSTERED  ([pk]) ON [PRIMARY]
GO
