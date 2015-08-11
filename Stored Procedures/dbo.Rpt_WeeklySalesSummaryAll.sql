SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[Rpt_WeeklySalesSummaryAll]
 @beginDate datetime,    -- Begind date
 @endDate datetime,     -- End date
 --@weekdayfilter smallint,     -- filter by day of week
 @StoreID nvarchar(200)     --只可传一个StoreID
 --@otherDB varchar(50)     -- name of database to pull the information from

AS

Declare @sqlOutput NVARCHAR(MAX)

--Declare @DriverImbursementInstalled as bit
--Set @DriverImbursementInstalled = 0
--If (select DriverRoutingInstalled from StoreSetting where StoreID=@StoreID
-- ) = 'Y'
--Set @DriverImbursementInstalled = 1

Set @sqlOutput = 'Select a.BusinessDate, 
isnull(Sum(CashSale),0) as CashSale, 
isnull(Sum(OtherSale),0) as OtherSale,
isnull(Sum(CCSale),0) as CCSale, 
isnull(Sum(CCTip),0) as CCTip, 
isnull(Sum(CCSale + CCTip),0) as NetCC,
isnull(Sum(CashSale+ OtherSale + CCSale),0) as GrossSale,
isnull(Tax,0) as Tax, 
isnull((Sum(CashSale+ OtherSale + CCSale) -  Tax),0) as NetSale, --Net Revenue
isnull(PaidOut,0) as PaidOut, '


--If @DriverImbursementInstalled = 1
--Begin
 Set @sqlOutput = @sqlOutput + '(Sum(CashSale - CCTip - CashTip - cashChangeFromGC ) - isnull(PaidOut,0) + isnull(PaidIn,0) - isnull(Driver_Reimbursement,0)
 + ((isnull(CCWithHeld,0) + Sum(isnull(TotalSrvCharage,0) - isnull(CashSrvCharge,0))) * (Select  PercentWithheldTips from StoreSetting where StoreID in ('+@StoreID+')))) as CashOH, '
--End
--Else
--Begin
-- Set @sqlOutput = @sqlOutput + '(Sum(CashSale - CCTip - CashTip - cashChangeFromGC ) - isnull(PaidOut,0) + isnull(PaidIn,0) 
-- + ((isnull(CCWithHeld,0) + Sum(isnull(TotalSrvCharage,0) - isnull(CashSrvCharge,0))) * ' + @PercentWithheld_Tips + ')) as CashOH, '
 

--End



Set @sqlOutput = @sqlOutput + '
(isnull(NetSales,0) + isnull(Discount,0) + isnull(Comp,0)) as ActualSale,
isnull(NetSales,0) as NetSales,--Net Sale
isnull(gcSales,0) as GC_Sales,
isnull(PaidIn,0) as PaidIn,
isnull(InHousePaymentSales,0) as In_House_Payments

From 
--Sale info
 (Select sh.BusinessDate,  
''CashSale'' = Case When (sd.MethodID = ''CASH'') Then sum(sd.amount) Else 0 End,  
''OtherSale'' = Case When (p.PaymentType <> ''CREDIT_CARD'' and sd.MethodID <> ''CASH'' )Then sum(sd.amount) Else 0 End,  
''CCSale'' = Case When (p.PaymentType =''CREDIT_CARD'') Then sum(sd.amount) Else 0 End,  
''CCTip'' = Case When (p.PaymentType =''CREDIT_CARD'') Then sum(sd.tip + sd.Gratuity) Else 0 End,  
''CashTip'' = Case When (sd.MethodID = ''CASH'') Then sum(sd.tip) Else 0 End,  
''NonCashTip'' = Case When (sd.MethodID <> ''CASH'') Then sum(sd.tip) Else 0 End,  
''CashSrvCharge'' = Case When (sd.MethodID = ''CASH'') Then sum(sd.Gratuity) Else 0 End,  
isnull(Sum(sd.Gratuity),0) as ''TotalSrvCharage'',  
''cashChangeFromGC'' = Case When (p.PaymentType =''GC'') Then Sum(sd.AmountReceived - sd.amount + sd.Gratuity) Else 0 End

FROM [dbo].[fnCheckTable]('''+ Convert(nvarchar,@BeginDate,120)+ ''','''+ Convert(nvarchar,@EndDate,120) + ''','''+@storeID+''') sh
INNER JOIN [dbo].[fnPaymentTable]('''+ Convert(nvarchar,@BeginDate,120)+ ''','''+ Convert(nvarchar,@EndDate,120) + ''','''+@storeID+''') sd ON sh.ID = sd.CheckID and sh.StoreID=sd.StoreID
and sh.BusinessDate=sd.BusinessDate
INNER JOIN PaymentMethod p ON sd.MethodID = p.Name and p.StoreID=sh.StoreID
Group by sh.BusinessDate, sd.MethodID, p.PaymentType) a 

Join
--Tax Info
(Select ot.BusinessDate, sum(TaxAmt) as Tax  From [dbo].[fnTaxTable]('''+ Convert(nvarchar,@BeginDate,120)+ ''','''+ Convert(nvarchar,@EndDate,120) + ''','''+@storeID+''') ot   
join [dbo].[fnOrderTable]('''+ Convert(nvarchar,@BeginDate,120)+ ''','''+ Convert(nvarchar,@EndDate,120) + ''','''+@storeID+''') o on ot.OrderID = o.ID and
O.StoreID=ot.StoreID and O.BusinessDate=ot.BusinessDate  Group by ot.BusinessDate) b on a.BusinessDate = b.BusinessDate   

Join
--Net Sales / Discount

