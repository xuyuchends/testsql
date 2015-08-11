SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Inv_Items_sel]
(
	@id int,
	@Description nvarchar(200),
	@CategoryID int,
	@CountPeriod int,
	@PrepItem bit,
	@AlertQty int,
	@PreferredVendorID int,
	@IsActive bit,
	@Creator int,
	@Editor int
)
as
declare @sql nvarchar(max)
declare @sqlWhere nvarchar(max)
set @sqlWhere=''
if ISNULL(@id,0)<>0
begin
	set @sqlWhere=@sqlWhere+' and i.id='+CONVERT(nvarchar(20),@id)
end
set @sql='SELECT i.[ID],[Description],[RefNum],[CategoryID],[HotItem],[RecipeUnitID],[InitialCost],[CountPeriod],[UPC],[WastePercent],[PrepItem],uom1.Name CountUnitName
     ,[AlertQty],[PreferredVendorID],[IsActive],i.[LastUpdate],i.[Creator],i.[Editor],uom.name as UnitName,CountUnitID FROM Inv_Item i inner join Inv_UnitOfMeasures uom on i.[RecipeUnitID]=uom.id
     inner join Inv_UnitOfMeasures uom1 on i.CountUnitID =uom1.ID where isActive=1'+@sqlWhere
     
 exec sp_executesql @sql
      
GO
