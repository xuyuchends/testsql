SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[QB_ProfileMachStoreSel]
	-- Add the parameters for the stored procedure here
	@ProfileID int,
	@Type int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	if(@Type = 1)
		begin
			select ProfileID,StoreID from QB_ProfileMachStore where ProfileID = @ProfileID
		end
	if(@Type = 2)
		begin
			select ProfileID,StoreID from QB_ProfileMachStore
		end	
END
GO
