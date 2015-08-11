SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[TranInsUpd_Order]
@StoreID   int,
@ID   bigint,
@OpenTime   datetime,
@CloseTime   datetime,
@EmpIDOpen   int,
@EmpIDClose   int,
@TableName   nvarchar (50),
@GuestCount   int,
@RevenueCenter  nvarchar (50),
@MealPeriod   nvarchar (50),
@FutureOrder char(1),
@BusinessDate   datetime,
@status nvarchar (50)
AS
begin try
    INSERT INTO [Order] (StoreID,ID,OpenTime,CloseTime,EmpIDOpen,
		EmpIDClose,TableName,GuestCount,RevenueCenter,MealPeriod,FutureOrder,
		BusinessDate,LastUpdate,Status)
	VALUES (@StoreID,@ID,@OpenTime,@CloseTime,@EmpIDOpen,
		@EmpIDClose,@TableName,@GuestCount,@RevenueCenter,@MealPeriod,@FutureOrder,
		@BusinessDate,getDate(),@status)    
END TRY
BEGIN CATCH
	if @@ERROR <>0
		UPDATE [Order] SET OpenTime=@OpenTime,CloseTime=@CloseTime,EmpIDOpen=@EmpIDOpen,EmpIDClose=@EmpIDClose,
		TableName=@TableName,GuestCount=@GuestCount,RevenueCenter=@RevenueCenter,MealPeriod=@MealPeriod,
		FutureOrder=@FutureOrder,
		BusinessDate=@BusinessDate,LastUpdate=getDate(),Status=@status
		where StoreID=@StoreID and ID=@id and BusinessDate=@BusinessDate
end  CATCH

GO
