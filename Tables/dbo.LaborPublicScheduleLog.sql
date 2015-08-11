CREATE TABLE [dbo].[LaborPublicScheduleLog]
(
[ID] [int] NOT NULL,
[UpdateTime] [datetime] NOT NULL,
[Event] [int] NOT NULL,
[EmpID] [int] NOT NULL,
[ScheduleID] [int] NOT NULL,
[WeekOf] [datetime] NOT NULL
) ON [PRIMARY]
GO
