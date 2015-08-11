SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [dbo].[Rpt_D_SalesByPaymentByDay]
	@BeginDate datetime,
	@EndDate datetime,
	@storeID nvarchar(200)
AS  
BEGIN
declare @sql nvarchar(max)
SET NOCOUNT ON;

set @sql='SELECT pm.Name as PaymentName, 
isnull(SUM(p.Amount),0) AS Sales
FROM  Payment AS p 
	INNER JOIN PaymentMethod AS pm ON p.MethodID = pm.Name AND pm.StoreID = p.StoreID 
	where p.BusinessDate between '''+CONVERT(nvarchar(20),@BeginDate)+''' and '''+CONVERT(nvarchar(20),@EndDate)+''' and p.StoreID in ('+@storeID+')
	and p.Status=''CLOSED'''
set @sql+=' GROUP BY pm.Name '

--select @sql
exec sp_executesql @sql
end
GO
