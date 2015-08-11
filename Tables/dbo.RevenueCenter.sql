CREATE TABLE [dbo].[RevenueCenter]
(
[StoreID] [int] NOT NULL,
[ID] [int] NOT NULL,
[Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LastUpdate] [datetime] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[RevenueCenter] ADD CONSTRAINT [PK_RevenueCenter] PRIMARY KEY CLUSTERED  ([StoreID], [ID]) ON [PRIMARY]
GO
