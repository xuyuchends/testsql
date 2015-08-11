CREATE TABLE [dbo].[AttendanceStatuses]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AttendanceStatuses] ADD CONSTRAINT [PK_AttendanceStatuses] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
