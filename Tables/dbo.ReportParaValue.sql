CREATE TABLE [dbo].[ReportParaValue]
(
[SubscriptionID] [int] NOT NULL,
[ParameterID] [int] NOT NULL,
[Value] [nvarchar] (2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ID] [int] NOT NULL IDENTITY(1, 1)
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ReportParaValue] ADD CONSTRAINT [PK_ReportParaValue] PRIMARY KEY CLUSTERED  ([SubscriptionID], [ParameterID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ReportParaValue] ADD CONSTRAINT [FK_ReportParaValue_ReportSubscription] FOREIGN KEY ([SubscriptionID]) REFERENCES [dbo].[ReportSubscription] ([ID])
GO
