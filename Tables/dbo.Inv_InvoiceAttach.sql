CREATE TABLE [dbo].[Inv_InvoiceAttach]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[InvoiceID] [int] NOT NULL,
[FilePath] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FileType] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[FileAlias] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[FileName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Inv_InvoiceAttach] ADD CONSTRAINT [PK_Inv_InvoiceAttach] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Inv_InvoiceAttach] ADD CONSTRAINT [FK_Inv_InvoiceAttach_Inv_Invoice] FOREIGN KEY ([InvoiceID]) REFERENCES [dbo].[Inv_Invoice] ([ID])
GO
