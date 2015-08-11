SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[LaborScheduleGetEmailAddressByID]
(
	@ScheduleID int,
	@weekly datetime,
	@StoreID int
)
as
select distinct eu.id,eu.Email,'Email' as [Type],dbo.[fn_GetTimeByShiftID](lss.id) TimePeriod
 from LaborScheduleShift lss
inner join EmployeeJob ej on lss.JobID=ej.ID and lss.StoreID=ej.StoreID
inner join EnterpriseUser eu on ej.StoreID=eu.StoreID and ej.EmployeeID=eu.EmployeeID
 where ScheduleID=@ScheduleID and Weekly=@weekly and lss.StoreID=@StoreID
 and (select COUNT(*) from LaborScheduleShiftDetail where ShiftID=lss.ID)>0
 and eu.SendEmailWhen & 2=2 and isnull(eu.Email,'')<>''
 
 union 
 select distinct eu.id, case when MobileCarrier=1 
			then MobilePhone+(select Describe from ConstTable where Category='MobileCarrier' and ID=1) 
			when MobileCarrier=2 
			then MobilePhone+(select Describe from ConstTable where Category='MobileCarrier' and ID=2) 
			when MobileCarrier=3 
			then MobilePhone+(select Describe from ConstTable where Category='MobileCarrier' and ID=3)
			when MobileCarrier=4 
			then MobilePhone+(select Describe from ConstTable where Category='MobileCarrier' and ID=4) end,
			'Mobile' as [Type] ,dbo.[fn_GetTimeByShiftID](lss.id) TimePeriod from LaborScheduleShift lss
inner join EmployeeJob ej on lss.JobID=ej.ID and lss.StoreID=ej.StoreID
inner join EnterpriseUser eu on ej.StoreID=eu.StoreID and ej.EmployeeID=eu.EmployeeID
 where ScheduleID=@ScheduleID and Weekly=@weekly and lss.StoreID=@StoreID
 and (select COUNT(*) from LaborScheduleShiftDetail where ShiftID=lss.ID)>0
 and SendMessageWhen & 2=2 and isnull(MobilePhone,'')<>''

GO
