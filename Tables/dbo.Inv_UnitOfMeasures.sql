CREATE TABLE [dbo].[Inv_UnitOfMeasures]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Creator] [int] NULL,
[Editor] [int] NULL,
[LastUpdate] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Inv_UnitOfMeasures] ADD CONSTRAINT [PK_Inv_UnitOfMeasures] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
