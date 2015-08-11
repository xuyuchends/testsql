CREATE TABLE [dbo].[ReportAlert]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[AlertName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TriggerBelowValues] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TriggerAboveValues] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StartDate] [datetime] NOT NULL,
[EndDate] [datetime] NULL,
[AlertFrequency] [int] NOT NULL,
[SendtoStore] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LastSendDate] [datetime] NULL,
[UserID] [int] NULL,
[CreateDate] [datetime] NULL,
[Sendto] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[ReportAlert] ADD CONSTRAINT [PK_ReportAlert] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
