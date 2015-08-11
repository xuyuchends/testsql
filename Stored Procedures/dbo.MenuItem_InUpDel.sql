SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[MenuItem_InUpDel]
(
	@StoreID nvarchar(200),
	@MenuItemNameOld nvarchar(50),
	@menuCategoryOld nvarchar(50),
	@MenuDepartmentOld nvarchar(50),
	@MenuItemName nvarchar(50),
	@MenuCategory nvarchar(50),
	@MenuDepartment nvarchar(50),
	@SQLOperationType nvarchar(50)
)
as
declare @sql nvarchar(max)
if @SQLOperationType='SQLUpdate'
begin
	set @sql='update MenuItem set ReportName='''+@MenuItemName+''',
						ReportCategory='''+@MenuCategory+''',
						ReportDepartment='''+@MenuDepartment+''' 
						where Name='''+@MenuItemNameOld+'''
						and StoreID in ('+@StoreID+')  and Category='''+@menuCategoryOld+'''
						 and Department='''+@MenuDepartmentOld+''''
		--				select @sql
		execute sp_executesql @sql
		select @@ERROR
					end
GO
