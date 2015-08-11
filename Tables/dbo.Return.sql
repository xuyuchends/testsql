CREATE TABLE [dbo].[Return]
(
[StoreID] [int] NOT NULL,
[ID] [int] NOT NULL,
[Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastUpdate] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Return] ADD CONSTRAINT [PK_Return] PRIMARY KEY CLUSTERED  ([StoreID], [ID]) ON [PRIMARY]
GO
