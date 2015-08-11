SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Rpt_GetGoogleChartDataAllStoreByDay]
(
	@BeginDate datetime,
	@EndDate datetime,
	@storeID nvarchar(200)
)
as

declare @Businessday datetime
declare @InnerstoreID int
if charindex(',',@storeid)>0
begin
	select top 1 @InnerstoreID =Storeid  from StoreSetting 
	 order by BusinessHourOpen desc
end
else
begin
	set @InnerstoreID=CAST (@storeID as integer)
end
select @Businessday=dbo.fnBusinessDate(@BeginDate,@InnerstoreID)

execute [Rpt_D_SalesByStoreByDay] @Businessday,@Businessday,@storeID,1 --GorssSales
execute [Rpt_D_SalesByStoreByDay] @Businessday,@Businessday,@storeID,2 --NetSales
execute [Rpt_D_VoidByStoreByDay] @Businessday,@Businessday,@storeID --void
execute [Rpt_D_CompByStoreByDay] @Businessday,@Businessday,@storeID --Comp
execute [Rpt_D_DiscountByStoreByDay] @Businessday,@Businessday,@storeID --Discount
execute [Rpt_D_NumGuestSummaryByStoreByDay] @Businessday,@Businessday,@storeID --NumGuest
execute [Rpt_D_NumTableSummaryByStoreByDay] @Businessday,@Businessday,@storeID --NumTable
execute [Rpt_D_LaborSummaryByStoreByDay] @Businessday,@Businessday,@storeID --Labor
execute [Rpt_D_LaborPercentByStoreByDay] @Businessday,@Businessday,@storeID --LaborPercent
GO
