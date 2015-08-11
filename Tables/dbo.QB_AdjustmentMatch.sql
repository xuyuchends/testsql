CREATE TABLE [dbo].[QB_AdjustmentMatch]
(
[AdjustName] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[StoreID] [int] NOT NULL,
[AdjustType] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[QBID] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[QBType] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[OppQBID] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[QBClassID] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[QBVendorID] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[QB_AdjustmentMatch] ADD CONSTRAINT [CK_QB_AdjustmentMatch] CHECK (([QBtype]='DEBIT' OR [QBtype]='CREDIT'))
GO
EXEC sp_addextendedproperty N'MS_Description', N'对应QBID的ID，', 'SCHEMA', N'dbo', 'TABLE', N'QB_AdjustmentMatch', 'COLUMN', N'OppQBID'
GO
