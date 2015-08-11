SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ReportList_Sel]
(
 @id int,
 @type int
 )
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	if @type=1
	begin
	select rl.id as ID, rl.name as Name,COUNT(rd.ReportListID) as CountReport from reportList  as rl 
		left outer join ReportDetail as rd on rl.id=rd.ReportListID
	group by rl.id,rl.name
	order by  rl.id asc
	end
	else if @type=2
	begin
		select rl.id as ID, rl.name as Name from  reportList as rl where rl.ID=@id
	end
	else if @type=3
	begin
		select top 1 rl.id as ID, rl.name as Name from  reportList as rl
		order by  rl.id asc
	end
END
GO
