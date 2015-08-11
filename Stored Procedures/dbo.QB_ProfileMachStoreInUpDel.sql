SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[QB_ProfileMachStoreInUpDel]
	@ProfileID int,
	@StoreID int,
	@Type int
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	 if	(@Type = 1)
		begin
			insert into QB_ProfileMachStore(ProfileID,StoreID)values(@ProfileID,@StoreID)
		end
	else if(@Type = 2)
		begin
			delete QB_ProfileMachStore where ProfileID = @ProfileID
		end	
END
GO
