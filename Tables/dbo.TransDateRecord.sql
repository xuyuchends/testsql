CREATE TABLE [dbo].[TransDateRecord]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[StoreID] [int] NOT NULL,
[BeginTime] [datetime] NULL,
[EndTime] [datetime] NULL,
[SendDate] [datetime] NULL,
[TransferType] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HasCalculated] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TransDateRecord] ADD CONSTRAINT [PK_Table_1] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
