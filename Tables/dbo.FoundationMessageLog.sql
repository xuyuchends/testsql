CREATE TABLE [dbo].[FoundationMessageLog]
(
[StoreID] [int] NOT NULL,
[PreTime] [datetime] NOT NULL,
[LastTime] [datetime] NOT NULL,
[IsCalculating] [bit] NOT NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE TRIGGER [dbo].[MoveGoogleChartToOldTable]
   ON  [dbo].[FoundationMessageLog]
   AFTER INSERT,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	declare @IsCalculating bit=0
	declare @storeID int
	select @storeID=StoreID, @IsCalculating =IsCalculating from inserted
	if @IsCalculating=1
	begin
		delete GoogleChartGrossSalesByDeptOld where StoreID=@storeID
		insert into GoogleChartGrossSalesByDeptOld select * from GoogleChartGrossSalesByDept where StoreID=@storeID
		
		delete GoogleChartGrossSalesByPeriodAllOld where StoreID=@storeID
		insert into GoogleChartGrossSalesByPeriodAllOld select * from GoogleChartGrossSalesByPeriodAll where StoreID=@storeID
		
		delete GoogleChartGrossSalesByProfitCenterOld where StoreID=@storeID
		insert into GoogleChartGrossSalesByProfitCenterOld select * from GoogleChartGrossSalesByProfitCenter where StoreID=@storeID
		
		delete GoogleChartGuestSummaryByPeriodAllOld where StoreID=@storeID
		insert into GoogleChartGuestSummaryByPeriodAllOld select * from GoogleChartGuestSummaryByPeriodAll where StoreID=@storeID
		
		delete GoogleChartGuestSummaryByProfitCenterAllOld where StoreID=@storeID
		insert into GoogleChartGuestSummaryByProfitCenterAllOld select * from GoogleChartGuestSummaryByProfitCenterAll where StoreID=@storeID
		
		delete GoogleChartGuestSummaryByStoreAllOld where StoreID=@storeID
		insert into GoogleChartGuestSummaryByStoreAllOld select * from GoogleChartGuestSummaryByStoreAll where StoreID=@storeID
		
		delete GoogleChartNumberByPaymentTypeAllOld where StoreID=@storeID
		insert into GoogleChartNumberByPaymentTypeAllOld select * from GoogleChartNumberByPaymentTypeAll where StoreID=@storeID
		
		delete GoogleChartSaleByPaymentTypeAllOld where StoreID=@storeID
		insert into GoogleChartSaleByPaymentTypeAllOld select * from GoogleChartSaleByPaymentTypeAll where StoreID=@storeID
		
		delete GoogleChartSalesByStoreALLOld where StoreID=@storeID
		insert into GoogleChartSalesByStoreALLOld select * from GoogleChartSalesByStoreALL where StoreID=@storeID
		
		delete GoogleChartTableSummaryByPeriodAllOld where StoreID=@storeID
		insert into GoogleChartTableSummaryByPeriodAllOld select * from GoogleChartTableSummaryByPeriodAll where StoreID=@storeID
		
		delete GoogleChartTableSummaryByProfitCenterAllOld where StoreID=@storeID
		insert into GoogleChartTableSummaryByProfitCenterAllOld select * from GoogleChartTableSummaryByProfitCenterAll where StoreID=@storeID
		
		delete GoogleChartTableSummaryByStoreAllOld where StoreID=@storeID
		insert into GoogleChartTableSummaryByStoreAllOld select * from GoogleChartTableSummaryByStoreAll where StoreID=@storeID
		
		delete GoogleChartVoidCompDiscontOld where StoreID=@storeID
		insert into GoogleChartVoidCompDiscontOld select * from GoogleChartVoidCompDiscont where StoreID=@storeID
		
		delete GoogleChartLaborByStoreOld where StoreID=@storeID
		insert into GoogleChartLaborByStoreOld select * from GoogleChartLaborByStore where StoreID=@storeID
		
		delete GoogleChartLaborByPositionOld where StoreID=@storeID
		insert into GoogleChartLaborByPositionOld select * from GoogleChartLaborByPosition where StoreID=@storeID
	end
END
GO
ALTER TABLE [dbo].[FoundationMessageLog] ADD CONSTRAINT [PK_FoundationMessageLog] PRIMARY KEY CLUSTERED  ([StoreID]) ON [PRIMARY]
GO
