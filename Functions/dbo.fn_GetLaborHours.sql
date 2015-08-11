SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE function [dbo].[fn_GetLaborHours]
(
	@StoreID int,
	@EmployeeId int,
	@MealPeriodName varchar(20),
	@businessDate datetime,
	@TimeIn datetime
)
returns decimal(10,3)
as
begin
declare @MealPeriodBegin datetime
declare @MealPeriodEnd datetime
declare @EmpBeginTime datetime
declare @EmpEndTime datetime
declare @LaborHours decimal(20,2)
select @MealPeriodBegin=beginTime,@MealPeriodEnd=EndTime from MealPeriod
where StoreID=@StoreID and Name=@MealPeriodName

select @EmpBeginTime=TimeIn,@EmpEndTime=Timeout from EmployeeTimeSheet
where StoreID=@StoreID and EmployeeID=@EmployeeId and BusinessDate=@businessDate
and timeIn =@timeIn

set @MealPeriodBegin=convert(datetime,convert(varchar(10),@EmpBeginTime,120)+' '+convert(VARCHAR(8),@MealPeriodBegin,108))
if datepart(hh,@MealPeriodBegin)>datepart(hh,@MealPeriodEnd)
begin
	set @MealPeriodEnd=convert(datetime,convert(varchar(10),dateadd(day,1,@EmpBeginTime),120)+' '+convert(VARCHAR(8),@MealPeriodEnd,108))
end
else
begin
	set @MealPeriodEnd=convert(datetime,convert(varchar(10),@EmpBeginTime,120)+' '+convert(VARCHAR(8),@MealPeriodEnd,108))
end

if @MealPeriodBegin>=@EmpBeginTime and  @EmpEndTime<=@MealPeriodEnd and @EmpEndTime>=@MealPeriodBegin
begin
	 return convert(decimal(10,2),datediff(mi,@MealPeriodBegin ,@EmpEndTime))/60.0
			
end
else if @MealPeriodBegin<=@EmpBeginTime and @EmpEndTime<=@MealPeriodEnd
begin
	return convert(decimal(10,2),datediff(mi,@EmpBeginTime ,@EmpEndTime))/60
end
else if  @MealPeriodBegin<=@EmpBeginTime and @EmpEndTime>=@MealPeriodEnd and @empBeginTime <= @MealPeriodEnd
begin
	return convert(decimal(10,2),datediff(mi,@EmpBeginTime ,@MealPeriodEnd))/60
end
else
begin
	return 0.0
end
 --return @LaborHours
return 0.0
end
GO
