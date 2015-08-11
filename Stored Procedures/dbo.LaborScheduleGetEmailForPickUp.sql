SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[LaborScheduleGetEmailForPickUp]
(
	@UserID int,
	@ShiftDetailID int
)
as
declare @isManager int
declare @selEmployeeID int
declare @EmployeeID int
declare @GiveUpFrom int
declare @StoreID int
declare @JobID int
declare @PositionID int
select @isManager=IsManager,@selEmployeeID=EmployeeID,@StoreID=StoreID from EnterpriseUser where ID=@UserID
if ISNULL(@isManager,0)=1
begin
	select distinct eu.id,eu.Email,'Email' as [Type] from LaborScheduleShiftDetail lssd inner join LaborScheduleShift lss
	on lssd.ShiftID=lss.ID inner join EmployeeJob ej on ej.ID=lss.JobID and ej.StoreID=lss.StoreID
	inner join EnterpriseUser eu on eu.StoreID=ej.StoreID and eu.EmployeeID=ej.EmployeeID where lssd.ID=@ShiftDetailID 
	and eu.SendEmailWhen & 3=3 and isnull(eu.Email,'')<>'' and lss.StoreID=@StoreID
	union  
	select distinct eu.id,case when MobileCarrier=1 
			then MobilePhone+(select Describe from ConstTable where Category='MobileCarrier' and ID=1) 
			when MobileCarrier=2 
			then MobilePhone+(select Describe from ConstTable where Category='MobileCarrier' and ID=2) 
			when MobileCarrier=3 
			then MobilePhone+(select Describe from ConstTable where Category='MobileCarrier' and ID=3)
			when MobileCarrier=4 
			then MobilePhone+(select Describe from ConstTable where Category='MobileCarrier' and ID=4) end Email,'Mobile' as [Type] from LaborScheduleShiftDetail lssd inner join LaborScheduleShift lss
	on lssd.ShiftID=lss.ID inner join EmployeeJob ej on ej.ID=lss.JobID and ej.StoreID=lss.StoreID
	inner join EnterpriseUser eu on eu.StoreID=ej.StoreID and eu.EmployeeID=ej.EmployeeID where lssd.ID=@ShiftDetailID 
	and eu.SendMessageWhen & 3=3	and isnull(MobilePhone,'')<>'' and lss.StoreID=@StoreID
	union 
	select distinct eu.id,eu.Email,'Email' as [Type] from 	LaborScheduleShiftDetail lssd
	inner join LaborScheduleShift lss on lssd.ShiftID=lss.ID
	inner join EmployeeJob ej on ej.StoreID=lss.StoreID and lssd.GiveUpFrom=ej.ID
	 inner join EnterpriseUser eu on ej.EmployeeID=eu.EmployeeID and eu.StoreID=ej.StoreID where lssd.ID=@ShiftDetailID and eu.SendEmailWhen & 3=3  and lssd.GiveUpFrom<>0
and 	isnull(eu.Email,'')<>'' and lss.StoreID=@StoreID
	union 
	select distinct eu.id,case when MobileCarrier=1 
			then MobilePhone+(select Describe from ConstTable where Category='MobileCarrier' and ID=1) 
			when MobileCarrier=2 
			then MobilePhone+(select Describe from ConstTable where Category='MobileCarrier' and ID=2) 
			when MobileCarrier=3 
			then MobilePhone+(select Describe from ConstTable where Category='MobileCarrier' and ID=3)
			when MobileCarrier=4 
			then MobilePhone+(select Describe from ConstTable where Category='MobileCarrier' and ID=4) end Email,'Mobile' as [Type] from LaborScheduleShiftDetail lssd
	inner join LaborScheduleShift lss on lssd.ShiftID=lss.ID
	inner join EmployeeJob ej on ej.StoreID=lss.StoreID and lssd.GiveUpFrom=ej.ID
	 inner join EnterpriseUser eu on ej.EmployeeID=eu.EmployeeID and eu.StoreID=lss.StoreID where lssd.ID=@ShiftDetailID and 
	 eu.SendMessageWhen & 3=3  and lssd.GiveUpFrom<>0 and isnull(MobilePhone,'')<>'' and lss.StoreID=@StoreID
