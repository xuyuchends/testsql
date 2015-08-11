SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[CDM_get_mi_price_effective_days]

@miID varchar(20),
@price money,
@allDay varchar(1),
@beginTime varchar(30),
@endtime varchar(30) --9/8/06fix bug25

 AS

if @allDay = 'Y' 
	select * from CDM_tblmenu_item_alternate_pricing with(nolock)
	where menu_itemID = @miID
		and alternate_price = @price
		and all_day_price = @allDay
else

	select * from CDM_tblmenu_item_alternate_pricing with(nolock)
		where menu_itemID = @miID
			and alternate_price = @price
			and all_day_price = @allDay
			and effective_begin_time = @beginTime
			and effective_end_time = @endtime --9/8/06fixbug25

return @@error
GO
