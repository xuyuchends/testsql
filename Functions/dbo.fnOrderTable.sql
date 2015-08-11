SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE function [dbo].[fnOrderTable]
(
	@BeginDate datetime,
	@EndDate datetime,
	@StoreID nvarchar(2000)
)
RETURNS @resultTable TABLE ( [StoreID] int,
	[ID] bigint,
	[OpenTime] datetime,
	[CloseTime] datetime,
	[EmpIDOpen] int,
	[EmpIDClose] int,
	[TableName] nvarchar(50),
	[GuestCount] int,
	[RevenueCenter] nvarchar(50),
	[MealPeriod] nvarchar(50),
	[LineItemCount] int,
	[CheckCount] int,
	[PaymentCount] int,
	[TaxCount] int,
	[FutureOrder] char(1),
	[BusinessDate] datetime,
	[LastUpdate] datetime,
	[Status] nvarchar(50))
AS

Begin
declare @historyDate datetime=DATEADD(YEAR,-2,CONVERT(varchar(10), GETDATE(), 120 ))

if(@BeginDate<@historyDate and @EndDate>=@historyDate)
begin
	INSERT INTO @resultTable([StoreID],[ID],[OpenTime],[CloseTime],[EmpIDOpen],[EmpIDClose],[TableName],[GuestCount],[RevenueCenter],[MealPeriod],[LineItemCount],[CheckCount],[PaymentCount],[TaxCount],[FutureOrder],[BusinessDate],[LastUpdate],status)
	SELECT [StoreID],[ID],[OpenTime],[CloseTime],[EmpIDOpen],[EmpIDClose],[TableName],[GuestCount],[RevenueCenter],[MealPeriod],[LineItemCount],[CheckCount],[PaymentCount],[TaxCount],[FutureOrder],[BusinessDate],[LastUpdate],status
	FROM [order] where [BusinessDate] between @historyDate and @EndDate and storeID in (select * from dbo.f_split(@StoreID,',')) and status='CLOSE'

	INSERT INTO @resultTable([StoreID],[ID],[OpenTime],[CloseTime],[EmpIDOpen],[EmpIDClose],[TableName],[GuestCount],[RevenueCenter],[MealPeriod],[LineItemCount],[CheckCount],[PaymentCount],[TaxCount],[FutureOrder],[BusinessDate] ,[LastUpdate],status)
	SELECT [StoreID],[ID],[OpenTime],[CloseTime],[EmpIDOpen],[EmpIDClose],[TableName],[GuestCount],[RevenueCenter],[MealPeriod],[LineItemCount],[CheckCount],[PaymentCount],[TaxCount],[FutureOrder],[BusinessDate],[LastUpdate],status
	FROM [orderArchive] where [BusinessDate] between @BeginDate and @historyDate and storeID in (select * from dbo.f_split(@StoreID,',')) and status='CLOSE'
end
else if (@BeginDate>=@historyDate)
begin
	INSERT INTO @resultTable([StoreID],[ID],[OpenTime],[CloseTime],[EmpIDOpen],[EmpIDClose],[TableName],[GuestCount],[RevenueCenter],[MealPeriod],[LineItemCount],[CheckCount],[PaymentCount],[TaxCount],[FutureOrder],[BusinessDate],[LastUpdate],status)
	SELECT [StoreID],[ID],[OpenTime],[CloseTime],[EmpIDOpen],[EmpIDClose],[TableName],[GuestCount],[RevenueCenter],[MealPeriod],[LineItemCount],[CheckCount],[PaymentCount],[TaxCount],[FutureOrder],[BusinessDate],[LastUpdate],status
	FROM [order] where [BusinessDate] between @BeginDate and @EndDate and storeID in (select * from dbo.f_split(@StoreID,',')) and status='CLOSE'
end
else if (@EndDate<@historyDate)
begin
	INSERT INTO @resultTable([StoreID],[ID],[OpenTime],[CloseTime],[EmpIDOpen],[EmpIDClose],[TableName],[GuestCount],[RevenueCenter],[MealPeriod],[LineItemCount],[CheckCount],[PaymentCount],[TaxCount],[FutureOrder],[BusinessDate] ,[LastUpdate],status)
	SELECT [StoreID],[ID],[OpenTime],[CloseTime],[EmpIDOpen],[EmpIDClose],[TableName],[GuestCount],[RevenueCenter],[MealPeriod],[LineItemCount],[CheckCount],[PaymentCount],[TaxCount],[FutureOrder],[BusinessDate],[LastUpdate],status
	FROM [orderArchive] where [BusinessDate] between @BeginDate and @EndDate and storeID in (select * from dbo.f_split(@StoreID,',')) and status='CLOSE'
end

return 
End


GO
