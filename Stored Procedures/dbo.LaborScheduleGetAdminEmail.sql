SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[LaborScheduleGetAdminEmail]
	-- Add the parameters for the stored procedure here
	@UserID int,
	@Type nvarchar(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    if ISNULL(@Type,'')='GetManager'
    begin
		select id,Email,'Email' as [Type] from EnterpriseUser where IsManager=1 and 
		StoreID=(select StoreID from EnterpriseUser where ID=@UserID)
		union all
		select distinct eu.id, case when MobileCarrier=1 
				then MobilePhone+(select Describe from ConstTable where Category='MobileCarrier' and ID=1) 
				when MobileCarrier=2 
				then MobilePhone+(select Describe from ConstTable where Category='MobileCarrier' and ID=2) 
				when MobileCarrier=3 
				then MobilePhone+(select Describe from ConstTable where Category='MobileCarrier' and ID=3)
				when MobileCarrier=4 
				then MobilePhone+(select Describe from ConstTable where Category='MobileCarrier' and ID=4) end,
				'Mobile' as [Type]
				from EnterpriseUser eu where IsManager=1 and 
		StoreID=(select StoreID from EnterpriseUser where ID=@UserID)
	end
	else if ISNULL(@Type,'')='GetSelf'
	begin
		select id,Email,'Email' as [Type] from EnterpriseUser where ID=@UserID 
		union all
		select distinct eu.id, case when MobileCarrier=1 
				then MobilePhone+(select Describe from ConstTable where Category='MobileCarrier' and ID=1) 
				when MobileCarrier=2 
				then MobilePhone+(select Describe from ConstTable where Category='MobileCarrier' and ID=2) 
				when MobileCarrier=3 
				then MobilePhone+(select Describe from ConstTable where Category='MobileCarrier' and ID=3)
				when MobileCarrier=4 
				then MobilePhone+(select Describe from ConstTable where Category='MobileCarrier' and ID=4) end,
				'Mobile' as [Type]
				from EnterpriseUser eu where ID=@UserID 
	end
END
GO
