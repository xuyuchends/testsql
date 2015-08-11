CREATE TABLE [dbo].[SF_FormulaData]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[StoreID] [int] NOT NULL,
[DayPart] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ForecastsDate] [datetime] NOT NULL,
[ForecastValue] [decimal] (18, 2) NOT NULL,
[ModifyValue] [decimal] (18, 2) NULL,
[EditorID] [int] NOT NULL,
[LastUpdate] [datetime] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SF_FormulaData] ADD CONSTRAINT [PK_SF_FormulaData] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
