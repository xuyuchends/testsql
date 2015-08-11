CREATE TABLE [dbo].[Function]
(
[ID] [int] NOT NULL,
[Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ParnetID] [int] NOT NULL,
[PathLevel] [int] NOT NULL,
[Path] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TabMenuID] [int] NOT NULL,
[Enable] [bit] NOT NULL,
[Sort] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Function] ADD CONSTRAINT [PK_function] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
