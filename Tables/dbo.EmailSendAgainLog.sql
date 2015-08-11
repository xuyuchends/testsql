CREATE TABLE [dbo].[EmailSendAgainLog]
(
[ID] [int] NOT NULL,
[Type] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Subject] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ContentText] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressTo] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SendTime] [datetime] NOT NULL,
[HasSend] [bit] NOT NULL,
[StoreID] [int] NULL,
[FromUserID] [int] NULL,
[ErrorMessage] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MoveTime] [datetime] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
