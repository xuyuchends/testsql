SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[MealPeriod_InUpDel_]
@SQLOperationType nvarchar(50),
@StoreID  nvarchar(200),
@ID int,
@Name nvarchar(50),
@BeginTime nvarchar(50),
@Endtime nvarchar(50),
@DayofWeek nvarchar(50),
@UpdateTime  datetime,
@updateOpType nvarchar(50)
AS
BEGIN
	SET NOCOUNT ON;
	if @SQLOperationType='SQLGetID'
	begin
		return select MAX([ID]) from MealPeriod where [StoreID] = @StoreID
	end
	else if @SQLOperationType='SQLInsert'
	begin
		INSERT INTO MealPeriod
           ([StoreID],[Name],[BeginTime],[EndTime],[DayOfWeek],[LastUpdate])
		VALUES
           (@StoreID
           ,@Name
           ,@BeginTime
           ,@Endtime
           ,@DayofWeek
           ,@UpdateTime)
         select @@ERROR
	end
	else if @SQLOperationType='SQLUpdate'
	begin
		if @updateOpType='delete'
		begin
			delete from MealPeriod
			where [Name]=@Name
			select @@ERROR
		end 
		else if @updateOpType='insert'
		begin
			INSERT INTO MealPeriod
			   ([StoreID],[Name],[BeginTime],[EndTime],[DayOfWeek],[LastUpdate])
			VALUES
			   (@StoreID
			   ,@Name
			   ,@BeginTime
			   ,@Endtime
			   ,@DayofWeek
			   ,@UpdateTime)
			   select @@ERROR
		end
	end
	else if @SQLOperationType='SQLDelete'
	begin
		declare @sql nvarchar(200)
		set @sql=' delete from MealPeriod
		where [Name]='''+@Name+''' and StoreID in ('+@StoreID+')'
		execute sp_executesql @sql
		select @@ERROR
	end
END
GO
