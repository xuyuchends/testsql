CREATE TABLE [dbo].[PullBackHistory]
(
[StoreID] [int] NOT NULL,
[OrderID] [bigint] NOT NULL,
[BusinessDate] [datetime] NOT NULL,
[CheckID] [bigint] NOT NULL,
[LineNum] [int] NOT NULL,
[Seat] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ServerID] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[UserID] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PullBackDate] [datetime] NULL,
[ToTable] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Amount] [money] NULL,
[MethodID] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastUpdate] [datetime] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[PullBackHistory] ADD CONSTRAINT [PK_PullBackHistory] PRIMARY KEY CLUSTERED  ([StoreID], [OrderID], [BusinessDate], [CheckID], [LineNum]) ON [PRIMARY]
GO
