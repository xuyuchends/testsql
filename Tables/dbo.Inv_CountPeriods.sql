CREATE TABLE [dbo].[Inv_CountPeriods]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Name] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Period] [int] NOT NULL,
[DayofWeek] [int] NOT NULL,
[LastUpdate] [datetime] NULL,
[Creator] [int] NOT NULL,
[Editor] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Inv_CountPeriods] ADD CONSTRAINT [PK_Inv_CountPeriods] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
