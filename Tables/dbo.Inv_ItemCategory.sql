CREATE TABLE [dbo].[Inv_ItemCategory]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Name] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ParentID] [int] NOT NULL,
[GroupID] [int] NOT NULL,
[GLAccount] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DisplaySeq] [int] NOT NULL,
[IsActive] [bit] NOT NULL,
[LastUpdate] [datetime] NOT NULL,
[Creator] [int] NOT NULL,
[Editor] [int] NULL,
[Layer] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Inv_ItemCategory] ADD CONSTRAINT [PK_Inv_ItemCategory] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Inv_ItemCategory] ADD CONSTRAINT [FK_Inv_ItemCategory_Inv_ItemGroup] FOREIGN KEY ([GroupID]) REFERENCES [dbo].[Inv_ItemGroup] ([ID])
GO
