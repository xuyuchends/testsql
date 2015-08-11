CREATE TABLE [dbo].[PaidInTrxArchive]
(
[StoreID] [int] NOT NULL,
[PaidInID] [int] NOT NULL,
[ID] [int] NOT NULL,
[Amount] [money] NULL,
[ManagerID] [int] NULL,
[EmployeeID] [int] NULL,
[Note] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Status] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BusinessDate] [datetime] NOT NULL,
[LastUpdate] [datetime] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[PaidInTrxArchive] ADD CONSTRAINT [PK_PaidInTrxArchive] PRIMARY KEY CLUSTERED  ([StoreID], [PaidInID], [BusinessDate]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [BusinessDate] ON [dbo].[PaidInTrxArchive] ([BusinessDate] DESC, [Status]) INCLUDE ([Amount], [StoreID]) ON [PRIMARY]
GO
