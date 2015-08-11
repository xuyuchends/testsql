CREATE TABLE [dbo].[CDM_tblPRINT_ZONES]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[PZID] [int] NULL,
[PrintZone_Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PrintZone_Path] [nvarchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PrintZone_Status] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PrinterType] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Default_Delay_Time] [int] NULL,
[Priority_Delay_Time] [int] NULL CONSTRAINT [DF_CDM_tblPRINT_ZONES_Priority_Delay_Time] DEFAULT ((0)),
[Prompt_Printer] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_CDM_tblPRINT_ZONES_Prompt_Printer] DEFAULT ('N'),
[Auto_Redirect_Offline] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_CDM_tblPRINT_ZONES_Auto_Redirect_Offline] DEFAULT ('N'),
[backup_printer] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_CDM_tblPRINT_ZONES_backup_printer] DEFAULT (N'NOT USED'),
[backup_printer_path] [nvarchar] (512) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_CDM_tblPRINT_ZONES_backup_printer_path] DEFAULT (N'NOT USED')
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CDM_tblPRINT_ZONES] ADD CONSTRAINT [PK_CDM_tblPRINT_ZONES] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'', 'SCHEMA', N'dbo', 'TABLE', N'CDM_tblPRINT_ZONES', 'COLUMN', N'backup_printer_path'
GO
