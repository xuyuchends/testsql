CREATE TABLE [dbo].[LaborTimeOff]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[StartTime] [datetime] NOT NULL,
[EndTime] [datetime] NOT NULL,
[Status] [int] NOT NULL,
[Comments] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ApplicantID] [int] NOT NULL,
[ApprovedBy] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ApprovedTime] [datetime] NULL,
[RequestTime] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LaborTimeOff] ADD CONSTRAINT [PK_LaborTimeOff] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
