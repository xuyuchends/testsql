CREATE TABLE [dbo].[CashDepsits]
(
[StoreI] [int] NOT NULL,
[ID] [int] NOT NULL,
[BusinessDate] [smalldatetime] NOT NULL,
[CashDeposit] [money] NOT NULL,
[LastUpdate] [datetime] NOT NULL
) ON [PRIMARY]
ALTER TABLE [dbo].[CashDepsits] ADD 
CONSTRAINT [PK_CashDeosits] PRIMARY KEY CLUSTERED  ([StoreID], [ID]) ON [PRIMARY]
GO
