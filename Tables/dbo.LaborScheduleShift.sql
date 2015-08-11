CREATE TABLE [dbo].[LaborScheduleShift]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[ScheduleID] [int] NOT NULL,
[JobID] [int] NOT NULL,
[Weekly] [datetime] NOT NULL,
[StoreID] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LaborScheduleShift] ADD CONSTRAINT [PK_LaborScheduleShift] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
