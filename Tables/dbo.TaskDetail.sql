CREATE TABLE [dbo].[TaskDetail]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[TaskID] [int] NOT NULL,
[Status] [int] NOT NULL,
[Description] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ResolveUserID] [int] NULL,
[ResolveTime] [datetime] NOT NULL,
[AssignedStoreID] [int] NULL,
[Enable] [bit] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[TaskDetail] ADD CONSTRAINT [PK_TaskDetail] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TaskDetail] ADD CONSTRAINT [FK_TaskDetail_EnterpriseEmplyee] FOREIGN KEY ([ResolveUserID]) REFERENCES [dbo].[EnterpriseUser] ([ID])
GO
ALTER TABLE [dbo].[TaskDetail] ADD CONSTRAINT [FK_TaskDetail_Task1] FOREIGN KEY ([TaskID]) REFERENCES [dbo].[Task] ([ID])
GO
EXEC sp_addextendedproperty N'MS_Description', N'内容', 'SCHEMA', N'dbo', 'TABLE', N'TaskDetail', 'COLUMN', N'Description'
GO
EXEC sp_addextendedproperty N'MS_Description', N'主键,任务明细', 'SCHEMA', N'dbo', 'TABLE', N'TaskDetail', 'COLUMN', N'ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'指派的员工', 'SCHEMA', N'dbo', 'TABLE', N'TaskDetail', 'COLUMN', N'ResolveUserID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'状态', 'SCHEMA', N'dbo', 'TABLE', N'TaskDetail', 'COLUMN', N'Status'
GO
EXEC sp_addextendedproperty N'MS_Description', N'任务表ID', 'SCHEMA', N'dbo', 'TABLE', N'TaskDetail', 'COLUMN', N'TaskID'
GO
