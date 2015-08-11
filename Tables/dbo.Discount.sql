CREATE TABLE [dbo].[Discount]
(
[StoreID] [int] NOT NULL,
[ID] [int] NOT NULL,
[Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LastUpdate] [datetime] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Discount] ADD CONSTRAINT [PK_Discount] PRIMARY KEY CLUSTERED  ([StoreID], [ID]) ON [PRIMARY]
GO
