SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ManagerLog_sel]
	@UserID int,
	@ID int,
	@ParentId int, 
	@ManagerLogName nvarchar(20) 
AS
BEGIN
	SET NOCOUNT ON;
	declare @sqlAll nvarchar(max)
	declare @sqlWhere nvarchar(max)
	declare @ManagerLogID int
	set @sqlWhere=''
	--
	if ISNULL(@UserID,0)<>0
	begin
		set @sqlWhere=@sqlWhere+' and UserID in (select userID from [dbo].[f_SelAllSuperiorUser]('+CONVERT(nvarchar(20),@UserID)+'))'
	end
	if ISNULL(@ID,0)<>0
	begin
		set @sqlWhere=@sqlWhere+' and ID='+CONVERT(nvarchar(20),@ID)
	end
	--根据ManagerLogName可查询出该Log的所有标题
	if ISNULL(@ManagerLogName,'')<>''
	begin
		select @ManagerLogID=ID from ManagerLog where Name=@ManagerLogName
		set @sqlWhere=@sqlWhere+' and ManagerLogid='+convert(nvarchar(20),@ManagerLogID)
	end
	--0:查询根节点 
	if @ParentId is not null
	begin
		set @sqlWhere=@sqlWhere+' and ParentID='+CONVERT(nvarchar(20),@ParentId)
	end
	set @sqlAll ='select * from ManagerLog'
	if ISNULL(@sqlWhere,'')<>''
	begin
		set @sqlAll=@sqlAll+' where 1=1'+@sqlWhere
	end
	--select @sqlAll
	set @sqlAll =@sqlAll + 'order by [Sequence] asc'
	
	execute sp_executesql @sqlAll
	--select @sqlAll
END
GO
