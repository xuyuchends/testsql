SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create FUNCTION [dbo].[fnCalculateRegularHours] 
 
 (@empID int, 
 @positionID nvarchar(15),
 @beginPayPeriodDate datetime, 
 @endPayPeriodDate datetime,
 @hoursType varchar(3),
 @wage money,
 @storeID int)  
 
 RETURNS decimal(8,3)
 
 AS  
 
 BEGIN 
 	/*
 	HOW TO CALL:
 
 		select dbo.fnCalculateRegularHours(7831,'5/26/2006','6/8/2006','REG') as reg_hours, dbo.fnCalculateRegularHours(7831,'5/26/2006','6/8/2006','OT') AS OT_hours,
 		fname,sum(cash_tips_declared) as cash_tips_declared,
 		sum(charged_tips) as charged_tips 
 			from tblemployees A inner join tblemployee_timesheets b on a.empid = b.empid
 			where a.empid = 7831
 		group by fname
 
 	*/
 	
 	declare @numWeeks int
 	declare @tmpBegin datetime
 	declare @tmpEnd datetime
 	declare @reg_hours decimal(8,3)
 	declare @ot_hours decimal(8,3)
 	declare @i int
 	declare @otWorkweekThreshold int
	select top 1  @otWorkweekThreshold =OTWorkweekThreshold from StoreSetting where storeid=@storeID
	
 	set @numWeeks = datediff(wk,@beginPayPeriodDate,@endPayPeriodDate)
 
 	set @i = 1
 
 	set @tmpBegin = @beginPayPeriodDate
 	set @tmpEnd = dateadd(dd,6, @tmpBegin)
 	set @reg_hours = 0
 	set @ot_hours = 0	
 	while @i <= @numWeeks
 		begin
 
			SELECT @reg_hours = @reg_hours + ISNULL(case when Convert(decimal,sum(datediff(MINUTE,t.TimeIn , t.TimeOut)))/60 > @otWorkweekThreshold then @otWorkweekThreshold else round(convert(decimal,sum((datediff(MINUTE,t.TimeIn, t.TimeOut))))/60,2) end,0),
					@ot_hours = @ot_hours + ISNULL(case when convert(decimal,sum((datediff(MINUTE,t.TimeIn, t.TimeOut))))/60 > (@otWorkweekThreshold) then (round(convert(decimal,sum((datediff(MINUTE,t.TimeIn, t.TimeOut)))) - (@otWorkweekThreshold * 60),2))/60 else 0 end,0)
 				FROM EmployeeTimeSheet  as t
 					inner join Position as p on t.positionID = p.ID and t.StoreID=p.StoreID
 					inner join Employee as e on t.EmployeeID = e.ID and e.StoreID=p.StoreID
 				where  t.BusinessDate>= @tmpBegin
 					and t.BusinessDate <= @tmpEnd
 					and e.HasPayrollReport =1
 					and e.ID = @empID
 					and t.positionID = @positionID
 					and t.PayRate = @wage
 					and t.StoreID=@storeID
 				group by t.positionid, 
 					t.EmployeeID, 
 					t.PayRate , 
 					p.id
 
 			set @tmpBegin = dateadd(wk,1, @tmpBegin)
 			set @tmpEnd = dateadd(dd,6, @tmpBegin)
 		
 			set @i = @i+1
 		end
 
 	declare @wrkHours decimal(8,3)
 
 	if UPPER(@hoursType) = 'REG'
 		set @wrkHours  = @reg_hours
 	else
 		set @wrkHours = @ot_hours
 
 	RETURN @wrkHours
 
 END
 
 


GO
