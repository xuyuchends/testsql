SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


create PROCEDURE [dbo].[TranInsUpd2_Order]
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

    INSERT INTO [Order] (StoreID,ID,OpenTime,CloseTime,EmpIDOpen,
		EmpIDClose,TableName,GuestCount,RevenueCenter,MealPeriod,FutureOrder,
		BusinessDate,LastUpdate,Status)
	VALUES (@StoreID,@ID,@OpenTime,@CloseTime,@EmpIDOpen,
		@EmpIDClose,@TableName,@GuestCount,@RevenueCenter,@MealPeriod,@FutureOrder,
		@BusinessDate,getDate(),@status)    
GO
