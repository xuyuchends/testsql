CREATE TABLE [dbo].[QB_Profile]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[UserName] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Password] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[QB_Profile] ADD CONSTRAINT [PK_QB_Profile] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[QB_Profile] ADD CONSTRAINT [IX_QB_Profile] UNIQUE NONCLUSTERED  ([UserName]) ON [PRIMARY]
GO
