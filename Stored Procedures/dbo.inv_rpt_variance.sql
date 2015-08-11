SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[inv_rpt_variance]
	@BeginTime [datetime],
	@endTime [datetime],
	@StoreID [nvarchar](200),
	@ItemID [int]
WITH EXECUTE AS CALLER
AS
if @ItemID=0
begin

select s.StoreName,s.id StoreID, ic1.Name+'/'+ic.Name Category ,item.ID ItemID,item.Description ItemName,
isnull((select UnitOnHand from inv_itemtostoreArchive where ItemID=item.ID and StoreID=s.ID and BusinessDate=dateadd(day,-1,@BeginTime)),0) BegInv,
isnull((select sum(Qty*itv.StockPerOrder) from Inv_Invoice i inner join Inv_InvoiceDetail id on i.ID=id.InvoiceID and id.InvItemID = item.ID  
inner join Inv_ItemToVendor as itv on i.vendorid=itv.VendorID and itv.ItemID=item.ID 
where CONVERT(datetime, CONVERT(nvarchar(20), i.InvoiceDate,101)) between @BeginTime and @endTime and i.storeid=s.ID),0) UnitsPurchased,
isnull((select UnitOnHand from inv_itemtostoreArchive where ItemID=item.ID and StoreID=s.ID and BusinessDate=@endTime),0) EndInv,
(select CONVERT(decimal(18,2) ,isnull(sum(iu.Usage/itv.ReceipePerStock),0))  from Inv_ItemUsages  as iu inner join
 (select top 1 * from Inv_Invoice i inner join Inv_InvoiceDetail id on i.ID=id.InvoiceID
where id.InvItemID=item.ID order by  LastUpdate desc) a on a.InvItemID=iu.InvItemID
 inner join Inv_ItemToVendor itv on itv.VendorID=a.vendorid and  iu.InvItemID=itv.ItemID
where iu.InvItemID=item.ID and iu.StoreID=s.ID and BusinessDate between @BeginTime and @endTime) Usage,
isnull((select TOH-CountQOH as CountVariance
from Inv_ItemCount countH join Inv_ItemCountDetail countD
on countH.CountID = countD.CountID 
Where WeekEnding between @BeginTime and @endTime and countD.ItemID=item.ID and countH.StoreID=s.ID ),0) CountVariance
from inv_item item inner join Inv_ItemCategory ic on item.CategoryID=ic.ID
inner join Inv_ItemCategory ic1 on ic1.ID=ic.ParentID
inner join Store s on s.ID in (select * from dbo.f_split(@StoreID,','))
group by s.StoreName,s.id,ic.ID,ic1.Name+'/'+ic.Name,item.ID,item.Description 
end
else
begin

	select s.StoreName,s.id StoreID, ic1.Name+'/'+ic.Name Category ,item.ID ItemID,item.Description ItemName,
isnull((select UnitOnHand from inv_itemtostoreArchive where ItemID=item.ID and StoreID=s.ID and BusinessDate=dateadd(day,-1,@BeginTime)),0) BegInv,
isnull((select sum(Qty*itv.StockPerOrder) from Inv_Invoice i inner join Inv_InvoiceDetail id on i.ID=id.InvoiceID and id.InvItemID = item.ID  
inner join Inv_ItemToVendor as itv on i.vendorid=itv.VendorID and itv.ItemID=item.ID
where CONVERT(datetime, CONVERT(nvarchar(20), i.InvoiceDate,101)) between @BeginTime and @endTime and i.storeid=s.ID),0) UnitsPurchased,
isnull((select UnitOnHand from inv_itemtostoreArchive where ItemID=item.ID and StoreID=s.ID and BusinessDate=@endTime),0) EndInv,
(select CONVERT(decimal(18,2) ,isnull(sum(iu.Usage/itv.ReceipePerStock),0))  from Inv_ItemUsages  as iu inner join
 (select top 1 * from Inv_Invoice i inner join Inv_InvoiceDetail id on i.ID=id.InvoiceID
where id.InvItemID=item.ID order by  LastUpdate desc) a on a.InvItemID=iu.InvItemID
 inner join Inv_ItemToVendor itv on itv.VendorID=a.vendorid and  iu.InvItemID=itv.ItemID
where iu.InvItemID=item.ID and iu.StoreID=s.ID and BusinessDate between @BeginTime and @endTime) Usage,
isnull((select TOH-CountQOH as CountVariance
from Inv_ItemCount countH join Inv_ItemCountDetail countD
on countH.CountID = countD.CountID 
Where WeekEnding between @BeginTime and @endTime and countD.ItemID=item.ID and countH.StoreID=s.ID ),0) CountVariance
 from inv_item item inner join Inv_ItemCategory ic on item.CategoryID=ic.ID
inner join Inv_ItemCategory ic1 on ic1.ID=ic.ParentID
inner join Store s on s.ID in (select * from dbo.f_split(@StoreID,',')) where item.ID=@ItemID
group by s.StoreName,s.id,ic.ID,ic1.Name+'/'+ic.Name,item.ID,item.Description 
end
GO
