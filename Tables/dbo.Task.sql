CREATE TABLE [dbo].[Task]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Subject] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[DueDate] [datetime] NOT NULL,
[Description] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Priority] [int] NULL CONSTRAINT [DF_Task_Priority] DEFAULT ((1)),
[Status] [int] NULL CONSTRAINT [DF_Task_Status] DEFAULT ((1)),
[AssignedTo] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UpdateUserID] [int] NOT NULL,
[StoreID] [int] NULL,
[UpdateTime] [datetime] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[Task] ADD CONSTRAINT [PK_Task] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Task] ADD CONSTRAINT [FK_Task_EnterpriseEmplyee] FOREIGN KEY ([UpdateUserID]) REFERENCES [dbo].[EnterpriseUser] ([ID])
GO
EXEC sp_addextendedproperty N'MS_Description', N'内容', 'SCHEMA', N'dbo', 'TABLE', N'Task', 'COLUMN', N'Description'
GO
EXEC sp_addextendedproperty N'MS_Description', N'到期时间', 'SCHEMA', N'dbo', 'TABLE', N'Task', 'COLUMN', N'DueDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'主键,任务表', 'SCHEMA', N'dbo', 'TABLE', N'Task', 'COLUMN', N'ID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'优先级', 'SCHEMA', N'dbo', 'TABLE', N'Task', 'COLUMN', N'Priority'
GO
EXEC sp_addextendedproperty N'MS_Description', N'状态', 'SCHEMA', N'dbo', 'TABLE', N'Task', 'COLUMN', N'Status'
GO
EXEC sp_addextendedproperty N'MS_Description', N'主题', 'SCHEMA', N'dbo', 'TABLE', N'Task', 'COLUMN', N'Subject'
GO
EXEC sp_addextendedproperty N'MS_Description', N'更新时间', 'SCHEMA', N'dbo', 'TABLE', N'Task', 'COLUMN', N'UpdateTime'
GO
EXEC sp_addextendedproperty N'MS_Description', N'更新者', 'SCHEMA', N'dbo', 'TABLE', N'Task', 'COLUMN', N'UpdateUserID'
GO
