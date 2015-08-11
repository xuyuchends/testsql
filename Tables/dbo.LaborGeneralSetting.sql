CREATE TABLE [dbo].[LaborGeneralSetting]
(
[WorkWeekOvertime] [int] NOT NULL,
[WorkDayOvertime] [int] NOT NULL,
[PublishUnassignedShifts] [bit] NOT NULL,
[AllowOnCallShifts] [bit] NOT NULL,
[CaliforniaLaborLaws] [bit] NOT NULL
) ON [PRIMARY]
GO
