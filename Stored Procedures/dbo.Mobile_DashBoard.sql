SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Mobile_DashBoard] 
	-- Add the parameters for the stored procedure here
	@StoreID int,
	@BeginTime datetime,
	@EndTime datetime,
	@Count int ,--select Store count
	@Type nvarchar(20)  --OneStore,MultiStores
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	if ISNULL(@Type,'')='OneStore'
	begin
		select StoreID, s.StoreName ,CAST(sum(GrossSales) as decimal) GrossSales
		,CAST(SUM (GrossSales-voids-Comps-Discount) as decimal) NetSales 
		,(select CAST(SUM(Total) as decimal) from DailyAdjustmentSummary where StoreID=ds.StoreID and BusinessDate between @BeginTime and @EndTime and AdjustType='VOID') Voids
		,(select CAST(SUM(Total) as decimal) from DailyAdjustmentSummary where StoreID=ds.StoreID and BusinessDate between @BeginTime and @EndTime and AdjustType='COMP') Comps
		,(select CAST(SUM(Total) as decimal) from DailyAdjustmentSummary where StoreID=ds.StoreID and BusinessDate between @BeginTime and @EndTime and AdjustType='DISCOUNT') Discounts,
		(select CAST(SUM(NumGuest) as decimal) from DailyGuestTableSummaryByPC where StoreID=ds.StoreID and BusinessDate between @BeginTime and @EndTime) TotalGuest
		from DailyDepartmentSales ds inner join Store s on s.ID=ds.StoreID 
		where StoreID=@StoreID and BusinessDate between @BeginTime and @EndTime
		group by s.StoreName,StoreID
	end
	else if ISNULL(@Type,'')='MultiStores'
	begin
		select StoreID, s.StoreName ,CAST(sum(GrossSales) as decimal) GrossSales
		,CAST(SUM (GrossSales-voids-Comps-Discount) as decimal) NetSales 
				,(select CAST(SUM(Total) as decimal) from DailyAdjustmentSummary where StoreID=ds.StoreID and BusinessDate between @BeginTime and @EndTime and AdjustType='VOID') Voids
		,(select CAST(SUM(Total) as decimal) from DailyAdjustmentSummary where StoreID=ds.StoreID and BusinessDate between @BeginTime and @EndTime and AdjustType='COMP') Comps
		,(select CAST(SUM(Total) as decimal) from DailyAdjustmentSummary where StoreID=ds.StoreID and BusinessDate between @BeginTime and @EndTime and AdjustType='DISCOUNT') Discounts,
		(select CAST(SUM(NumGuest) as decimal) from DailyGuestTableSummaryByPC where StoreID=ds.StoreID and BusinessDate between @BeginTime and @EndTime) TotalGuest
		from DailyDepartmentSales ds inner join Store s on s.ID=ds.StoreID 
		 where StoreID in (select top (@Count) id from Store order by id) 
		 and BusinessDate between @BeginTime and @EndTime
		 group by s.StoreName,StoreID
	end
END
GO
