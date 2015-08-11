SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[fn_CheckIfModuleInstalledAndEnabled] 
(	
	-- Add the parameters for the function here
	@module varchar(20),
	@StoreID int
)
RETURNS varchar 
AS
begin
	-- Add the SELECT statement with parameter references here
	declare @moduleInstalled varchar(1)
	declare @moduleEnabled varchar(1)
	declare @installedandenabled char(1)

	SELECT @moduleInstalled = Installed, @moduleEnabled = ModuleEnabled from InstalledModules with(nolock)
		WHERE HSModule = @module and StoreID=@StoreID

	if @@rowcount= 0
	begin
		set @installedandenabled = 'U'
	end
    else if @moduleInstalled = 'Y'
	begin
		if @moduleEnabled = 'Y'
		begin
			set @installedandenabled = 'Y'
		end
		else
		begin
			set @installedandenabled = 'N'
		end
	end
	else
		begin
		set @installedandenabled = 'N'
		end
		
	return @installedandenabled
end
GO
