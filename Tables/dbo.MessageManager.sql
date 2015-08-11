CREATE TABLE [dbo].[MessageManager]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[MsgSubject] [nvarchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[MsgContent] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[UserID] [int] NOT NULL,
[ParentID] [int] NULL,
[SendTo] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[StoreID] [int] NULL,
[SendDate] [datetime] NULL,
[DelUserID] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
