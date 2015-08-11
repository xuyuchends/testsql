CREATE TABLE [dbo].[QB_AdjustmentCategory]
(
[ID] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Name] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Type] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[QB_AdjustmentCategory] ADD CONSTRAINT [PK_QB_AdjustmentCategory_1] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
