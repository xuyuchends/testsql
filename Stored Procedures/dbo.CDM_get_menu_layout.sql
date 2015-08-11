SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[CDM_get_menu_layout] @menuGroup nvarchar(20), @menuLink nvarchar(20) AS

IF @menuGroup = 'HOT_ITEM'
	begin

		select   top 12 abbreviated_name, item_id,Hot_Item,isnull(Hot_Item_Display_Seq,0) as Hot_Item_Display_Seq
		from CDM_tblmenu_items with(nolock)
		where hot_item = 'Y' and Item<>'BLANK'
			and deleted='N' --and  Hot_Item_Display_Seq<>null 
		order by hot_item_display_seq, abbreviated_name

		return @@Error

	end

select    abbreviated_name, item_id,show_button,display_sequence
	from CDM_tblmenu_items with(nolock)
	where [section] = @menuGroup and  category = @menuLink and deleted='N'
	order by display_sequence, abbreviated_name

return @@error
GO