end
else 
begin
	select @EmployeeID = ej.EmployeeID,@GiveUpFrom=lssd.GiveUpFrom,@StoreID=lss.StoreID,@JobID=lss.JobID from LaborScheduleShiftDetail lssd inner join LaborScheduleShift lss
	on lssd.ShiftID=lss.ID inner join EmployeeJob ej on ej.ID=lss.JobID and ej.StoreID=lss.StoreID
	 where lssd.ID=@ShiftDetailID
	 if @EmployeeID=@selEmployeeID
	 begin
		if @GiveUpFrom=0
		begin
			select @PositionID=PositionID from EmployeeJob where StoreID=@StoreID and ID=@JobID
			select distinct eu.id,eu.Email,'Email' as [Type] from EmployeeJob ej inner join EnterpriseUser eu on eu.StoreID=ej.StoreID
			and eu.EmployeeID=ej.EmployeeID where ej.PositionID=@PositionID and ej.StoreID=@StoreID
			and eu.SendEmailWhen & 3=3 and ISNULL(eu.Email,'')<>'' and eu.StoreID=@StoreID
			union 
			select distinct eu.id,case when MobileCarrier=1 
			then MobilePhone+(select Describe from ConstTable where Category='MobileCarrier' and ID=1) 
			when MobileCarrier=2 
			then MobilePhone+(select Describe from ConstTable where Category='MobileCarrier' and ID=2) 
			when MobileCarrier=3
			then MobilePhone+(select Describe from ConstTable where Category='MobileCarrier' and ID=3)
			when MobileCarrier=4  
			then MobilePhone+(select Describe from ConstTable where Category='MobileCarrier' and ID=4) end Email,'Mobile' as [Type] 
			from EmployeeJob ej inner join EnterpriseUser eu on eu.StoreID=ej.StoreID
			and eu.EmployeeID=ej.EmployeeID where ej.PositionID=@PositionID and ej.StoreID=@StoreID
			and eu.SendMessageWhen & 3=3 and isnull(MobilePhone,'')<>'' and eu.StoreID=@StoreID
			union 
			select distinct eu.id,eu.Email,'Email' as [Type] from EnterpriseUser eu  where eu.StoreID=@StoreID and IsManager=1 and eu.SendEmailWhen & 3=3 and ISNULL(eu.Email,'')<>''
			union  
			select distinct eu.id,case when MobileCarrier=1 
			then MobilePhone+(select Describe from ConstTable where Category='MobileCarrier' and ID=1) 
			when MobileCarrier=2  
			then MobilePhone+(select Describe from ConstTable where Category='MobileCarrier' and ID=2) 
			when MobileCarrier=3  
			then MobilePhone+(select Describe from ConstTable where Category='MobileCarrier' and ID=3)
			when MobileCarrier=4 
			then MobilePhone+(select Describe from ConstTable where Category='MobileCarrier' and ID=4) end Email,
			'Mobile' as [Type] from EnterpriseUser eu  where eu.StoreID=@StoreID and IsManager=1 and 
			eu.SendMessageWhen & 3=3		and isnull(MobilePhone,'')<>'' and eu.StoreID=@StoreID
		end
		else
		begin
			select distinct eu.id,eu.Email,'Email' as [Type] from EnterpriseUser eu inner join EmployeeJob ej 
			on eu.EmployeeID = ej.EmployeeID and eu.StoreID=ej.StoreID  where ej.ID=@GiveUpFrom 
			and eu.SendEmailWhen & 3=3  and ISNULL(eu.Email,'')<>'' and eu.StoreID=@StoreID
			union 
			select distinct eu.id,case when MobileCarrier=1
			then MobilePhone+(select Describe from ConstTable where Category='MobileCarrier' and ID=1) 
			when MobileCarrier=2 
			then MobilePhone+(select Describe from ConstTable where Category='MobileCarrier' and ID=2) 
			when MobileCarrier=3 
			then MobilePhone+(select Describe from ConstTable where Category='MobileCarrier' and ID=3)
			when MobileCarrier=4 
			then MobilePhone+(select Describe from ConstTable where Category='MobileCarrier' and ID=4) end Email,
			'Mobile' as [Type] from EnterpriseUser eu  inner join EmployeeJob ej on eu.EmployeeID = ej.EmployeeID 
			and eu.StoreID=ej.StoreID  where ej.ID=@GiveUpFrom and eu.SendMessageWhen & 3=3 and eu.StoreID=@StoreID	
	and isnull(MobilePhone,'')<>''		
	union 
			select distinct eu.id,eu.Email,'Email' as [Type] from EnterpriseUser eu  where eu.StoreID=@StoreID and 
			IsManager=1 and eu.SendEmailWhen & 3=3  and ISNULL(eu.Email,'')<>'' and eu.StoreID=@StoreID
			union  
			select distinct eu.id,case when MobileCarrier=1
			then MobilePhone+(select Describe from ConstTable where Category='MobileCarrier' and ID=1) 
			when MobileCarrier=2 
			then MobilePhone+(select Describe from ConstTable where Category='MobileCarrier' and ID=2) 
			when MobileCarrier=3 
			then MobilePhone+(select Describe from ConstTable where Category='MobileCarrier' and ID=3)
			when MobileCarrier=4 
			then MobilePhone+(select Describe from ConstTable where Category='MobileCarrier' and ID=4) end Email,
			'Mobile' as [Type] from EnterpriseUser eu  where eu.StoreID=@StoreID and IsManager=1 
			and eu.SendMessageWhen & 3=3			and isnull(MobilePhone,'')<>'' and eu.StoreID=@StoreID
		end
	 end
	 else
	 begin
		select distinct eu.id,eu.Email,'Email' as [Type] from EnterpriseUser eu  where eu.EmployeeID=@EmployeeID 
		and eu.SendEmailWhen & 3=3   and ISNULL(eu.Email,'')<>''  and eu.StoreID=@StoreID
		union 	
		select distinct eu.id,eu.Email,'Email' as [Type] from EnterpriseUser eu  where eu.StoreID=@StoreID and 
		IsManager=1 and eu.SendEmailWhen & 3=3  and ISNULL(eu.Email,'')<>'' and eu.StoreID=@StoreID
		union  
		select distinct eu.id,case when MobileCarrier=1  
			then MobilePhone+(select Describe from ConstTable where Category='MobileCarrier' and ID=1) 
			when MobileCarrier=2 
			then MobilePhone+(select Describe from ConstTable where Category='MobileCarrier' and ID=2) 
			when MobileCarrier=3 
			then MobilePhone+(select Describe from ConstTable where Category='MobileCarrier' and ID=3)
			when MobileCarrier=4 
			then MobilePhone+(select Describe from ConstTable where Category='MobileCarrier' and ID=4) end Email,
			'Mobile' as [Type] from EnterpriseUser eu  where eu.EmployeeID=@EmployeeID and eu.SendMessageWhen & 3=3  
	and isnull(MobilePhone,'')<>''	and eu.StoreID=@StoreID	 
		union 	
		select distinct eu.id,case when MobileCarrier=1  
			then MobilePhone+(select Describe from ConstTable where Category='MobileCarrier' and ID=1) 
			when MobileCarrier=2 
			then MobilePhone+(select Describe from ConstTable where Category='MobileCarrier' and ID=2) 
			when MobileCarrier=3 
			then MobilePhone+(select Describe from ConstTable where Category='MobileCarrier' and ID=3)
			when MobileCarrier=4 
			then MobilePhone+(select Describe from ConstTable where Category='MobileCarrier' and ID=4) end Email,
			'Mobile' as [Type] from EnterpriseUser eu  where eu.StoreID=@StoreID and IsManager=1 
			and eu.SendMessageWhen & 3=3	and eu.StoreID=@StoreID	 	and isnull(MobilePhone,'')<>''
	 end
end

GO
