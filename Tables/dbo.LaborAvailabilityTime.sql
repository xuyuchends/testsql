CREATE TABLE [dbo].[LaborAvailabilityTime]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[WeekDays] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TimeScale] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[AvailabilityID] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LaborAvailabilityTime] ADD CONSTRAINT [PK_tbl_AvailabilityTime] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
