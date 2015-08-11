SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[Rpt_Overtime]
	@BeginDate datetime,
	@EndDate datetime,
	@storeID nvarchar(200),
	@position nvarchar(200)
AS
BEGIN
declare @sql nvarchar(max)
SET NOCOUNT ON;
set @sql='select s.StoreName as StoreName ,
		 p.name as position,
		 e.FirstName+'' '+ '''+ e.LastName as employee,
sum(ets.OT1HoursWorked*ets.OT1Payrate+ ets.OT2HoursWorked*ets.OT2Payrate) as  pay,
sum(ets.OT1HoursWorked+ets.OT2HoursWorked) as hours
from EmployeeTimeSheet as ets
inner join Employee as e on e.ID=ets.EmployeeID and e.StoreID=ets.StoreID
inner join Store  as s on ets.StoreID=s.ID
inner join Position as p on p.storeid=ets.StoreID and p.id=ets.positionid
where (ets.OT1HoursWorked*ets.OT1Payrate+ ets.OT2HoursWorked*ets.OT2Payrate)>0 and ets.BusinessDate BETWEEN '''+ Convert(nvarchar,@BeginDate,120)+ ''' AND '''+ Convert(nvarchar,@EndDate,120) + ''' 
and e.StoreID in ('+@storeID +')'
if ISNULL(@position,'')<>''
begin
	set @sql+=' and p.name='''+@position+''''
end
set  @sql+=' group by s.StoreName,p.name,e.FirstName+'' '+ '''+ e.LastName '
--select @sql
exec sp_executesql @sql
END
GO
