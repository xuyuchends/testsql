CREATE TABLE [dbo].[Inv_Vendor]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Name] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Code] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Supplier] [bit] NULL,
[TenderTypes] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Contact] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Archived] [bit] NOT NULL,
[Address] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address2] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[City] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[state] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Country] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ZipCode] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Phone] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[VendorStore] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DisplaySeq] [int] NOT NULL,
[LastUpdate] [datetime] NULL,
[Creator] [int] NOT NULL,
[Editor] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[Inv_Vendor] ADD CONSTRAINT [PK_Inventory_Vendor] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
