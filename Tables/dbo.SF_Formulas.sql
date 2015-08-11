CREATE TABLE [dbo].[SF_Formulas]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[ForecastID] [int] NOT NULL,
[Percentage] [decimal] (18, 2) NOT NULL,
[Quantity] [int] NOT NULL,
[Unit] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[EditorID] [int] NOT NULL,
[LastUpdate] [datetime] NOT NULL,
[EditorName] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SF_Formulas] ADD CONSTRAINT [PK_SF_SalesForecastFormulas] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SF_Formulas] ADD CONSTRAINT [FK_SF_SalesForecastFormulas_SF_SalesForecast] FOREIGN KEY ([ForecastID]) REFERENCES [dbo].[SF_Forecast] ([ID])
GO
