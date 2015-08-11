CREATE TABLE [dbo].[Inv_Location]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ParentID] [int] NOT NULL,
[StoreID] [int] NOT NULL,
[DisplaySeq] [int] NOT NULL,
[LastUpdate] [datetime] NOT NULL,
[Creator] [int] NOT NULL,
[Editor] [int] NULL,
[Layer] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Inv_Location] ADD CONSTRAINT [PK_Inv_Location] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
