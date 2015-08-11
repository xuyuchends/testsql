CREATE TABLE [dbo].[MealPeriod]
(
[StoreID] [int] NOT NULL,
[ID] [int] NOT NULL IDENTITY(1, 1),
[Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[BeginTime] [datetime] NULL,
[EndTime] [datetime] NULL,
[DayOfWeek] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Sequence] [int] NULL,
[LastUpdate] [datetime] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[MealPeriod] ADD CONSTRAINT [PK_MealPeriod] PRIMARY KEY CLUSTERED  ([StoreID], [ID]) ON [PRIMARY]
GO
