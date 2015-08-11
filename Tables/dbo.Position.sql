CREATE TABLE [dbo].[Position]
(
[ID] [int] NOT NULL,
[StoreID] [int] NOT NULL,
[Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[AllowShiftTrades] [bit] NULL,
[ManagerApprovalforTrades] [bit] NULL,
[View/PrintAllSchedules] [bit] NULL,
[Status] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastUpdate] [datetime] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Position] ADD CONSTRAINT [PK_Position] PRIMARY KEY CLUSTERED  ([ID], [StoreID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Position] ADD CONSTRAINT [IX_Name] UNIQUE NONCLUSTERED  ([Name], [ID], [StoreID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Position] ADD CONSTRAINT [FK_Position_Position] FOREIGN KEY ([ID], [StoreID]) REFERENCES [dbo].[Position] ([ID], [StoreID])
GO
