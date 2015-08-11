SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Rpt_CheckIfModuleInstalledAndEnabled] 
	-- Add the parameters for the stored procedure here
	@module varchar(20),
	@StoreID int,
	@installedandenabled varchar(1) OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	declare @moduleInstalled varchar(1)
	declare @moduleEnabled varchar(1)

	SELECT @moduleInstalled = Installed, @moduleEnabled = ModuleEnabled from InstalledModules with(nolock)
		WHERE HSModule = @module and StoreID=@StoreID

	if @@rowcount= 0
		set @installedandenabled = 'U'
    else if @moduleInstalled = 'Y'
		if @moduleEnabled = 'Y'
			set @installedandenabled = 'Y'
		else
			set @installedandenabled = 'N'
	else
		set @installedandenabled = 'N'
END
GO
