CREATE TABLE [dbo].[CDM_tblMENU_PROFILE]
(
[pk] [bigint] NOT NULL IDENTITY(1, 1),
[menu_link] [nvarchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[dayofweek] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[beginTime] [datetime] NOT NULL,
[endtime] [datetime] NOT NULL,
[menu_event] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[EditorID] [int] NULL,
[EditorName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastUpdate] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CDM_tblMENU_PROFILE] ADD CONSTRAINT [PK_CDM_tblMENU_PROFILE] PRIMARY KEY CLUSTERED  ([pk]) ON [PRIMARY]
GO
