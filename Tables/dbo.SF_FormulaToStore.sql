CREATE TABLE [dbo].[SF_FormulaToStore]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[StoreID] [int] NOT NULL,
[ForecastID] [int] NOT NULL,
[EditorID] [int] NOT NULL,
[LastUpdate] [datetime] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SF_FormulaToStore] ADD CONSTRAINT [PK_SF_ForecastToFormula] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SF_FormulaToStore] ADD CONSTRAINT [FK_SF_ForecastToFormula_SF_Forecast] FOREIGN KEY ([ForecastID]) REFERENCES [dbo].[SF_Forecast] ([ID])
GO
