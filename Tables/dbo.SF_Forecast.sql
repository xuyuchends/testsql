CREATE TABLE [dbo].[SF_Forecast]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Name] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[IsDefault] [bit] NOT NULL,
[EditorID] [int] NOT NULL,
[EditorName] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LastUpdate] [datetime] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SF_Forecast] ADD CONSTRAINT [PK_SF_SalesForecast] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
