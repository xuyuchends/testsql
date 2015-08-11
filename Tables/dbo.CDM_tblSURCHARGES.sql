CREATE TABLE [dbo].[CDM_tblSURCHARGES]
(
[sur_id] [bigint] NOT NULL IDENTITY(1, 1),
[sur_desc] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[sur_type] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[sur_amt] [money] NULL,
[sur_percent] [decimal] (18, 4) NULL,
[sur_lastupdate] [datetime] NULL,
[sur_deleted] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_CDM_tblSURCHARGES_sur_deleted] DEFAULT ('N'),
[last_update] [datetime] NULL CONSTRAINT [DF_CDM_tblSURCHARGES_last_update] DEFAULT (getdate()),
[LastUpdate] [datetime] NULL,
[EditorID] [int] NULL,
[EditorName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CDM_tblSURCHARGES] ADD CONSTRAINT [PK_CDM_tblSURCHARGES] PRIMARY KEY CLUSTERED  ([sur_id]) ON [PRIMARY]
GO
