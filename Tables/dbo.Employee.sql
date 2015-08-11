CREATE TABLE [dbo].[Employee]
(
[StoreID] [int] NOT NULL,
[ID] [int] NOT NULL,
[FirstName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PayrollID] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SSN] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DOE] [datetime] NULL,
[Address1] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address2] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[State] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ZipCode] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Phone] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EmergencyContact] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EmergencyNumber] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HasPayrollReport] [bit] NOT NULL,
[EmployeeLastUpdate] [datetime] NULL,
[JobStatus] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MaritalStatus] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Gender] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BirthDate] [datetime] NULL,
[IsTerminated] [bit] NOT NULL,
[TerminatedReason] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TerminationDate] [datetime] NULL,
[Explanation] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DriversLicenseExpDate] [datetime] NULL,
[InsuranceExpDate] [datetime] NULL,
[Status] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsShowTipInTime] [bit] NOT NULL CONSTRAINT [DF_Employee_IsShowTipInTime] DEFAULT ((1)),
[LastUpdate] [datetime] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Employee] ADD CONSTRAINT [PK_Employee] PRIMARY KEY CLUSTERED  ([StoreID], [ID]) ON [PRIMARY]
GO
