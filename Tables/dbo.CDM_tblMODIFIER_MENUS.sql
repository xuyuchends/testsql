CREATE TABLE [dbo].[CDM_tblMODIFIER_MENUS]
(
[ModifierMenuID] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MenuItemID] [nchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Display_Sequence] [smallint] NULL,
[ModifierPrice] [money] NOT NULL CONSTRAINT [DF_CDM_tblMODIFIER_MENUS_Price] DEFAULT ((0)),
[UseModifierPrice] [bit] NOT NULL CONSTRAINT [DF_CDM_tblMODIFIER_MENUS_UseModifierPrice] DEFAULT ((0)),
[PriceLevel] [smallint] NOT NULL CONSTRAINT [DF_CDM_tblMODIFIER_MENUS_PriceLevel] DEFAULT ((0)),
[EditorID] [int] NULL,
[EditorName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CDM_tblMODIFIER_MENUS] ADD CONSTRAINT [PK_tblMODIFIER_LINKS] PRIMARY KEY CLUSTERED  ([ModifierMenuID], [MenuItemID]) ON [PRIMARY]
GO
