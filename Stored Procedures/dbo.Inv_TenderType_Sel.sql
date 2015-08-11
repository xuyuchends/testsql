SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Inv_TenderType_Sel]
(
	@ID int,
	@Name nvarchar(200),
	@IsActive bit,
	@LastUpdate datetime,
	@Creator int,
	@Editor int,
	@SQLOperationType nvarchar(50)
)
as
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	if (@SQLOperationType='SQLSELECT')
		if (isnull(@IsActive,'')='')
			SELECT [ID],[Name],[IsActive],[LastUpdate],[Creator],[Editor]FROM [Inv_TenderType]
			order by Name asc
		else
			SELECT [ID],[Name],[IsActive],[LastUpdate],[Creator],[Editor]FROM [Inv_TenderType]
			where IsActive=@IsActive
			order by Name asc	
	else if (@SQLOperationType='SQLSELECTDETAIL')
		SELECT [ID],[Name],[IsActive],[LastUpdate],[Creator],[Editor]FROM [Inv_TenderType]
		where ID=@ID
END
GO
