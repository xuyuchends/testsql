CREATE TABLE [dbo].[Inv_TransferDetail]
(
[TransferID] [int] NULL,
[InvItemID] [int] NULL,
[Qty] [decimal] (18, 2) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Inv_TransferDetail] ADD CONSTRAINT [FK_Inv_TransferDetail_Inv_Item] FOREIGN KEY ([InvItemID]) REFERENCES [dbo].[Inv_Item] ([ID])
GO
ALTER TABLE [dbo].[Inv_TransferDetail] ADD CONSTRAINT [FK_Inv_TransferDetail_Inv_Transfer] FOREIGN KEY ([TransferID]) REFERENCES [dbo].[Inv_Transfer] ([ID])
GO
