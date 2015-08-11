SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create function [dbo].[fnPaymentTable1]
(
	@BeginDate datetime,
	@EndDate datetime
)
RETURNS @resultTable TABLE ([StoreID] int,
	[CheckID] bigint,
	[LineNum] int,
	[MethodID] nvarchar(50),
	[Amount] money,
	[AmountReceived] money,
	[Tip] money,
	[Gratuity] money,
	[BusinessDate] datetime,
	[LastUpdate] datetime,
	[Status] nvarchar(50))
AS

Begin
declare @historyDate datetime=DATEADD(YEAR,-2,CONVERT(varchar(10), GETDATE(), 120 ))

if(@BeginDate<@historyDate and @EndDate>=@historyDate)
begin
	INSERT INTO @resultTable([StoreID],[CheckID],[LineNum],[MethodID],[Amount],[AmountReceived],[Tip],[Gratuity],[BusinessDate],[LastUpdate],[Status])
	SELECT [StoreID],[CheckID],[LineNum],[MethodID],[Amount],[AmountReceived],[Tip],[Gratuity],[BusinessDate],[LastUpdate],[Status]
	FROM Payment where [BusinessDate] between @historyDate and @EndDate  and  status='CLOSED'
	
	INSERT INTO @resultTable([StoreID],[CheckID],[LineNum],[MethodID],[Amount],[AmountReceived],[Tip],[Gratuity],[BusinessDate],[LastUpdate],[Status])
	SELECT [StoreID],[CheckID],[LineNum],[MethodID],[Amount],[AmountReceived],[Tip],[Gratuity],[BusinessDate],[LastUpdate],[Status]
	FROM PaymentArchive where [BusinessDate] between @BeginDate and @historyDate  and status='CLOSED'
end
else if (@BeginDate>=@historyDate)
begin
	INSERT INTO @resultTable([StoreID],[CheckID],[LineNum],[MethodID],[Amount],[AmountReceived],[Tip],[Gratuity],[BusinessDate],[LastUpdate],[Status])
	SELECT [StoreID],[CheckID],[LineNum],[MethodID],[Amount],[AmountReceived],[Tip],[Gratuity],[BusinessDate],[LastUpdate],[Status]
	FROM Payment where [BusinessDate] between @BeginDate and @EndDate and status='CLOSED'
end
else if (@EndDate<@historyDate)
begin
	INSERT INTO @resultTable([StoreID],[CheckID],[LineNum],[MethodID],[Amount],[AmountReceived],[Tip],[Gratuity],[BusinessDate],[LastUpdate],[Status])
	SELECT [StoreID],[CheckID],[LineNum],[MethodID],[Amount],[AmountReceived],[Tip],[Gratuity],[BusinessDate],[LastUpdate],[Status]
	FROM PaymentArchive where [BusinessDate] between @BeginDate and @EndDate and status='CLOSED'
end
return 
End


GO
