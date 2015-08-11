CREATE TABLE [dbo].[DCS_DataCompareLog]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[StoreID] [int] NULL,
[CompareDate] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DCS_DataCompareLog] ADD CONSTRAINT [PK_DataCompareLog] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
