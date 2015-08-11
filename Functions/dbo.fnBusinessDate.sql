SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [dbo].[fnBusinessDate] 
(
	-- Add the parameters for the function here
	@currentDate datetime,
	@storeID int
)
RETURNS datetime
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result datetime
	DECLARE @bOpen nvarchar(30)
	Declare @baseDate datetime
	Declare @NextDate datetime
	Declare @PreviousDate datetime
	
	
	-- Add the T-SQL statements to compute the return value here
	SELECT @bOpen =  CONVERT(VARCHAR(8), BusinessHourOpen, 108)
			from StoreSetting where StoreID=@storeID
	
	if isnull(@bOpen,'')=''
	begin
		set @bOpen='07:00:00'
	end
	
	set @bOpen = CONVERT(VARCHAR(10), @currentDate, 101) + ' ' + @bOpen

	set @baseDate = CONVERT(VARCHAR(19), @bOpen, 120)
	set @NextDate = dateadd(day,1,@baseDate)
	set @PreviousDate = dateadd(day,-1,@baseDate)
	
	--print @baseDate
	--print @NextDate
	--print @PreviousDate

	if (@currentDate between @baseDate and @NextDate)
		set @result = CONVERT(VARCHAR(10), @baseDate, 101)
	else
		set @result = CONVERT(VARCHAR(10), @PreviousDate, 101)
	-- Return the result of the function
	RETURN @Result

END
GO
