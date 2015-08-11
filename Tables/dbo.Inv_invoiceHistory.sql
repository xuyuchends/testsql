CREATE TABLE [dbo].[Inv_invoiceHistory]
(
[ID] [bigint] NOT NULL IDENTITY(1, 1),
[InvoiceID] [int] NULL,
[Discount] [decimal] (18, 2) NULL,
[SubTotal] [decimal] (18, 2) NULL,
[Shipping] [decimal] (18, 2) NULL,
[Tax] [decimal] (18, 2) NULL,
[CheckNum] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Status] [int] NULL,
[PaidDate] [datetime] NULL,
[CreationDate] [datetime] NULL,
[UserID] [int] NULL,
[UserName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Num] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastUpdate] [datetime] NULL,
[PaidTotal] [decimal] (18, 2) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Inv_invoiceHistory] ADD CONSTRAINT [PK_Inv_invoiceHistory] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