(Select o.BusinessDate, Sum((price-AdjustedPrice) * qty) as NetSales,  
(select SUM(AdjustedPrice * qty) from [dbo].[fnOrderLineItemTable]('''+ Convert(nvarchar,@BeginDate,120)+ ''','''+ Convert(nvarchar,@EndDate,120) + ''','''+@storeID+''')
 where RecordType=''Discount'' and itemid in 
 (select id from MenuItem Where MIType NOT IN (''GC'',''IHPYMNT''))) as Discount   
 From [dbo].[fnOrderTable]('''+ Convert(nvarchar,@BeginDate,120)+ ''','''+ Convert(nvarchar,@EndDate,120) + ''','''+@storeID+''') o   
 join [dbo].[fnOrderLineItemTable]('''+ Convert(nvarchar,@BeginDate,120)+ ''','''+ Convert(nvarchar,@EndDate,120) + ''','''+@storeID+''') oli 
 on o.ID = oli.orderid and O.StoreID=oli.StoreID and O.BusinessDate=oli.BusinessDate Where  itemid in (select id from MenuItem Where MIType NOT IN (''GC'',''IHPYMNT''))  Group by o.BusinessDate) c on a.BusinessDate = c.BusinessDate

Left Join
--Comp

(SELECT o.BusinessDate,  SUM(olc.Qty * olc.AdjustedPrice) AS Comp    FROM [dbo].[fnOrderTable]('''+ Convert(nvarchar,@BeginDate,120)+ ''','''+ Convert(nvarchar,@EndDate,120) + ''','''+@storeID+''') o  
 INNER JOIN [dbo].[fnOrderLineItemTable]('''+ Convert(nvarchar,@BeginDate,120)+ ''','''+ Convert(nvarchar,@EndDate,120) + ''','''+@storeID+''') olc 
 ON o.ID = olc.OrderID  and     O.StoreID=olc.StoreID and     O.BusinessDate=olc.BusinessDate
WHERE  olc.RecordType=''COMP''
AND olc.ITEMID IN (SELECT ID FROM MenuItem WHERE  MIType NOT IN (''GC'',''IHPYMNT'') )  Group by o.BusinessDate) d on a.BusinessDate = d.BusinessDate    Left Join  

--In House / GC sale

(SELECT o.BusinessDate,   ''InHousePaymentSales'' = CASE When mi.MIType = ''IHPYMNT'' Then 
SUM(oli.Qty * oli.Price) Else 0 End,  ''gcSales'' = Case When mi.MIType = ''GC'' Then 
SUM(oli.Qty * oli.Price) Else 0 End  FROM [dbo].[fnOrderTable]('''+ Convert(nvarchar,@BeginDate,120)+ ''','''+ Convert(nvarchar,@EndDate,120) + ''','''+@storeID+''') o  
INNER JOIN [dbo].[fnOrderLineItemTable]('''+ Convert(nvarchar,@BeginDate,120)+ ''','''+ Convert(nvarchar,@EndDate,120) + ''','''+@storeID+''') oli 
ON o.ID = oli.OrderID and  O.StoreID=oli.StoreID and  O.BusinessDate=oli.BusinessDate  INNER JOIN MenuItem mi ON oli.ItemID = mi.ID and  mi.StoreID=oli.StoreID  WHERE mi.MIType in (''GC'', ''IHPYMNT'')  AND oli.RecordType <> ''VOID''  Group by o.BusinessDate, mi.MIType) e on a.BusinessDate = e.BusinessDate    
Left Join

--Paid in
(Select BusinessDate, SUM(Amount) as PaidIn  From [dbo].[fnPaidInTrxTable]('''+ Convert(nvarchar,@BeginDate,120)+ ''','''+ Convert(nvarchar,@EndDate,120) + ''','''+@storeID+''')   Group by BusinessDate, status) f on a.BusinessDate = f.BusinessDate    Left Join 

--Paid out

(Select BusinessDate,    SUM(Amount) as PaidOut  From [dbo].[fnPaidOutTrxTable]('''+ Convert(nvarchar,@BeginDate,120)+ ''','''+ Convert(nvarchar,@EndDate,120) + ''','''+@storeID+''')   Group by BusinessDate, status) n on a.BusinessDate = n.BusinessDate    Left Join

--Tip withheld from checkout

(SELECT BusinessDate, SUM(A.totalTip) as CCWithHeld  From DailyCheckOuts A  WHERE BusinessDate BETWEEN ''' + convert(nvarchar(20),@beginDate) + ''' AND ''' + convert(nvarchar(20),@endDate) + ''' and  StoreID in ('+@storeID+') Group by BusinessDate) g on a.BusinessDate = g.BusinessDate '



--If @DriverImbursementInstalled = 1
--Begin
 Set @sqlOutput = @sqlOutput + 'Left Join
-- Driver Reimbursement info
(SELECT BusinessDate, isnull(SUM(ReimbursementTtl),0) as ''Driver_Reimbursement''
FROM DeliveryReimbursements
WHERE BusinessDate between ''' + convert(nvarchar(20),@beginDate) + ''' AND ''' + convert(nvarchar(20),@endDate) + '''
AND Status = ''CLOSED'' and  StoreID in ('+@storeID+')
Group by BusinessDate) h on a.BusinessDate = h.BusinessDate '
--End 

--If @weekdayfilter >= 0 
--Begin
-- Set @sqlOutput = @sqlOutput + 'Where datepart(weekday,a.BusinessDate) = ' + cast(@weekdayfilter as varchar(max)) + ' '
--End

Set @sqlOutput = @sqlOutput + '
group by a.BusinessDate, tax, netsales, comp, discount, InHousePaymentSales, gcSales, paidout, paidin, CCWithHeld '
--If @DriverImbursementInstalled = 1
--Begin
 Set @sqlOutput = @sqlOutput + ',Driver_Reimbursement '
--End

execute sp_executesql @sqlOutput 
--select @sqlOutput 

GO
