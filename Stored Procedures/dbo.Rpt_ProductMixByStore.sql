SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Rpt_ProductMixByStore]
(
	@beginDate datetime,
	@EndDate datetime,
	@StoreIDStr nvarchar(20),
	@GroupByCategory char(1)
) 
as
declare @sql nvarchar(max)
declare @sqlGuestTotal nvarchar(max)
declare @StoreID int
declare @tabStr nvarchar(max)
declare @tabName nvarchar(max)
declare @where nvarchar(max)
declare @sqlStr nvarchar(max)
set @sqlGuestTotal='	(select SUM(GuestCount) from [Order] o where  o.BusinessDate between CONVERT(DATETIME, ''' + convert(varchar(20),@beginDate) + ''', 102)	AND CONVERT(DATETIME, ''' + convert(varchar(20),@EndDate) + ''', 102)   and StoreID in ('+@StoreIDStr+'))'


if isnull(@GroupByCategory ,'')='Y'
begin
set @tabStr = 'select tabAll.#sold,tabAll.NetSale,tabAll.GuestOrd,tabAll.Category '
set @sql='from	(SELECT  
	SUM(qty) #sold,mi.Category,
	sum(Qty*(oli.Price-AdjustedPrice)) as NetSale,
	convert(varchar(10),(SUM(Qty)*100/'+@sqlGuestTotal+'))+''%'' as GuestOrd
 from OrderLineItem oli inner join MenuItem mi on oli.ItemID=mi.ID and oli.StoreID=mi.StoreID  where oli.StoreID in  ('+(@StoreIDStr)+') and oli.BusinessDate between CONVERT(DATETIME, ''' + convert(varchar(20),@beginDate) + ''', 102) 
	AND CONVERT(DATETIME, ''' + convert(varchar(20),@EndDate) + ''', 102)      
	 group by mi.Category) tabAll'
end
else
begin
	set @tabStr = 'select tabAll.#sold,tabAll.NetSale,tabAll.GuestOrd,tabAll.Name '
	set @sql='from	(SELECT  
	SUM(qty) #sold,mi.Name,
	sum(Qty*(oli.Price-AdjustedPrice)) as NetSale,
	convert(varchar(10),(SUM(Qty)*100/'+@sqlGuestTotal+'))+''%'' as GuestOrd
 from OrderLineItem oli inner join MenuItem mi on oli.ItemID=mi.ID and oli.StoreID=mi.StoreID  where oli.StoreID in  ('+(@StoreIDStr)+') and oli.BusinessDate between CONVERT(DATETIME, ''' + convert(varchar(20),@beginDate) + ''', 102) 
	AND CONVERT(DATETIME, ''' + convert(varchar(20),@EndDate) + ''', 102)      
	 group by mi.Name) tabAll'
end



set @where=''
set @sqlStr=''
declare cur cursor
read_only
for select * from dbo.f_split(@StoreIDStr,',')
open cur
fetch next from cur into @StoreID
while(@@fetch_status=0)
begin
	set @tabName = 'tab'+CONVERT(nvarchar(20),@StoreID)
	set @tabStr = @tabStr+','+@tabName+'.#sold,'+@tabName+'.NetSale,'+@tabName+'.GuestOrd '
	
if isnull(@GroupByCategory ,'')='Y'
begin
set @tabStr = @tabStr+','+@tabName+'.Category '
  set @sqlStr =@sqlStr+	 ',	(SELECT  
	SUM(qty) #sold,mi.Category,
	sum(Qty*(oli.Price-AdjustedPrice)) as NetSale,
	convert(varchar(10),(SUM(Qty)*100/'+@sqlGuestTotal+'))+''%'' as GuestOrd
 from OrderLineItem oli inner join MenuItem mi on oli.ItemID=mi.ID and oli.StoreID=mi.StoreID  where oli.StoreID =  '+convert(nvarchar(20),@StoreID)+' and oli.BusinessDate between CONVERT(DATETIME, ''' + convert(varchar(20),@beginDate) + ''', 102) 
	AND CONVERT(DATETIME, ''' + convert(varchar(20),@EndDate) + ''', 102)      
	 group by mi.Category) '+@tabName
	 if @where=''
	 begin
	 
	 set @where =' where '+ @tabName+'.Category = tabAll.Category '
	 end
	 else
	 begin
		 set @where =@where +' and '+ @tabName+'.Category = tabAll.Category '
	 end
	 end
	 else
	 begin
		set @tabStr = @tabStr+','+@tabName+'.Name '
		  set @sqlStr =@sqlStr+	 ',	(SELECT  
	SUM(qty) #sold,mi.Name,
	sum(Qty*(oli.Price-AdjustedPrice)) as NetSale,
	convert(varchar(10),(SUM(Qty)*100/'+@sqlGuestTotal+'))+''%'' as GuestOrd
 from OrderLineItem oli inner join MenuItem mi on oli.ItemID=mi.ID and oli.StoreID=mi.StoreID  where oli.StoreID =  '+convert(nvarchar(20),@StoreID)+' and oli.BusinessDate between CONVERT(DATETIME, ''' + convert(varchar(20),@beginDate) + ''', 102) 
	AND CONVERT(DATETIME, ''' + convert(varchar(20),@EndDate) + ''', 102)      
	 group by mi.Name) '+@tabName
	 
	 if @where=''
	 begin
	 
	 set @where =' where '+ @tabName+'.Name = tabAll.Name '
	 end
	 else
	 begin
		 set @where =@where +' and '+ @tabName+'.Name = tabAll.Name '
	 end
	 end
	 
fetch next from cur into @StoreID
end
close cur
deallocate cur

set @sql=@tabStr+@sql+@sqlStr+@where
--select @sql
exec sp_executesql @sql
GO
