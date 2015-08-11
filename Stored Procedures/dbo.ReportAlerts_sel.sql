SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE proc [dbo].[ReportAlerts_sel]
(
	@id int,
	@UserID int
)
as
if ISNULL(@id,0)<>0
begin
	select *,eu.FirstName+' '+eu.LastName as owner from ReportAlert as  ra 
	inner join EnterpriseUser eu on ra.UserID=eu.ID where ra.ID=@id
end
else
begin
		 
		 select ra.ID as AlertID,
		ra.AlertName as AlertName, 
		'below '+TriggerBelowValues as BelowValues,
		'above ' +TriggerAboveValues as AboveValues,
		StartDate as StartDate,EndDate as EndDate,
		case when AlertFrequency=1 then 'Daily' when AlertFrequency=2 then 'Hourly' when AlertFrequency=3 then 'Weekly' else 'Right away' end as AlertFrequency,
		( select COUNT(*) from f_split(SendtoStore,',')) as storeCount,
		eu.FirstName+' '+eu.LastName as owner,UserID
		from ReportAlert as  ra inner join EnterpriseUser eu on ra.UserID=eu.ID 
		 where ((select StoreID from EnterpriseUser where ID=@UserID) in (select * from dbo.f_split(SendtoStore,','))
		 and '1' in (select * from dbo.f_split(Sendto,','))) or 
		 ((select StoreID from EnterpriseUser where ID=@UserID)=0 and '0' in (select * from dbo.f_split(Sendto,',')))
		 or UserID=@UserID
end
GO
