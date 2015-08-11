CREATE TABLE [dbo].[MenuItem]
(
[StoreID] [int] NOT NULL,
[ID] [int] NOT NULL,
[Name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Category] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Department] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Price] [money] NULL,
[MIType] [nvarchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[IsModifier] [bit] NOT NULL,
[ReportName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReportCategory] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReportDepartment] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Cost] [money] NULL,
[Status] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastUpdate] [datetime] NOT NULL,
[UpcNumber] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DoubleItemID] [int] NULL,
[isDouble] [bit] NOT NULL CONSTRAINT [DF__MenuItem__isDoub__0B7D76D2] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[MenuItem] ADD CONSTRAINT [PK_MenuItem] PRIMARY KEY CLUSTERED  ([StoreID], [ID]) ON [PRIMARY]
GO
