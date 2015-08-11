CREATE TABLE [dbo].[CashDepsits]
(
[StoreD] [int] NOT NULL,
[ID] [int] NOT NULL,
[BusinessDate] [smalldatetime] NOT NULL,
[CashDeposit] [money] NOT NULL,
[LastUpdate] [datetime] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CashDepsits] ADD CONSTRAINT [PK_CashDeosits] PRIMARY KEY CLUSTERED  ([StoreD], [ID]) ON [PRIMARY]
GO
