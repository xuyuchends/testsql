CREATE TABLE [dbo].[EmployeeOtherWage]
(
[StoreID] [int] NOT NULL,
[ID] [int] NOT NULL,
[EmployeeID] [int] NOT NULL,
[OtherWage] [money] NOT NULL,
[BusinessDate] [datetime] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EmployeeOtherWage] ADD CONSTRAINT [PK_EmployeeOtherWage] PRIMARY KEY CLUSTERED  ([StoreID], [ID]) ON [PRIMARY]
GO
