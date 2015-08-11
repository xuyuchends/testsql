CREATE TABLE [dbo].[EmployeeJob]
(
[StoreID] [int] NOT NULL,
[ID] [int] NOT NULL,
[EmployeeID] [int] NOT NULL,
[PositionID] [int] NOT NULL,
[Wage] [money] NULL,
[OvertimeWage] [money] NULL,
[LastUpdate] [datetime] NOT NULL,
[WageType] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OverTimeRate] [money] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EmployeeJob] ADD CONSTRAINT [PK_EmployeeJob_1] PRIMARY KEY CLUSTERED  ([StoreID], [ID]) ON [PRIMARY]
GO
