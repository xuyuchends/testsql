SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE function [dbo].[fnPaidInTrxTable]
(
	@BeginDate datetime,
	@EndDate datetime,
	@StoreID nvarchar(2000)
)
RETURNS @resultTable TABLE ([StoreID] int,
	[ID] int,
	[Amount] money,
	[ManagerID] int,
	[EmployeeID] int,
	[Note] nvarchar(max),
	[Status] nvarchar(50),
	[BusinessDate] datetime,
	[LastUpdate] datetime)
AS

Begin
declare @historyDate datetime=DATEADD(YEAR,-2,CONVERT(varchar(10), GETDATE(), 120 ))

if(@BeginDate<@historyDate and @EndDate>=@historyDate)
begin
	INSERT INTO @resultTable([StoreID],[ID],[Amount],[ManagerID],[EmployeeID],[Note],[Status],[BusinessDate],[LastUpdate])
	SELECT [StoreID],[ID],[Amount],[ManagerID],[EmployeeID],[Note],[Status],[BusinessDate],[LastUpdate]
	FROM paidInTrxArchive where [BusinessDate] between @historyDate and @EndDate and storeID in (select * from dbo.f_split(@StoreID,','))
	
	INSERT INTO @resultTable([StoreID],[ID],[Amount],[ManagerID],[EmployeeID],[Note],[Status],[BusinessDate],[LastUpdate])
	SELECT [StoreID],[ID],[Amount],[ManagerID],[EmployeeID],[Note],[Status],[BusinessDate],[LastUpdate]
	FROM paidInTrxArchive where [BusinessDate] between  @BeginDate and @historyDate and storeID in (select * from dbo.f_split(@StoreID,','))
end
else if (@BeginDate>=@historyDate)
begin
	INSERT INTO @resultTable([StoreID],[ID],[Amount],[ManagerID],[EmployeeID],[Note],[Status],[BusinessDate],[LastUpdate])
	SELECT [StoreID],[ID],[Amount],[ManagerID],[EmployeeID],[Note],[Status],[BusinessDate],[LastUpdate]
	FROM paidInTrx where [BusinessDate] between @BeginDate and @EndDate and storeID in (select * from dbo.f_split(@StoreID,','))
end
else if (@EndDate<@historyDate)
begin
	INSERT INTO @resultTable([StoreID],[ID],[Amount],[ManagerID],[EmployeeID],[Note],[Status],[BusinessDate],[LastUpdate])
	SELECT [StoreID],[ID],[Amount],[ManagerID],[EmployeeID],[Note],[Status],[BusinessDate],[LastUpdate]
	FROM paidInTrxArchive where [BusinessDate] between @BeginDate and @EndDate and storeID in (select * from dbo.f_split(@StoreID,','))
end
return 
End


GO
