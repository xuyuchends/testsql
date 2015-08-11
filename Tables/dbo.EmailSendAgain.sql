CREATE TABLE [dbo].[EmailSendAgain]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[Type] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Subject] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ContentText] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[AddressTo] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SendTime] [datetime] NOT NULL,
[HasSend] [bit] NOT NULL CONSTRAINT [DF_EmailSendAgain_HasSend] DEFAULT ((0)),
[StoreID] [int] NULL,
[FromUserID] [int] NULL,
[ErrorMessage] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[EmailSendAgain] ADD CONSTRAINT [PK_EmailSendAgain] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
