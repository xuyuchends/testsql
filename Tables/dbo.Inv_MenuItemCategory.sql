CREATE TABLE [dbo].[Inv_MenuItemCategory]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Name] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ParentID] [int] NOT NULL,
[GroupID] [int] NOT NULL,
[DisplaySeq] [int] NOT NULL,
[IsActive] [bit] NOT NULL,
[ShowInReport] [bit] NOT NULL,
[LastUpdate] [datetime] NOT NULL,
[Creator] [int] NOT NULL,
[Editor] [int] NULL,
[Layer] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Inv_MenuItemCategory] ADD CONSTRAINT [PK_Inv_MenuItemCategory] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
