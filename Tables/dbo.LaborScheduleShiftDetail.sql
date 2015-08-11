CREATE TABLE [dbo].[LaborScheduleShiftDetail]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[ShiftID] [int] NOT NULL,
[BeginTime] [datetime] NOT NULL,
[EndTime] [datetime] NOT NULL,
[LunchBeginTime] [datetime] NULL,
[LunchEndTime] [datetime] NULL,
[DinnerBeginTime] [datetime] NULL,
[DinnerEndTime] [datetime] NULL,
[Description] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ColorName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Status] [int] NOT NULL,
[AttendanceID] [int] NOT NULL,
[IsGiveUp] [int] NOT NULL CONSTRAINT [DF_LaborScheduleShiftDetail_IsGiveUp] DEFAULT ((0)),
[GiveUpFrom] [int] NOT NULL CONSTRAINT [DF_LaborScheduleShiftDetail_GiveUpFrom] DEFAULT ((0)),
[GiveUpStatus] [int] NOT NULL CONSTRAINT [DF_LaborScheduleShiftDetail_GiveUpStatus] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LaborScheduleShiftDetail] ADD CONSTRAINT [PK_LaborScheduleShiftDetail] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
