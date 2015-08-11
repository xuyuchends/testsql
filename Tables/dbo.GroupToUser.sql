CREATE TABLE [dbo].[GroupToUser]
(
[GroupID] [int] NOT NULL,
[UserID] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[GroupToUser] ADD CONSTRAINT [PK_GroupToUser] PRIMARY KEY CLUSTERED  ([GroupID], [UserID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[GroupToUser] ADD CONSTRAINT [FK_GroupToUser_Group] FOREIGN KEY ([GroupID]) REFERENCES [dbo].[Group] ([ID])
GO
ALTER TABLE [dbo].[GroupToUser] ADD CONSTRAINT [FK_GroupToUser_EnterpriseUser] FOREIGN KEY ([UserID]) REFERENCES [dbo].[EnterpriseUser] ([ID])
GO
