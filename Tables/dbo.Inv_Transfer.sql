CREATE TABLE [dbo].[Inv_Transfer]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[FromStoreID] [int] NOT NULL,
[FromUserID] [int] NOT NULL,
[CreationDate] [datetime] NOT NULL,
[ToStoreID] [int] NOT NULL,
[ToUserID] [int] NULL,
[TransferDate] [datetime] NULL,
[WeekEnding] [datetime] NULL,
[Comments] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Status] [int] NOT NULL,
[LastUpdate] [datetime] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[Inv_Transfer] ADD CONSTRAINT [PK_Inv_Transfer] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
