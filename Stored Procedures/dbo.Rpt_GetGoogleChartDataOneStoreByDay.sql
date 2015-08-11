SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE proc [dbo].[Rpt_GetGoogleChartDataOneStoreByDay]
(
	@BeginDate datetime,
	@EndDate datetime,
	@storeID int
)
as
--declare @TimePeriodEnd datetime
--select @TimePeriodEnd=dbo.[fn_GetDashboardTimePeriod](@storeID)
--if CONVERT(datetime, CONVERT(nvarchar(20), GETDATE(),102))<=GETDATE() and getdate()<=CONVERT(datetime, CONVERT(nvarchar(20), GETDATE(),102))+@TimePeriodEnd
--begin
--	set @BeginDate=CONVERT(datetime, CONVERT(nvarchar(20),DATEADD(day,-1,getdate()),102))
--	set @EndDate=CONVERT(datetime, CONVERT(nvarchar(20),DATEADD(day,-1,getdate()),102))
--end
--else
--begin
--	set @BeginDate=CONVERT(datetime, CONVERT(nvarchar(20),getdate(),102))
--	set @EndDate=CONVERT(datetime, CONVERT(nvarchar(20),getdate(),102))
--end
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

execute [Rpt_D_GorssSalesByDepartmentByDay] @Businessday,@Businessday,@storeID --GorssSales By Dept
execute [Rpt_D_GorssSalesByPeriodByDay] @Businessday,@Businessday,@storeID --GrossSales BY Period
execute [Rpt_D_GorssSalesByRcByDay] @Businessday,@Businessday,@storeID --GrossSales BY RevenueCenter
execute [Rpt_D_VoidCompDiscountByDay] @Businessday,@Businessday,@storeID --Void ,Comp,Discount
execute [Rpt_D_SalesByPaymentByDay] @Businessday,@Businessday,@storeID --Sales By PaymentType
execute [Rpt_D_NumberByPaymentByDay] @Businessday,@Businessday,@storeID --Number By PaymentType
execute [Rpt_D_NumGuestByPeriodByDay] @Businessday,@Businessday,@storeID --NumGuest By Period
execute [Rpt_D_NumTableByPeriodByDay] @Businessday,@Businessday,@storeID --NumTable By Period
execute [Rpt_D_NumGuestByRcByDay] @Businessday,@Businessday,@storeID --NumGuest By RevenueCenter
execute [Rpt_D_NumTableByRcByDay] @Businessday,@Businessday,@storeID --NumTable By RevenueCenter
execute [Rpt_D_LaborByPosition] @Businessday,@Businessday,@storeID --Labor BY Position
execute [Rpt_D_SalesByPosition] @Businessday,@Businessday,@storeID --Sales BY Position
execute [Rpt_D_LaborPercent] @Businessday,@Businessday,@storeID --LaborPercent BY Position

GO
