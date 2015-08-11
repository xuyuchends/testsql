CREATE TABLE [dbo].[Inv_Check]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[InvoiceNum] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Type] [int] NOT NULL,
[CheckNum] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[VendorID] [int] NOT NULL,
[Amount] [decimal] (18, 2) NULL,
[Comment] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CreationDate] [datetime] NOT NULL,
[LastUpdate] [datetime] NOT NULL,
[Creator] [int] NOT NULL,
[Editor] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[Inv_Check] ADD CONSTRAINT [PK_Inv_Check] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Inv_Check] ADD CONSTRAINT [FK_Inv_Check_Inv_Vendor] FOREIGN KEY ([VendorID]) REFERENCES [dbo].[Inv_Vendor] ([ID])
GO
