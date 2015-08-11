CREATE TABLE [dbo].[CDM_Transfer_tblTAX_RATES]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[tax_id] [int] NOT NULL,
[tax_name] [nvarchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[tax_rate] [decimal] (18, 4) NOT NULL,
[tax_min_amt] [money] NOT NULL,
[tax_type] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[tax_lastupdate] [datetime] NULL,
[tax_make_exclusive] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[tax_make_tax_id] [int] NOT NULL,
[tax_deleted] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[last_update] [datetime] NULL,
[EditorID] [int] NULL,
[EditorName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[GUID] [uniqueidentifier] NOT NULL,
[TransferState] [int] NOT NULL CONSTRAINT [DF_CDM_tblTAX_RATES_Transfer_TransferState] DEFAULT ((1))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CDM_Transfer_tblTAX_RATES] ADD CONSTRAINT [PK_CDM_tblTAX_RATES_Transfer] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
