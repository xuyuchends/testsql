CREATE TABLE [dbo].[CDM_tblMENU_ITEM_ALTERNATE_PRICING]
(
[Menu_ItemID] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Effective_Day] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Effective_Begin_Time] [datetime] NOT NULL,
[Effective_End_Time] [datetime] NULL,
[Alternate_Price] [money] NULL,
[All_Day_Price] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_CDM_tblMENU_ITEM_ALTERNATE_PRICING_All_Day_Price] DEFAULT ('N')
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CDM_tblMENU_ITEM_ALTERNATE_PRICING] ADD CONSTRAINT [PK_CDM_tblMENU_ITEM_ALTERNATE_PRICING] PRIMARY KEY CLUSTERED  ([Menu_ItemID], [Effective_Day], [Effective_Begin_Time]) ON [PRIMARY]
GO
