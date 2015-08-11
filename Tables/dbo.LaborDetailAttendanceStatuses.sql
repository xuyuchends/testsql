CREATE TABLE [dbo].[LaborDetailAttendanceStatuses]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[AttendanceStatusesID] [int] NOT NULL,
[DetailID] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LaborDetailAttendanceStatuses] ADD CONSTRAINT [PK_LaborDetailAttendanceStatuses] PRIMARY KEY CLUSTERED  ([DetailID]) ON [PRIMARY]
GO
