CREATE TABLE [dbo].[InstalledModules]
(
[StoreID] [int] NOT NULL,
[HSModule] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Installed] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ModuleEnabled] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[LastUpdate] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[InstalledModules] ADD CONSTRAINT [PK_InstalledModules] PRIMARY KEY CLUSTERED  ([StoreID], [HSModule]) ON [PRIMARY]
GO
