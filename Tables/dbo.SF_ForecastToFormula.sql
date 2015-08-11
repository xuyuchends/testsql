CREATE TABLE [dbo].[SF_ForecastToFormula]
(
[StoreID] [int] NOT NULL,
[ForecastID] [int] NOT NULL,
[EditorID] [int] NOT NULL,
[EditorName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LastUpdate] [datetime] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SF_ForecastToFormula] ADD CONSTRAINT [PK_SF_ForecastToFormula_1] PRIMARY KEY CLUSTERED  ([StoreID]) ON [PRIMARY]
GO
