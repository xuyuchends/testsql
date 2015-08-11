CREATE TABLE [dbo].[OrganizationToUser]
(
[OrganizationID] [int] NOT NULL,
[UserID] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[OrganizationToUser] ADD CONSTRAINT [PK_OrganizationToEmployee] PRIMARY KEY CLUSTERED  ([OrganizationID], [UserID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[OrganizationToUser] ADD CONSTRAINT [FK_OrganizationToEmployee_Organization] FOREIGN KEY ([OrganizationID]) REFERENCES [dbo].[Organization] ([ID])
GO
ALTER TABLE [dbo].[OrganizationToUser] ADD CONSTRAINT [FK_OrganizationToEmployee_EnterpriseEmplyee] FOREIGN KEY ([UserID]) REFERENCES [dbo].[EnterpriseUser] ([ID])
GO
