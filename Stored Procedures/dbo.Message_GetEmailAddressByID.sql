SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE proc [dbo].[Message_GetEmailAddressByID]
(
	@id int,
	@Type nvarchar(20)
)
 AS  
 BEGIN 
 	declare @Name varchar(100)
 	declare @StoreID int
    declare @UserID int
    declare @SendTo nvarchar(max)
    declare @Value nvarchar(50)
    create table #retTable (Email nvarchar(50),[type] nvarchar(20))
    select @StoreID=StoreID ,@UserID=FromUserID,@SendTo=AddressTo from [EmailSendAgain] where 
    ID=@id and
     [Type]=@Type and [HasSend]=0
declare cur cursor
read_only
for select * from dbo.f_split(@SendTo,',')

open cur
fetch next from cur into @Name
while(@@fetch_status=0)
begin
		if substring(@Name,1,2)='s-'
		begin
			insert into #retTable select Email,'Email' from EnterpriseUser where StoreID=substring(@Name,3,(len(@Name)-2)) and IsManager=1 and SendEmailWhen & 1=1 
			insert into #retTable 
			select  
			case when MobileCarrier=1 
			then MobilePhone+(select Describe from ConstTable where Category='MobileCarrier' and ID=1) 
			when MobileCarrier=2  
			then MobilePhone+(select Describe from ConstTable where Category='MobileCarrier' and ID=2) 
			when MobileCarrier=3  
			then MobilePhone+(select Describe from ConstTable where Category='MobileCarrier' and ID=3)
			when MobileCarrier=4 
			then MobilePhone+(select Describe from ConstTable where Category='MobileCarrier' and ID=4) end,'Mobile' from EnterpriseUser where StoreID=substring(@Name,3,(len(@Name)-2)) and IsManager=1 
	and SendMessageWhen & 1=1 and isnull(MobilePhone,'')<>''		   
	--select @Name		
		end
		else if substring(@Name,1,2)='j-'
		begin
		
			insert into #retTable select eu.Email,'Email' from EmployeeJob ej 
				inner join Position p on ej.PositionID=p.ID and ej.StoreID=p.StoreID
				inner join EnterpriseUser eu on ej.EmployeeID = eu.EmployeeID 
				where p.ID=substring(@Name,3,(len(@Name)-2)) and p.StoreID=@StoreID
				and SendEmailWhen & 1=1 
			insert into #retTable select 
			case when MobileCarrier=1 
			then MobilePhone+(select Describe from ConstTable where Category='MobileCarrier' and ID=1) 
			when MobileCarrier=2 
			then MobilePhone+(select Describe from ConstTable where Category='MobileCarrier' and ID=2) 
			when MobileCarrier=3  
			then MobilePhone+(select Describe from ConstTable where Category='MobileCarrier' and ID=3)
			when MobileCarrier=4 
			then MobilePhone+(select Describe from ConstTable where Category='MobileCarrier' and ID=4) end,'Mobile' from EmployeeJob ej 
				inner join Position p on ej.PositionID=p.ID and ej.StoreID=p.StoreID
				inner join EnterpriseUser eu on ej.EmployeeID = eu.EmployeeID 
				where p.ID=substring(@Name,3,(len(@Name)-2)) and p.StoreID=@StoreID
				and SendMessageWhen & 1=1 	and isnull(MobilePhone,'')<>''
	--select  @Name
		end
		else if substring(@Name,1,2)='e-'
		begin
			
			insert into #retTable select Email,'Email' from enterpriseUser where id=substring(@Name,3,(len(@Name)-2)) and SendEmailWhen & 1=1 
	insert into #retTable select case when MobileCarrier=1 
			then MobilePhone+(select Describe from ConstTable where Category='MobileCarrier' and ID=1) 
			when MobileCarrier=2 
			then MobilePhone+(select Describe from ConstTable where Category='MobileCarrier' and ID=2) 
			when MobileCarrier=3 
			then MobilePhone+(select Describe from ConstTable where Category='MobileCarrier' and ID=3)
			when MobileCarrier=4 
			then MobilePhone+(select Describe from ConstTable where Category='MobileCarrier' and ID=4) end,'Mobile' from enterpriseUser where id=substring(@Name,3,(len(@Name)-2)) 	
	and SendMessageWhen & 1=1 	and isnull(MobilePhone,'')<>''
	--select  @Name	
		end
		else if ISNULL(@Name,'')='All Store'
		begin
		Create table #temp (id int,StoreID int,ParentID int,StoreName nvarchar(50),city nvarchar(50),[State/Province] nvarchar(50))
