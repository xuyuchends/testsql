CREATE TABLE [dbo].[CDM_Transfer_tblTAXES_CONDITIONAL]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[con_tax_id] [int] NOT NULL,
[con_desc] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[con_type] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[con_primary_tax_id] [int] NOT NULL,
[con_quantity] [int] NULL,
[con_check_total] [money] NULL,
[con_category] [nvarchar] (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[con_success_tax_id] [int] NULL,
[con_fail_tax_id] [int] NULL,
[con_lastupdate] [datetime] NULL,
[con_deleted] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[EditorID] [int] NULL,
[EditorName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GUID] [uniqueidentifier] NOT NULL,
[TransferState] [int] NOT NULL CONSTRAINT [DF_CDM_tblTAXES_CONDITIONAL_Transfer_TransferState] DEFAULT ((1))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CDM_Transfer_tblTAXES_CONDITIONAL] ADD CONSTRAINT [PK_CDM_tblTAXES_CONDITIONAL_Transfer] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
