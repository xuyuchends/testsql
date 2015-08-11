SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE proc [dbo].[Report_GetEmail]
(
	@StoreID nvarchar(2000),
	@sendTo nvarchar(20),
	@SendToMe nvarchar(20),
	@SendUserID int
)  
 AS  
 
 BEGIN 
if exists (select * from tempdb.dbo.sysobjects where id = object_id(N'tempdb..#tbEmal') and type='U')
drop table #tbEmal
 create table #tbEmal (Email nvarchar(50))
 declare @UserID int
 declare @msgAddr nvarchar(50)
declare @availableStoreID int
declare @isContain int
declare @Email nvarchar(50)
declare @retValue nvarchar(2000)
 if ISNULL(@sendTo,'')='0'
 begin
	
	declare cur cursor
	read_only
	for select id,Email,case when MobileCarrier=1 
			then MobilePhone+(select Describe from ConstTable where Category='MobileCarrier' and ID=1) 
			when MobileCarrier=2  
			then MobilePhone+(select Describe from ConstTable where Category='MobileCarrier' and ID=2) 
			when MobileCarrier=3  
			then MobilePhone+(select Describe from ConstTable where Category='MobileCarrier' and ID=3)
			when MobileCarrier=4 
			then MobilePhone+(select Describe from ConstTable where Category='MobileCarrier' and ID=4) end msgAddr from EnterpriseUser where StoreID=0
	open cur
	fetch next from cur into @UserID,@Email,@msgAddr
	while(@@fetch_status=0)
	begin
		set @isContain=0
		declare cur1 cursor
		read_only
		for select StoreID from dbo.[f_SelAvailableStore](@UserID)
		open cur1
		fetch next from cur1 into @availableStoreID
		while(@@fetch_status=0)
		begin
			if @availableStoreID=@StoreID
			set @isContain=1
		fetch next from cur1 into @availableStoreID
		end
		close cur1
		deallocate cur1
		if @isContain=1
		begin
			insert into #tbEmal values(@Email)
			insert into #tbEmal values(@msgAddr)
		end
	fetch next from cur into @UserID,@Email,@msgAddr
	end
	close cur
	deallocate cur 
 end
 else if ISNULL(@sendTo,'')='1'
 begin
	insert into #tbEmal select Email from EnterpriseUser where StoreID=@StoreID and IsManager=1
	insert into #tbEmal select case when MobileCarrier=1 
			then MobilePhone+(select Describe from ConstTable where Category='MobileCarrier' and ID=1) 
			when MobileCarrier=2  
			then MobilePhone+(select Describe from ConstTable where Category='MobileCarrier' and ID=2) 
			when MobileCarrier=3  
			then MobilePhone+(select Describe from ConstTable where Category='MobileCarrier' and ID=3)
			when MobileCarrier=4 
			then MobilePhone+(select Describe from ConstTable where Category='MobileCarrier' and ID=4) end msgAddr from EnterpriseUser where StoreID=@StoreID and IsManager=1
 end
 else if ISNULL(@sendTo,'')='-1'
 begin
	insert into #tbEmal select Email from EnterpriseUser where id=@SendUserID
	insert into #tbEmal select case when MobileCarrier=1 
			then MobilePhone+(select Describe from ConstTable where Category='MobileCarrier' and ID=1) 
			when MobileCarrier=2  
			then MobilePhone+(select Describe from ConstTable where Category='MobileCarrier' and ID=2) 
			when MobileCarrier=3  
			then MobilePhone+(select Describe from ConstTable where Category='MobileCarrier' and ID=3)
			when MobileCarrier=4 
			then MobilePhone+(select Describe from ConstTable where Category='MobileCarrier' and ID=4) end msgAddr from EnterpriseUser where id=@SendUserID
 end
 else 
 begin
	declare cur cursor
	read_only
	for select id,Email,case when MobileCarrier=1 
			then MobilePhone+(select Describe from ConstTable where Category='MobileCarrier' and ID=1) 
			when MobileCarrier=2  
			then MobilePhone+(select Describe from ConstTable where Category='MobileCarrier' and ID=2) 
			when MobileCarrier=3  
			then MobilePhone+(select Describe from ConstTable where Category='MobileCarrier' and ID=3)
			when MobileCarrier=4 
			then MobilePhone+(select Describe from ConstTable where Category='MobileCarrier' and ID=4) end msgAddr from EnterpriseUser where StoreID=0
	open cur
	fetch next from cur into @UserID,@Email,@msgAddr
	while(@@fetch_status=0)
	begin
		set @isContain=0
		declare cur1 cursor
		read_only
		for select StoreID from dbo.[f_SelAvailableStore](@UserID)
		open cur1
		fetch next from cur1 into @availableStoreID
		while(@@fetch_status=0)
		begin
			if @availableStoreID=@StoreID
			set @isContain=1
		fetch next from cur1 into @availableStoreID
		end
		close cur1
		deallocate cur1
		if @isContain=1
		begin
			insert into #tbEmal values(@Email)
			insert into #tbEmal values(@msgAddr)
		end
	fetch next from cur into @UserID,@Email,@msgAddr
	end
	close cur
	deallocate cur
	insert into #tbEmal select Email from EnterpriseUser where StoreID=@StoreID and IsManager=1
	insert into #tbEmal select case when MobileCarrier=1 
			then MobilePhone+(select Describe from ConstTable where Category='MobileCarrier' and ID=1) 
			when MobileCarrier=2  
			then MobilePhone+(select Describe from ConstTable where Category='MobileCarrier' and ID=2) 
			when MobileCarrier=3  
			then MobilePhone+(select Describe from ConstTable where Category='MobileCarrier' and ID=3)
			when MobileCarrier=4 
			then MobilePhone+(select Describe from ConstTable where Category='MobileCarrier' and ID=4) end msgAddr from EnterpriseUser where StoreID=@StoreID and IsManager=1
 end
 
 if ISNULL(@SendToMe,'')='True'
 begin
	insert into #tbEmal select Email from EnterpriseUser where id=@SendUserID
	insert into #tbEmal select case when MobileCarrier=1 
			then MobilePhone+(select Describe from ConstTable where Category='MobileCarrier' and ID=1) 
			when MobileCarrier=2  
			then MobilePhone+(select Describe from ConstTable where Category='MobileCarrier' and ID=2) 
			when MobileCarrier=3  
			then MobilePhone+(select Describe from ConstTable where Category='MobileCarrier' and ID=3)
			when MobileCarrier=4 
			then MobilePhone+(select Describe from ConstTable where Category='MobileCarrier' and ID=4) end msgAddr from EnterpriseUser where id=@SendUserID
 end
set @retValue=''
declare cur1 cursor
read_only
for select distinct * from #tbEmal
open cur1
fetch next from cur1 into @Email
while(@@fetch_status=0)
begin
	if @retValue=''
	begin
		set @retValue=@retValue+isnull(@Email,'')
	end
	else
	begin
		set @retValue=@retValue+','+isnull(@Email,'')
	end
 fetch next from cur1 into @Email
 end
 close cur1
deallocate cur1
drop table #tbEmal
 	select @retValue
 
 END
 


GO
