SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[sel_MenuItem]
(
	@storeID int,
	@CategoryName nvarchar(20)
)
as
if ISNULL(@storeID,0)=0
begin
	if ISNULL(@CategoryName,'')=''
	select distinct Department+'/'+Category Name,Department+'/'+Category ItemID
	,
	case when	(select COUNT(*) from MenuItem where Department=mi.Department and Category=mi.Category
	and isDouble=0
	and Name not in (select imi.Name from Inv_MenuItem imi inner join Inv_MenuItemCategory mic
	on imi.CategoryID=mic.ID where mic.Name=mi.Category and 
	(select Name from Inv_ItemGroup where ID=mic.GroupID)=mi.Department) )>0
	then 0 else 1 end IsImport 
	 from MenuItem mi where 
	mi.isDouble=0
	 order by Department+'/'+Category
	else
	begin
		select distinct Name,ID ItemID,
		case when	(select COUNT(*) from Inv_MenuItem imi inner join Inv_MenuItemCategory mic
	on imi.CategoryID=mic.ID where mic.Name=mi.Category and imi.Name=mi.Name and imi.isDouble=0 and
	(select Name from Inv_ItemGroup where ID=mic.GroupID)=mi.Department)>0 then 1 else 0 end IsImport,
	
		@CategoryName as CategoryName ,mi.Price,mi.DoubleItemID
		 from MenuItem mi where Department+'/'+Category=@CategoryName 
		 and mi.isDouble=0
		 order by Name
	end
end
else
begin
	if ISNULL(@CategoryName,'')=''
	begin
		select distinct Department+'/'+Category Name,Department+'/'+Category ItemID from MenuItem where StoreID=@storeID 
		and isDouble=0
	end
	else
	begin
		select distinct Name,ID ItemID from MenuItem where StoreID=@storeID and Department+'/'+Category=@CategoryName 
		and isDouble=0 Order By Name
	end
end

GO
