CREATE TABLE [dbo].[DeliveryReimbursements]
(
[StoreID] [int] NOT NULL,
[EmployeeID] [nchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ReimbursementTtl] [money] NULL,
[Status] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BusinessDate] [datetime] NULL,
[LastUpdate] [datetime] NULL CONSTRAINT [DF_DeliveryReimbursements_LastUpdate] DEFAULT (getdate())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DeliveryReimbursements] ADD CONSTRAINT [PK_DeliveryReimbursements_1] PRIMARY KEY CLUSTERED  ([StoreID], [EmployeeID]) ON [PRIMARY]
GO
