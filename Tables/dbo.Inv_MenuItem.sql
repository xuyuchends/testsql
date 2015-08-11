CREATE TABLE [dbo].[Inv_MenuItem]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Name] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Price] [decimal] (18, 2) NULL,
[RefNumber] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CategoryID] [int] NOT NULL,
[IsEntree] [bit] NOT NULL,
[IsModifier] [bit] NOT NULL,
[IsActive] [bit] NOT NULL,
[Recipe] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FromPOS] [bit] NOT NULL,
[LastUpdate] [datetime] NOT NULL,
[Creator] [int] NOT NULL,
[Editor] [int] NULL,
[DoubleItemID] [int] NULL,
[isDouble] [bit] NOT NULL CONSTRAINT [DF__Inv_MenuI__isDou__0C719B0B] DEFAULT ((0))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[Inv_MenuItem] ADD CONSTRAINT [PK_Inv_MenuItem] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Inv_MenuItem] ADD CONSTRAINT [FK_Inv_MenuItem_Inv_MenuItemCategory] FOREIGN KEY ([CategoryID]) REFERENCES [dbo].[Inv_MenuItemCategory] ([ID])
GO
