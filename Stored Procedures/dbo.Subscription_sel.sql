SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Subscription_sel]
(
	@id int,
	@UserID int
)
as
if ISNULL(@id,0)<>0
begin
	select rs.*,eu.FirstName+' '+eu.LastName as EnterpriseName 
	from reportSubscription rs 
	inner join EnterpriseUser eu on rs.UserID=eu.ID 
	where rs.ID=@id
	order by CreatedDate desc
end
else
begin
	if isnull(@UserID,'0')='0'
	begin
		select rs.*,rd.Name+'.aspx' PageName from reportSubscription rs inner join ReportDetail rd on rs.ReportDetailID=rd.ID where 
			( CONVERT(datetime, CONVERT(nvarchar(20),getdate(),101)+' '+convert(nvarchar(20),SendTime,8)) between isnull(lastSendDate,'1900-1-1') and getdate() and Frequency='1' and GETDATE() between StartDate and isnull(EndDate,'9999-1-1')
	) or
		((DATEPART(week,StartDate)=DATEPART(week,getdate()) and CONVERT(datetime, CONVERT(nvarchar(20),getdate(),101)+' '+convert(nvarchar(20),SendTime,8)) between isnull(lastSendDate,'1900-1-1') and getdate() or DATEDIFF(day,lastSendDate,GETDATE())>7) and Frequency='2' and GETDATE() between StartDate and isnull(EndDate,'9999-1-1'))
		order by rs.CreatedDate desc
	end	
	else 
	begin
		select rs.ID ,rs.Name, StartDate,EndDate,SendTime, Frequency,LastSendDate, eu.FirstName+' '+eu.LastName as EnterpriseName,rs.UserID from ReportSubscription as  rs inner join EnterpriseUser eu on rs.UserID=eu.ID  
		where UserID=@UserID or 
		((select case when IsManager=1 and storeid>0 and StoreID in (select * from dbo.f_split((select rpv.Value from ReportParaValue rpv inner join ReportParameter rp on 
		rpv.ParameterID=rp.ParaID  where SubscriptionID=rs.ID and rp.ParaName='StoreID'),',')) then '1'
		else '0' end  from EnterpriseUser where ID=@UserID)=1 and '1' in (select * from dbo.f_split(sendTo,','))) or
		((select StoreID from EnterpriseUser where ID=@UserID)=0 and '0' in (select * from dbo.f_split(sendTo,',')))
		order by rs.CreatedDate desc
	end
end
GO
