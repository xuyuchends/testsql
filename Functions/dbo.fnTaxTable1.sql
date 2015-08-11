SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE function [dbo].[fnTaxTable1]
(
	@BeginDate datetime,
	@EndDate datetime
)
RETURNS @resultTable TABLE ( [StoreID] int,
	[TaxCategoryID] int,
	[CheckID] bigint,
	[OrderID] bigint,
	[Category] nvarchar(50),
	[TaxAmt] decimal(19,10),
	[TaxOrderAmt] decimal(19,10),
	[BusinessDate] datetime,
	[LastUpdate] datetime)
AS

Begin
declare @historyDate datetime=DATEADD(YEAR,-2,CONVERT(varchar(10), GETDATE(), 120 ))

if(@BeginDate<@historyDate and @EndDate>=@historyDate)
begin
	insert into @resultTable([StoreID],[TaxCategoryID],[CheckID],[OrderID],[Category],[TaxAmt],[TaxOrderAmt],[BusinessDate],[LastUpdate])
	SELECT [StoreID],[TaxCategoryID],[CheckID],[OrderID],[Category],[TaxAmt],[TaxOrderAmt],[BusinessDate],[LastUpdate]
	FROM [Tax] where [BusinessDate] between @historyDate and @EndDate  
	and status='VALID'

	insert into @resultTable([StoreID],[TaxCategoryID],[CheckID],[OrderID],[Category],[TaxAmt],[TaxOrderAmt],[BusinessDate],[LastUpdate])
	SELECT [StoreID],[TaxCategoryID],[CheckID],[OrderID],[Category],[TaxAmt],[TaxOrderAmt],[BusinessDate],[LastUpdate]
	FROM [TaxArchive] where [BusinessDate] between @BeginDate and @historyDate 
	and status='VALID'

end
else if (@BeginDate>=@historyDate)
begin
	insert into @resultTable([StoreID],[TaxCategoryID],[CheckID],[OrderID],[Category],[TaxAmt],[TaxOrderAmt],[BusinessDate],[LastUpdate])
	SELECT [StoreID],[TaxCategoryID],[CheckID],[OrderID],[Category],[TaxAmt],[TaxOrderAmt],[BusinessDate],[LastUpdate]
	FROM [Tax] where [BusinessDate] between @BeginDate and @EndDate 
	and status='VALID'
end
else if (@EndDate<@historyDate)
begin
	insert into @resultTable([StoreID],[TaxCategoryID],[CheckID],[OrderID],[Category],[TaxAmt],[TaxOrderAmt],[BusinessDate],[LastUpdate])
	SELECT [StoreID],[TaxCategoryID],[CheckID],[OrderID],[Category],[TaxAmt],[TaxOrderAmt],[BusinessDate],[LastUpdate]
	FROM [TaxArchive] where [BusinessDate] between @BeginDate and @EndDate 
	and status='VALID'
end

return 
End
GO
