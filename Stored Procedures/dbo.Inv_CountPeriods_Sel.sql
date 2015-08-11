SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Inv_CountPeriods_Sel]
(
	@ID int,
	@Name nvarchar(200),
	@Period int,
	@DayofWeek int,
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
		select [ID],[Name],[Period],[DayofWeek],[LastUpdate],[Creator],[Editor] from Inv_CountPeriods
	else if (@SQLOperationType='SQLSELECTDETAIL')
		select [ID],[Name],[Period],[DayofWeek],[LastUpdate],[Creator],[Editor] from Inv_CountPeriods
		where ID=@ID
END
GO
