SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Message_sel]
(
	@ID int,
	@UserID int,
	@Type nvarchar(20)
)
as
declare @UserType nvarchar(20)
declare @StoreName nvarchar(50)
declare @StoreID nvarchar(50)
declare @positionID nvarchar(50)
if ISNULL(@id,0)<>0
begin
	select 
	   m.[ID]
      ,m.[MsgSubject]
      ,m.[MsgContent]
      ,m.[UserID]
      ,m.[ParentID]
      ,m.[SendTo]
      ,m.[StoreID]
      ,m.DelUserID
      ,m.SendDate
	  ,e.FirstName+' '+e.LastName as UserName,dbo.[fn_GetSendTo](m.SendTo) as SendToName from MessageManager m inner join EnterpriseUser e on m.UserID=e.ID
	where m.ID=@ID order by SendDate desc
end
else
begin
	select @UserType=(case when StoreID=0 then 'EnterpriseUser' when (StoreID>0 and ismanager=1) then		'StoreManager' else 'StoreUser' end), @StoreID=StoreID from EnterpriseUser where ID=@UserID
	select @StoreName=StoreName from Store where ID=@StoreID	
	select @positionID=p.ID from EmployeeJob e inner join Position p on e.PositionID = p.ID and e.StoreID=p.StoreID where e.EmployeeID=@UserID
	
	if ISNULL(@Type,'')='Received'
	begin
		if @UserType='EnterpriseUser'	
		begin
		select 
		   m.[ID]
		  ,m.[MsgSubject]
		  ,m.[MsgContent]
		  ,m.[UserID]
		  ,m.[ParentID]
		  ,m.[SendTo]
		  ,m.[StoreID]
		  ,m.DelUserID
		  ,m.SendDate
		  ,e.FirstName+' '+e.LastName as UserName,dbo.[fn_GetSendTo](m.SendTo) as SendToName from MessageManager m inner join EnterpriseUser e on m.UserID=e.ID where 'e-'+convert(nvarchar(20),@UserID) in (select * from dbo.f_split(m.sendto,',')) and @UserID not in (select * from dbo.f_split(m.DelUserID,',')) order by SendDate desc
		end
		else if @UserType='StoreManager'
		begin
			select 
	   m.[ID]
      ,m.[MsgSubject]
      ,m.[MsgContent]
      ,m.[UserID]
      ,m.[ParentID]
      ,m.[SendTo]
      ,m.[StoreID]
      ,m.DelUserID
      ,m.SendDate
      ,e.FirstName+' '+e.LastName as UserName,dbo.[fn_GetSendTo](m.SendTo) as SendToName from MessageManager m inner join EnterpriseUser e on m.UserID=e.ID 
      where ('e-'+convert(nvarchar(20),@UserID) in (select * from dbo.f_split(m.sendto,','))
			or ('All Store' in (select * from dbo.f_split(m.sendto,',')) and @StoreID in (select storeid from dbo.[f_SelAvailableStore](m.UserID)))  
			or 's-'+convert(nvarchar(20),@StoreID) in (select * from dbo.f_split(m.sendto,','))) 
			and  @UserID not in (select * from dbo.f_split(m.DelUserID,','))  order by SendDate desc
		end
		else
		begin
			select 
	   m.[ID]
      ,m.[MsgSubject]
      ,m.[MsgContent]
      ,m.[UserID]
      ,m.[ParentID]
      ,m.[SendTo]
      ,m.[StoreID]
      ,m.DelUserID
      ,m.SendDate
      ,e.FirstName+' '+e.LastName as UserName,dbo.[fn_GetSendTo](m.SendTo) as SendToName from MessageManager m inner join EnterpriseUser e on m.UserID=e.ID where ('e-'+convert(nvarchar(20),@UserID) in (select * from dbo.f_split(m.sendto,','))
			or 'EVERYONE' in (select * from dbo.f_split(m.sendto,',')) or 'j-'+@positionID in (select * from dbo.f_split(m.sendto,','))) and m.StoreID=@StoreID and @UserID not in (select * from dbo.f_split(m.DelUserID,',')) order by SendDate desc
		end
	end
	else if ISNULL(@Type,'')='Sent'
	begin
		select 
	   m.[ID]
      ,m.[MsgSubject]
      ,m.[MsgContent]
      ,m.[UserID]
      ,m.[ParentID]
      ,m.[SendTo]
      ,m.[StoreID]
      ,m.DelUserID
      ,m.SendDate
      ,e.FirstName+' '+e.LastName as UserName,dbo.[fn_GetSendTo](m.SendTo) as SendToName from MessageManager m inner join EnterpriseUser e on m.UserID=e.ID where UserID=@UserID and @UserID not in (select * from dbo.f_split(m.DelUserID,',')) order by SendDate desc
	end
	else if ISNULL(@Type,'')='Not Replay'
	begin
		if @UserType='EnterpriseUser'	
		begin
		select 
	   m.[ID]
      ,m.[MsgSubject]
      ,m.[MsgContent]
      ,m.[UserID]
      ,m.[ParentID]
      ,m.[SendTo]
      ,m.[StoreID]
      ,m.DelUserID
      ,m.SendDate
      ,e.FirstName+' '+e.LastName as UserName,dbo.[fn_GetSendTo](m.SendTo) as SendToName from MessageManager m inner join EnterpriseUser e on m.UserID=e.ID 
      where 'e-'+convert(nvarchar(20),@UserID) in (select * from dbo.f_split(m.sendto,','))
		and (select COUNT(*) from MessageManager where ParentID=m.ID and UserID=@UserID)=0
		and @UserID not in (select * from dbo.f_split(m.DelUserID,','))
		order by SendDate desc
		end
		else if @UserType='StoreManager'
		begin
			select 
			   m.[ID]
			  ,m.[MsgSubject]
			  ,m.[MsgContent]
			  ,m.[UserID]
			  ,m.[ParentID]
			  ,m.[SendTo]
			  ,m.[StoreID]
			  ,m.DelUserID
			  ,m.SendDate
			  ,e.FirstName+' '+e.LastName as UserName
			  ,dbo.[fn_GetSendTo](m.SendTo) as SendToName 
			  from MessageManager m inner join EnterpriseUser e on m.UserID=e.ID 
			  where ('e-'+convert(nvarchar(20),@UserID) in (select * from dbo.f_split(m.sendto,','))
					or ('All Store' in (select * from dbo.f_split(m.sendto,',')) and @StoreID in (select storeid from dbo.[f_SelAvailableStore](m.UserID)))
					or 's_'+convert(nvarchar(20),@StoreID) in (select * from dbo.f_split(m.sendto,','))) and (select COUNT(*) from MessageManager where ParentID=m.ID and UserID=@UserID)=0
	and @UserID not in (select * from dbo.f_split(m.DelUserID,','))				
	order by SendDate desc				
		end
		else
		begin
			select 
	   m.[ID]
      ,m.[MsgSubject]
      ,m.[MsgContent]
      ,m.[UserID]
      ,m.[ParentID]
      ,m.[SendTo]
      ,m.[StoreID]
      ,m.DelUserID
	  ,m.SendDate
      ,e.FirstName+' '+e.LastName as UserName,dbo.[fn_GetSendTo](m.SendTo) as SendToName from MessageManager m inner join EnterpriseUser e on m.UserID=e.ID where ('e-'+convert(nvarchar(20),@UserID) in (select * from dbo.f_split(m.sendto,','))
			or 'EVERYONE' in (select * from dbo.f_split(m.sendto,',')) or 'j-'+@positionID in (select * from dbo.f_split(m.sendto,','))) and m.StoreID=@StoreID and (select COUNT(*) from MessageManager where ParentID=m.ID and UserID=@UserID)=0 and @UserID not in (select * from dbo.f_split(m.DelUserID,','))
	order by SendDate desc		
		end
	end
end


GO
