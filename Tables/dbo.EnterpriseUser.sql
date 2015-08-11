CREATE TABLE [dbo].[EnterpriseUser]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[StoreID] [int] NOT NULL,
[EmployeeID] [int] NULL,
[FirstName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LastName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[IsManager] [bit] NULL,
[Email] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[HomePhone] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MobilePhone] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MobileCarrier] [int] NULL CONSTRAINT [DF_EnterpriseUser_MobileCarrier] DEFAULT ((1)),
[Address] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressCont] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[State] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Zip] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SendEmailWhen] [int] NOT NULL CONSTRAINT [DF_EnterpriseUser_SendEmailWhen] DEFAULT ((0)),
[SendMessageWhen] [int] NOT NULL CONSTRAINT [DF_EnterpriseUser_SendMessageWhen] DEFAULT ((0)),
[UserName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Password] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CS_AS NOT NULL,
[LoginCount] [int] NOT NULL CONSTRAINT [DF_EnterpriseUser_LoginCount] DEFAULT ((0)),
[IsTerminated] [bit] NULL,
[Enable] [bit] NOT NULL,
[FromFOH] [int] NULL CONSTRAINT [DF__Enterpris__FromF__1F846F7F] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EnterpriseUser] ADD CONSTRAINT [PK_EnterpriseEmplyee] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
EXEC sp_addextendedproperty N'MS_Description', N'员工表', 'SCHEMA', N'dbo', 'TABLE', N'EnterpriseUser', 'COLUMN', N'ID'
GO
