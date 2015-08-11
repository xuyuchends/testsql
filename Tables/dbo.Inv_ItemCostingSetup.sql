CREATE TABLE [dbo].[Inv_ItemCostingSetup]
(
[Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Value] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastUpdate] [datetime] NULL,
[Creator] [int] NOT NULL,
[Editor] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Inv_ItemCostingSetup] ADD CONSTRAINT [PK_Inv_ItemCostingSetup] PRIMARY KEY CLUSTERED  ([Name]) ON [PRIMARY]
GO
