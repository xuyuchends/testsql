SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[CDM_get_menu_items] @filter nvarchar(25), @value nvarchar(25) AS

declare @searchby nvarchar(30)

if @filter = 'SEARCHBYNAME'
	begin
		set @searchby = '%' + @value + '%'
		select item, abbreviated_name, item_id, [section] 
			from CDM_tblmenu_items with(nolock)
			where (item like @searchby or abbreviated_name like @searchBy)
				and show_button <>  'N'
				and deleted = 'N'
			order by abbreviated_name
	end
if @filter = 'SEARCHBY_MENULINK'	
	select item, abbreviated_name, item_id, [section] 
		from CDM_tblmenu_items with(nolock)
		where category = @value
			and show_button <> 'N'
			and deleted = 'N'
		order by abbreviated_name
	
if @filter = 'SEARCHBY_SALE_CATEGORY'	
	select item, abbreviated_name, item_id, [section] 
		from CDM_tblmenu_items with(nolock)
		where mi_sale_rpt_category = @value
			and show_button <> 'N'
			and deleted = 'N'
		order by abbreviated_name

if @filter = 'ALL'
	select item, abbreviated_name, item_id, [section] 
		from CDM_tblmenu_items with(nolock)
		where show_button <> 'N'
			and deleted = 'N'
		order by abbreviated_name
GO
