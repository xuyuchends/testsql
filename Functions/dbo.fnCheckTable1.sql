SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create function [dbo].[fnCheckTable1]
(
	@BeginDate datetime,
	@EndDate datetime
)
RETURNS @resultTable TABLE ( [StoreID] int,
	[ID] bigint,
	[SaleTime] datetime,
	[OrderID] bigint,
	[EmployeeID] int,
	[Seat] nvarchar(200),
	[FutureOrderAdvPayment] char(1),
	[BusinessDate] datetime,
	[LastUpdate] datetime)
AS

Begin
declare @historyDate datetime=DATEADD(YEAR,-2,CONVERT(varchar(10), GETDATE(), 120 ))
if(@BeginDate<@historyDate and @EndDate>=@historyDate)
begin
	INSERT INTO @resultTable([StoreID],[ID],[SaleTime],[OrderID],[EmployeeID],[Seat],[FutureOrderAdvPayment],[BusinessDate],[LastUpdate])
	SELECT [StoreID],[ID],[SaleTime],[OrderID],[EmployeeID],[Seat],[FutureOrderAdvPayment],[BusinessDate],[LastUpdate]
	FROM [Check] where [BusinessDate] between @historyDate and @EndDate  and status='CLOSED'

	INSERT INTO @resultTable([StoreID],[ID],[SaleTime],[OrderID],[EmployeeID],[Seat],[FutureOrderAdvPayment],[BusinessDate],[LastUpdate])
	SELECT [StoreID],[ID],[SaleTime],[OrderID],[EmployeeID],[Seat],[FutureOrderAdvPayment],[BusinessDate],[LastUpdate]
	FROM [CheckArchive] where [BusinessDate] between @BeginDate and @historyDate  and status='CLOSED'

end
else if (@BeginDate>=@historyDate)
begin
	INSERT INTO @resultTable([StoreID],[ID],[SaleTime],[OrderID],[EmployeeID],[Seat],[FutureOrderAdvPayment],[BusinessDate],[LastUpdate])
	SELECT [StoreID],[ID],[SaleTime],[OrderID],[EmployeeID],[Seat],[FutureOrderAdvPayment],[BusinessDate],[LastUpdate]
	FROM [Check] where [BusinessDate] between @BeginDate and @EndDate and status='CLOSED'
end
else if (@EndDate<@historyDate)
begin
	INSERT INTO @resultTable([StoreID],[ID],[SaleTime],[OrderID],[EmployeeID],[Seat],[FutureOrderAdvPayment],[BusinessDate],[LastUpdate])
	SELECT [StoreID],[ID],[SaleTime],[OrderID],[EmployeeID],[Seat],[FutureOrderAdvPayment],[BusinessDate],[LastUpdate]
	FROM [CheckArchive] where [BusinessDate] between @BeginDate and @EndDate  and status='CLOSED'
end
return 
End


GO
