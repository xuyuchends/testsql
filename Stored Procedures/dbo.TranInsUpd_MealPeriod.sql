SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[TranInsUpd_MealPeriod]
	@StoreID [int],
	@ID [int],
	@Name [nvarchar](50),
	@BeginTime [datetime],
	@EndTime [datetime],
	@DayOfWeek [nvarchar](50),
	@Sequence int
WITH EXECUTE AS CALLER
AS
BEGIN
 --UPDATE MealPeriod SET Name = @Name, BeginTime=@BeginTime,EndTime=@EndTime,[DayOfWeek]=@DayOfWeek, 
 --LastUpdate = getDate()
 --WHERE StoreID = @StoreID and ID = @ID
 --if(@@rowcount=0)
 INSERT INTO MealPeriod (StoreID,Name,BeginTime,EndTime,[DayOfWeek],Sequence,LastUpdate) 
 VALUES( @StoreID,@name,@BeginTime,@EndTime,'SUNDAY',@Sequence, getDate())
 INSERT INTO MealPeriod (StoreID,Name,BeginTime,EndTime,[DayOfWeek],Sequence,LastUpdate) 
 VALUES( @StoreID,@name,@BeginTime,@EndTime,'MONDAY',@Sequence, getDate())
 INSERT INTO MealPeriod (StoreID,Name,BeginTime,EndTime,[DayOfWeek],Sequence,LastUpdate) 
 VALUES( @StoreID,@name,@BeginTime,@EndTime,'TUESDAY',@Sequence, getDate())
 INSERT INTO MealPeriod (StoreID,Name,BeginTime,EndTime,[DayOfWeek],Sequence,LastUpdate) 
 VALUES( @StoreID,@name,@BeginTime,@EndTime,'WEDNESDAY',@Sequence, getDate())
 INSERT INTO MealPeriod (StoreID,Name,BeginTime,EndTime,[DayOfWeek],Sequence,LastUpdate) 
 VALUES( @StoreID,@name,@BeginTime,@EndTime,'THURSDAY',@Sequence, getDate())
 INSERT INTO MealPeriod (StoreID,Name,BeginTime,EndTime,[DayOfWeek],Sequence,LastUpdate) 
 VALUES( @StoreID,@name,@BeginTime,@EndTime,'FRIDAY',@Sequence, getDate())
 INSERT INTO MealPeriod (StoreID,Name,BeginTime,EndTime,[DayOfWeek],Sequence,LastUpdate) 
 VALUES( @StoreID,@name,@BeginTime,@EndTime,'SATURDAY',@Sequence, getDate())
END
GO
