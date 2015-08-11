CREATE TABLE [dbo].[DocumentCateogry]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DocumentCateogry] ADD CONSTRAINT [PK_DocumentCateogry] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DocumentCateogry] ADD CONSTRAINT [IX_DocumentCateogry] UNIQUE NONCLUSTERED  ([ID], [Name]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'主键,文档类别表', 'SCHEMA', N'dbo', 'TABLE', N'DocumentCateogry', 'COLUMN', N'ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'类别名称', 'SCHEMA', N'dbo', 'TABLE', N'DocumentCateogry', 'COLUMN', N'Name'
GO
