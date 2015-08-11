CREATE TABLE [dbo].[Inv_Order]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[StoreID] [int] NOT NULL,
[VendorID] [int] NOT NULL,
[PONum] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OrderStatus] [int] NOT NULL,
[PostDate] [datetime] NULL,
[CreationDate] [datetime] NULL,
[EstDeliveryDate] [datetime] NULL,
[SubTotal] [decimal] (18, 2) NULL,
[Note] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastUpdate] [datetime] NULL,
[CreatedID] [int] NOT NULL,
[CreatedName] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[EditorID] [int] NULL,
[EditorName] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[Inv_Order] ADD CONSTRAINT [PK_Inv_Order] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Inv_Order] ADD CONSTRAINT [FK_Inv_Order_Inv_Vendor] FOREIGN KEY ([VendorID]) REFERENCES [dbo].[Inv_Vendor] ([ID])
GO
