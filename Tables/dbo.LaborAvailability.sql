CREATE TABLE [dbo].[LaborAvailability]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[StoreID] [int] NOT NULL,
[EmpID] [int] NOT NULL,
[StartTime] [datetime] NOT NULL,
[EndTime] [datetime] NOT NULL,
[Audit] [int] NOT NULL,
[Comments] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ManagerNode] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LaborAvailability] ADD CONSTRAINT [PK_tbl_Availability] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
