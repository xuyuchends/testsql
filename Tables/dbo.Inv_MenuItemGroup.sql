CREATE TABLE [dbo].[Inv_MenuItemGroup]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Name] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[IsActive] [bit] NOT NULL,
[LastUpdate] [datetime] NOT NULL,
[Creator] [int] NOT NULL,
[Editor] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Inv_MenuItemGroup] ADD CONSTRAINT [PK_Inv_MenuItemGroup] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
