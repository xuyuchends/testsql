CREATE TABLE [dbo].[LaborAvailabilityInfo]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[EmpID] [int] NOT NULL,
[Audit] [int] NOT NULL,
[ManagerNotes] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LaborAvailabilityInfo] ADD CONSTRAINT [PK_LaborAvailabilityInfo] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
