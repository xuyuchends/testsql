CREATE TABLE [dbo].[StoreSetting]
(
[StoreID] [int] NOT NULL,
[PercentWithheldTips] [real] NULL,
[DriverRoutingInstalled] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SurchargeGuestPays] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OTWorkweekThreshold] [int] NOT NULL,
[LastUpdate] [datetime] NULL,
[OTHoursType] [int] NOT NULL,
[InventoryInstalled] [bit] NULL,
[BusinessHourOpen] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[StoreSetting] ADD CONSTRAINT [PK_StoreSetting] PRIMARY KEY CLUSTERED  ([StoreID]) ON [PRIMARY]
GO
