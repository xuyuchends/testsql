CREATE TABLE [dbo].[LaborSchedule]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[ScheduleName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Status] [int] NOT NULL,
[Postions] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[IsPublic] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LaborSchedule] ADD CONSTRAINT [PK_LaborSchedule] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
