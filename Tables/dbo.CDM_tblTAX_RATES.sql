CREATE TABLE [dbo].[CDM_tblTAX_RATES]
(
[tax_id] [int] NOT NULL IDENTITY(1, 1),
[tax_name] [nvarchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[tax_rate] [decimal] (18, 4) NOT NULL,
[tax_min_amt] [money] NOT NULL,
[tax_type] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[tax_lastupdate] [datetime] NULL,
[tax_make_exclusive] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_CDM_tblTAX_RATES_tax_make_exclusive] DEFAULT ('N'),
[tax_make_tax_id] [int] NOT NULL CONSTRAINT [DF_CDM_tblTAX_RATES_tax_make_tax_id] DEFAULT ((0)),
[tax_deleted] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_CDM_tblTAX_RATES_tax_deleted] DEFAULT ('N'),
[last_update] [datetime] NULL CONSTRAINT [DF_CDM_tblTAX_RATES_last_update] DEFAULT (getdate()),
[EditorID] [int] NULL,
[EditorName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CDM_tblTAX_RATES] ADD CONSTRAINT [PK_CDM_tblTAX_RATES] PRIMARY KEY CLUSTERED  ([tax_id]) ON [PRIMARY]
GO
