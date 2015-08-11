CREATE TABLE [dbo].[Inv_TenderType]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Name] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[IsActive] [bit] NOT NULL,
[lastUpdate] [datetime] NOT NULL,
[Creator] [int] NOT NULL,
[Editor] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Inv_TenderType] ADD CONSTRAINT [PK_Inventory_TenderType] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
