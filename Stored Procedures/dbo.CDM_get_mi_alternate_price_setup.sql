SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create PROCEDURE [dbo].[CDM_get_mi_alternate_price_setup] 

@miID nvarchar(20),
@allDay varchar(1)

AS

--retrieve menu items with alternate price

/*SELECT * FROM tblMENU_ITEM_ALTERNATE_PRICING with(nolock)
	WHERE all_day_price = @allDay
		and menu_itemID  = @miID

*/
/*SELECT distinct(alternate_price)  FROM tblMENU_ITEM_ALTERNATE_PRICING with(nolock)
	WHERE all_day_price = @allDay
		and menu_itemID  = @miID
*/

--9/8/06FIX TO BE ABLE TO PULL RECORDS WITH THE SAME PRICE ON DIFFERENT DAYS WITH THE SAME BEGIN TIME TO DISPLAY PROPERLY
--E.G.
--MON - 1.50 FROM 2:00PM TO 6:00PM
--TUE -  1.50 FROM 2:00PM TO 3:00PM

/*SELECT distinct(alternate_price), EFFECTIVE_BEGIN_TIME 
	FROM tblMENU_ITEM_ALTERNATE_PRICING with(nolock)
	WHERE all_day_price = @allDay
		and menu_itemID  = @miID
		GROUP BY EFFECTIVE_BEGIN_TIME, ALTERNATE_PRICE
*/

--9/8/06fix below bug25
SELECT alternate_price, EFFECTIVE_BEGIN_TIME , effective_end_time
	FROM CDM_tblMENU_ITEM_ALTERNATE_PRICING with(nolock)
	WHERE all_day_price = @allDay
		and menu_itemID  = @miID
		GROUP BY EFFECTIVE_BEGIN_TIME, EFFECTIVE_END_TIME, ALTERNATE_PRICE

return @@error
GO
