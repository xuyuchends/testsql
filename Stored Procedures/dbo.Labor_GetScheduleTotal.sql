SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
 CREATE proc [dbo].[Labor_GetScheduleTotal]
 @ScheduleID int,
 @Weekly datetime,
 @Mode int
 as
 begin
 if(@Mode = 0)
 begin
 			select  DATEPART(WEEKDAY,BeginTime) as 'WEEK',
					SUM(distinct DATEDIFF(MI, LunchBeginTime,LunchEndTime)*1.0/60*job.Wage)as 'LunchTotal',
					SUM(distinct DATEDIFF(MI, LunchBeginTime,LunchEndTime)*1.0/60)as 'LunchTotalHrs',
					SUM(distinct DATEDIFF(MI,DinnerBeginTime,DinnerEndTime)*1.0/60*job.Wage)as 'DinnerTotal',
					SUM(distinct DATEDIFF(MI,DinnerBeginTime,DinnerEndTime)*1.0/60)as 'DinnerTotalHrs',
					SUM(distinct DATEDIFF(MI,BeginTime,EndTime)*1.0/60*job.Wage)as 'Total',
					SUM(distinct DATEDIFF(MI,BeginTime,EndTime)*1.0/60) as 'TotalHrs'
			from LaborScheduleShiftDetail as detail
				 join LaborScheduleShift as shift on shift.ID = detail.ShiftID
				 join EmployeeJob as job on job.ID = shift.JobID 
			where shift.ScheduleID = @ScheduleID and shift.Weekly=@Weekly
			group by  DATEPART(WEEKDAY,BeginTime)
			order by DATEPART(WEEKDAY,BeginTime)
 end
 else if(@Mode = 1)
 begin
 			select  DATEPART(WEEKDAY,BeginTime) as 'WEEK',
					SUM(distinct DATEDIFF(MI, LunchBeginTime,LunchEndTime)*1.0/60*job.Wage)as 'LunchTotal',
					SUM(distinct DATEDIFF(MI, LunchBeginTime,LunchEndTime)*1.0/60)as 'LunchTotalHrs',
					SUM(distinct DATEDIFF(MI,DinnerBeginTime,DinnerEndTime)*1.0/60*job.Wage)as 'DinnerTotal',
					SUM(distinct DATEDIFF(MI,DinnerBeginTime,DinnerEndTime)*1.0/60)as 'DinnerTotalHrs',
					SUM(distinct DATEDIFF(MI,BeginTime,EndTime)*1.0/60*job.Wage)as 'Total',
					SUM(distinct DATEDIFF(MI,BeginTime,EndTime)*1.0/60) as 'TotalHrs'
			from LaborScheduleShiftDetail as detail
				 join LaborScheduleShift as shift on shift.ID = detail.ShiftID
				 join EmployeeJob as job on job.ID = shift.JobID 
			where shift.ScheduleID = @ScheduleID
			group by  DATEPART(WEEKDAY,BeginTime)
			order by DATEPART(WEEKDAY,BeginTime)
 end
 end
 
 
 
 
GO
