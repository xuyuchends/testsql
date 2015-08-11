CREATE TABLE [dbo].[ConstTable]
(
[Category] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ID] [int] NOT NULL,
[Value] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[IsDefault] [bit] NOT NULL CONSTRAINT [DF_ConstString_IsDefault] DEFAULT ((0)),
[Describe] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[ConstTable] ADD CONSTRAINT [PK_ConstString_1] PRIMARY KEY CLUSTERED  ([Category], [ID], [Value]) ON [PRIMARY]
GO
