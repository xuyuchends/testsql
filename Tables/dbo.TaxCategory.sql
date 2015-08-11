CREATE TABLE [dbo].[TaxCategory]
(
[StoreID] [int] NOT NULL,
[ID] [int] NOT NULL,
[Category] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Rate] [decimal] (18, 4) NULL,
[IsInclusive] [bit] NULL,
[LastUpdate] [datetime] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TaxCategory] ADD CONSTRAINT [CK_TaxCategory] CHECK (([category]='tax' OR [category]='sur'))
GO
ALTER TABLE [dbo].[TaxCategory] ADD CONSTRAINT [PK_TaxCategory] PRIMARY KEY CLUSTERED  ([StoreID], [ID], [Category]) ON [PRIMARY]
GO
