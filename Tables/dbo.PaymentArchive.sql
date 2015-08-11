CREATE TABLE [dbo].[PaymentArchive]
(
[StoreID] [int] NOT NULL,
[CheckID] [bigint] NOT NULL,
[LineNum] [int] NOT NULL,
[MethodID] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Amount] [money] NULL,
[AmountReceived] [money] NULL,
[Tip] [money] NULL,
[Gratuity] [money] NULL,
[BusinessDate] [datetime] NOT NULL,
[LastUpdate] [datetime] NOT NULL,
[Status] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PaymentArchive] ADD CONSTRAINT [PK_PaymentArchive] PRIMARY KEY CLUSTERED  ([StoreID], [CheckID], [LineNum], [BusinessDate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [BusinessDate] ON [dbo].[PaymentArchive] ([BusinessDate] DESC, [Status]) INCLUDE ([Amount], [AmountReceived], [Gratuity], [MethodID], [Tip]) ON [PRIMARY]
GO
