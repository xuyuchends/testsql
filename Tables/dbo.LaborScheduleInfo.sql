CREATE TABLE [dbo].[LaborScheduleInfo]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[ScheduleID] [int] NOT NULL,
[Comments] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Weekly] [datetime] NOT NULL,
[IsPublic] [int] NOT NULL,
[StoreId] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LaborScheduleInfo] ADD CONSTRAINT [PK_LaborScheduleInfo] PRIMARY KEY CLUSTERED  ([ScheduleID], [Weekly], [StoreId]) ON [PRIMARY]
GO
