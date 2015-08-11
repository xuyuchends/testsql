CREATE TABLE [dbo].[PaidIn]
(
[StoreID] [int] NOT NULL,
[ID] [int] NOT NULL,
[Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LastUpdate] [datetime] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PaidIn] ADD CONSTRAINT [PK_PaidIn] PRIMARY KEY CLUSTERED  ([StoreID], [ID]) ON [PRIMARY]
GO
