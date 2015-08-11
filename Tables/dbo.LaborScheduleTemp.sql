CREATE TABLE [dbo].[LaborScheduleTemp]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[ScheduleID] [int] NOT NULL,
[Name] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Weekly] [datetime] NOT NULL,
[StoreID] [int] NOT NULL,
[UpdateTime] [datetime] NOT NULL,
[Description] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LaborScheduleTemp] ADD CONSTRAINT [PK_LaborScheduleTemp] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
