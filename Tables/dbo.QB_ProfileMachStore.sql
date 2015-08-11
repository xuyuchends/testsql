CREATE TABLE [dbo].[QB_ProfileMachStore]
(
[ProfileID] [int] NOT NULL,
[StoreID] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[QB_ProfileMachStore] ADD CONSTRAINT [PK_QB_ProfileMachStore] PRIMARY KEY CLUSTERED  ([ProfileID], [StoreID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[QB_ProfileMachStore] ADD CONSTRAINT [FK_QB_ProfileMachStore_QB_Profile] FOREIGN KEY ([ProfileID]) REFERENCES [dbo].[QB_Profile] ([ID])
GO
