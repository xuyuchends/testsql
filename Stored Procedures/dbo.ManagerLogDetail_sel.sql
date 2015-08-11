SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ManagerLogDetail_sel]
	@ManagerLogID nvarchar(200),
	@HeaderId int,
	@ID int,
	@UserID int,
	@ParentID int,
	@Flag bit,
	@LogEntry nvarchar(50),
	@BeginDate nvarchar(20),
	@EndDate nvarchar(20),
	@SelectUeseTo nvarchar(20)
AS
BEGIN
	SET NOCOUNT ON;
	declare @sqlAll nvarchar(max)
	declare @sqlWhere nvarchar(max)
	set @sqlwhere=''
	if ISNULL(@ManagerLogID,'')<>''
	begin
		print '1'
		set @sqlWhere=@sqlwhere+' and mld.ManagerLogID in ('+CONVERT(nvarchar(20),@ManagerLogID)+')'
	end
	if ISNULL(@HeaderId,0)<>0
	begin
		print '2'
		set @sqlWhere=@sqlwhere+' and mld.HeaderID='+CONVERT(nvarchar(20),@HeaderId)
	end
	if ISNULL(@ID,0)<>0
	begin
		print '3'
		set @sqlWhere=@sqlwhere+' and mld.ID='+CONVERT(nvarchar(20),@ID)
	end
	if ISNULL(@UserID,0)<>0
	begin
		print '4'
		set @sqlWhere=@sqlwhere+' and mld.UserID in (select userid from [dbo].[f_SelAvailableUserWithManagerLog]('+CONVERT(nvarchar(20),@UserID)+'))'
	end
	if ISNULL(@ParentID,0)<>0
	begin
		set @sqlWhere=@sqlwhere+' and ml.ParentID='+CONVERT(nvarchar(20),@ParentID)
	end
	if @Flag is not null
	begin
		print '5'
		set @sqlWhere=@sqlwhere+' and mld.Flag='''+CONVERT(nvarchar(20),@Flag)+''''
	end
	if ISNULL(@LogEntry,'')<>''
	begin
		print '6'
		set @sqlWhere=@sqlwhere+' and mld.LogEntry like ''%'+CONVERT(nvarchar(20),@LogEntry)+'%'''
	end
	if ISNULL(@BeginDate,'')<>'' 
	begin
		print '7'
		set @sqlWhere=@sqlwhere+' and mld.UpdateDate >= '''+CONVERT(nvarchar(20),@BeginDate)+''' '
	end
	if ISNULL(@EndDate,'')<>''
	begin
		set @sqlWhere=@sqlwhere+' and mld.UpdateDate <= '''+CONVERT(nvarchar(20),@EndDate)+''''
	end
	
	
	set @sqlAll='select mld.id,mld.ManagerLogID,mld.UserID,eu.FirstName+'' ''+eu.LastName as userName, mld.Flag,mld.LogEntry,mld.UpdateDate,ml.Name,s.StoreName,s.ID as StoreID,s.StoreNumber,mld.HeaderID ,mh.LogDate
					from ManagerLogDetail mld 
					inner join ManagerLogDetailHeader mh on mh.id=mld.HeaderID
					inner join ManagerLog ml on mld.ManagerLogID=ml.ID
					inner join EnterpriseUser as eu on eu.ID=mld.UserID 
					left join Store s on s.ID=mh.StoreID'
	
	if(ISNULL(@sqlWhere,''))<>''
	begin
		set @sqlAll=@sqlAll+' where 1=1 '+@sqlWhere 
	end
	if ISNULL(@SelectUeseTo,'') <> ''
	begin
		set @sqlAll=@sqlAll+ ' order by StoreID,LogDate desc '
	end
	else
	begin
		set @sqlAll=@sqlAll+ ' order by LogDate desc '
	end
	
	
	print @sqlAll
	--select @sqlAll
	execute sp_executesql @sqlAll
END

GO
