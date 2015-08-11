SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE proc [dbo].[TranInsUpd_StoreSetting]
	@StoreID int,
	@PercentWithheldTips real,
	@DriverRoutingInstalled char(1),
	@surcharge_guest_pays char(1),
	@OTWorkweekThreshold int,
	@OTHoursType int,
	@BusinessHourOpen datetime
as
begin
--UPDATE [StoreSetting]
--   SET 
--      [PercentWithheldTips] = @PercentWithheldTips
--      ,[DriverRoutingInstalled] = @DriverRoutingInstalled
--      ,[SurchargeGuestPays] = @surcharge_guest_pays
--      ,[OTWorkweekThreshold] = @OTWorkweekThreshold
--      ,[LastUpdate] = GETDATE()
--      ,OTHoursType =@OTHoursType
-- WHERE [StoreID] = @StoreID
 
-- if(@@ROWCOUNT=0)
--	begin
		INSERT INTO [StoreSetting]
           ([StoreID]
           ,[PercentWithheldTips]
           ,[DriverRoutingInstalled]
           ,[SurchargeGuestPays]
           ,[OTWorkweekThreshold]
           ,[LastUpdate]
           ,OTHoursType
           ,BusinessHourOpen)
     VALUES
           (@StoreID
           ,@PercentWithheldTips
           ,@DriverRoutingInstalled
           ,@surcharge_guest_pays
           ,@OTWorkweekThreshold
           ,GETDATE()
           ,@OTHoursType
           ,@BusinessHourOpen)

	--end
 end
GO
