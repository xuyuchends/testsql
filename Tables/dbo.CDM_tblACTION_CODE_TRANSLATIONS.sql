CREATE TABLE [dbo].[CDM_tblACTION_CODE_TRANSLATIONS]
(
[ID] [bigint] NOT NULL,
[Action_Code] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Special_Process] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Security_FieldID] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Security_Module] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Link] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[English_Translation] [nvarchar] (256) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