insert into #temp exec StoreAvailable_sel @UserID
			insert into #retTable select Email,'Email' from EnterpriseUser where StoreID in (select StoreID from #temp) and IsManager=1 and SendEmailWhen & 1=1 
			insert into #retTable select case when MobileCarrier=1 
			then MobilePhone+(select Describe from ConstTable where Category='MobileCarrier' and ID=1) 
			when MobileCarrier=2 
			then MobilePhone+(select Describe from ConstTable where Category='MobileCarrier' and ID=2) 
			when MobileCarrier=3 
			then MobilePhone+(select Describe from ConstTable where Category='MobileCarrier' and ID=3)
			when MobileCarrier=4  
			then MobilePhone+(select Describe from ConstTable where Category='MobileCarrier' and ID=4) end,'Mobile' from EnterpriseUser where StoreID in (select StoreID from #temp) and IsManager=1	
	and SendMessageWhen & 1=1 	and isnull(MobilePhone,'')<>''
	--select  @Name		
		end
		else if ISNULL(@Name,'')='EVERYONE'
		begin
			insert into #retTable select Email,'Email' from EnterpriseUser where StoreID=@StoreID
			and IsManager=1 and SendEmailWhen & 1=1 
			insert into #retTable select case when MobileCarrier=1  
			then MobilePhone+(select Describe from ConstTable where Category='MobileCarrier' and ID=1) 
			when MobileCarrier=2 
			then MobilePhone+(select Describe from ConstTable where Category='MobileCarrier' and ID=2) 
			when MobileCarrier=3 
			then MobilePhone+(select Describe from ConstTable where Category='MobileCarrier' and ID=3)
			when MobileCarrier=4 
			then MobilePhone+(select Describe from ConstTable where Category='MobileCarrier' and ID=4) end,'Mobile' from EnterpriseUser where StoreID=@StoreID and isnull(MobilePhone,'')<>''
	and SendMessageWhen & 1=1 	
			--select @Name
		end
		else if substring(@Name,1,3)='t-e'
		begin
			insert into #retTable select Email,'Email' from EnterpriseUser where StoreID=0 
			insert into #retTable select case when MobileCarrier=1  
			then MobilePhone+(select Describe from ConstTable where Category='MobileCarrier' and ID=1) 
			when MobileCarrier=2 
			then MobilePhone+(select Describe from ConstTable where Category='MobileCarrier' and ID=2) 
			when MobileCarrier=3 
			then MobilePhone+(select Describe from ConstTable where Category='MobileCarrier' and ID=3)
			when MobileCarrier=4 
			then MobilePhone+(select Describe from ConstTable where Category='MobileCarrier' and ID=4) end,'Mobile' 
			from EnterpriseUser where StoreID=0 and isnull(MobilePhone,'')<>'' 
		end
		else if substring(@Name,1,3)='t-m'
		begin
		
			declare @SendtoStoreID int
			set @SendtoStoreID=substring(@Name,5,LEN(@Name))
			insert into #retTable select Email,'Email' from EnterpriseUser where StoreID=@SendtoStoreID
			and IsManager=1
			insert into #retTable select case when MobileCarrier=1  
			then MobilePhone+(select Describe from ConstTable where Category='MobileCarrier' and ID=1) 
			when MobileCarrier=2 
			then MobilePhone+(select Describe from ConstTable where Category='MobileCarrier' and ID=2) 
			when MobileCarrier=3 
			then MobilePhone+(select Describe from ConstTable where Category='MobileCarrier' and ID=3)
			when MobileCarrier=4 
			then MobilePhone+(select Describe from ConstTable where Category='MobileCarrier' and ID=4) end,'Mobile' 
			from EnterpriseUser where StoreID=@SendtoStoreID and IsManager=1 and isnull(MobilePhone,'')<>'' 
		end
		else if substring(@Name,1,3)='t-u'
		begin
			declare @SendToUserID int
			set @SendToUserID=substring(@Name,5,LEN(@Name))
			insert into #retTable select Email,'Email' from EnterpriseUser where id=@SendToUserID 
			insert into #retTable select case when MobileCarrier=1  
			then MobilePhone+(select Describe from ConstTable where Category='MobileCarrier' and ID=1) 
			when MobileCarrier=2 
			then MobilePhone+(select Describe from ConstTable where Category='MobileCarrier' and ID=2) 
			when MobileCarrier=3 
			then MobilePhone+(select Describe from ConstTable where Category='MobileCarrier' and ID=3)
			when MobileCarrier=4 
			then MobilePhone+(select Describe from ConstTable where Category='MobileCarrier' and ID=4) end,'Mobile' 
			from EnterpriseUser where ID=@SendToUserID and isnull(MobilePhone,'')<>'' 
		end
		else
		begin
			insert into #retTable values(@Name,'Email')
			--select @Name
		end
fetch next from cur into @Name
end
close cur
deallocate cur
select distinct Email,[Type] from #retTable where isnull(Email,'')<>''
 
 END
GO
