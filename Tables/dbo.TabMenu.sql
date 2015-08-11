CREATE TABLE [dbo].[TabMenu]
(
[ID] [int] NOT NULL,
[Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[parentID] [int] NOT NULL,
[PathLevel] [int] NOT NULL,
[Path] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Sort] [int] NOT NULL CONSTRAINT [DF_TabMenu_Sort] DEFAULT ((0)),
[UserType] [int] NOT NULL,
[Css] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Enable] [bit] NOT NULL CONSTRAINT [DF_TabMenu_Enable] DEFAULT ((1))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TabMenu] ADD CONSTRAINT [PK_TabMenu] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'enterprise&all store =1,
enterprise&one store =2,
storeManager=4,
storeUser=8
', 'SCHEMA', N'dbo', 'TABLE', N'TabMenu', 'COLUMN', N'UserType'
GO
