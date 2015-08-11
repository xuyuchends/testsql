CREATE TABLE [dbo].[DocumentManager]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FileSize] [int] NOT NULL,
[FilePath] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[FileAlias] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CategoryID] [int] NULL,
[UserID] [int] NOT NULL,
[FileType] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[WhoCanView] [int] NULL,
[WhoCanEdit] [int] NULL,
[CanViewStoreID] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PubStoreID] [int] NULL,
[UpdateUserID] [int] NULL,
[UpdateTime] [datetime] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[DocumentManager] ADD CONSTRAINT [PK_DocumentManager] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
