CREATE TABLE [dbo].[Group]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CanDelete] [bit] NOT NULL,
[UserID] [int] NULL,
[LastUpdate] [datetime] NULL,
[RoleType] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Group] ADD CONSTRAINT [PK_Group] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'1=enterprise,2=storemanager,3=storeuser', 'SCHEMA', N'dbo', 'TABLE', N'Group', 'COLUMN', N'RoleType'
GO
