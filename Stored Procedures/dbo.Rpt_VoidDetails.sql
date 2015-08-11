SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Rpt_VoidDetails]
(
	@BeginDate datetime,
	@EndDate datetime,
	@StoreID nvarchar(200)
)
as
begin
declare @sql nvarchar(max)
SET NOCOUNT ON;

set @sql=' SELECT s.id as storeID,
			s.StoreName as StoreName,
o.ID as OrderID,
CONVERT(varchar(12) , o.BusinessDate, 101 ) as Date,
ABS(SUM(oli.Qty*(oli.Price-oli.AdjustedPrice))) as Amount,
e.FirstName + '' '+ ''' + e.LastName AS Server,
mi.Name as VoidItem,   
v.Name as VoidName
FROM [order] as o
INNER JOIN Employee as e  ON e.ID = o.EmpIDClose and e.StoreID=o.StoreID  
inner join OrderLineItem oli on o.ID=oli.OrderID and o.StoreID=oli.StoreID and o.BusinessDate=oli.BusinessDate
inner join MenuItem mi on  oli.ItemID=mi.ID and oli.StoreID=mi.StoreID
inner join Void v on v.ID=oli.AdjustID  and v.StoreID=oli.StoreID
inner join store as s on s.id=oli.storeID 
WHERE  oli.RecordType=''VOID'' and AdjustedPrice>=0 and oli.SI<>''N/A''
and o.BusinessDate BETWEEN ''' + CONVERT(varchar, @BeginDate, 120 )  + ''' AND ''' + CONVERT(varchar, @EndDate, 120 ) + ''' 
and o.StoreID in '+@storeID +'
group by s.id,s.StoreName,o.ID,mi.Name,v.Name,o.BusinessDate,e.FirstName + '' '+ ''' +  e.LastName'
--select @sql
exec sp_executesql @sql
end
GO
