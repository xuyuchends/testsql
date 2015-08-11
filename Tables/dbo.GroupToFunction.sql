CREATE TABLE [dbo].[GroupToFunction]
(
[GroupID] [int] NOT NULL,
[FunctionID] [int] NOT NULL,
[AllOrOneShow] [int] NOT NULL,
[UserID] [int] NULL,
[LastUpdate] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[GroupToFunction] ADD CONSTRAINT [PK_GroupToFunction] PRIMARY KEY CLUSTERED  ([GroupID], [FunctionID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[GroupToFunction] ADD CONSTRAINT [FK_GroupToFunction_function] FOREIGN KEY ([FunctionID]) REFERENCES [dbo].[Function] ([ID])
GO
ALTER TABLE [dbo].[GroupToFunction] ADD CONSTRAINT [FK_GroupToFunction_Group] FOREIGN KEY ([GroupID]) REFERENCES [dbo].[Group] ([ID])
GO
EXEC sp_addextendedproperty N'MS_Description', N'all store=1 ,one store=2, both =4', 'SCHEMA', N'dbo', 'TABLE', N'GroupToFunction', 'COLUMN', N'AllOrOneShow'
GO
