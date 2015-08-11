CREATE TABLE [dbo].[ManagerLogDetailHeader]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[ManagerLogID] [int] NOT NULL,
[UserID] [int] NOT NULL,
[StoreID] [int] NULL,
[LogDate] [datetime] NULL,
[UpdateDate] [datetime] NULL CONSTRAINT [DF_ManagerLogDetailHeader_UpdateDate] DEFAULT (getdate())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ManagerLogDetailHeader] ADD CONSTRAINT [PK_ManagerLogDetailHeader] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ManagerLogDetailHeader] ADD CONSTRAINT [managerLog_fk] FOREIGN KEY ([ManagerLogID]) REFERENCES [dbo].[ManagerLog] ([ID])
GO
