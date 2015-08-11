CREATE TABLE [dbo].[Organization]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[StoreID] [int] NULL,
[ParentID] [int] NULL,
[Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Organization] ADD CONSTRAINT [PK_StoreOrganization] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'组织权限表', 'SCHEMA', N'dbo', 'TABLE', N'Organization', 'COLUMN', N'ID'
GO
