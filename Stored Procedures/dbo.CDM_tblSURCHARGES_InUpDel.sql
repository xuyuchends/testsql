SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CDM_tblSURCHARGES_InUpDel]
	-- Add the parameters for the stored procedure here
	@sur_id bigint  ,
	@sur_desc nvarchar(20) ,
	@sur_type varchar(10) ,
	@sur_amt money ,
	@sur_percent decimal(18, 4) ,
	@sur_lastupdate datetime ,
	@sur_deleted char(1) ,
	@EditorID int ,
	@EditorName nvarchar(50) ,
	@GUID uniqueidentifier,
	@sqlType nvarchar(200)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	declare @innerSur_desc nvarchar(20) 
	declare @innerSur_type varchar(10) 
	declare @innerSur_amt money 
	declare @innerSur_percent decimal(18, 4) 
	declare @innerSur_deleted char(1) 
	if (@sqlType='SQLINSERT')
	 begin try
    begin tran
		declare @returnID int=0
		INSERT INTO CDM_tblSURCHARGES(sur_desc,sur_type,sur_amt,sur_percent,sur_lastupdate,sur_deleted,last_update,EditorID,EditorName) 
		VALUES (@sur_desc,@sur_type,@sur_amt,@sur_percent,GETDATE(),@sur_deleted,GETDATE(),@EditorID,@EditorName)

		set @returnID=@@IDENTITY;

	INSERT INTO CDM_Transfer_tblSURCHARGES(sur_id,sur_desc,sur_type,sur_amt,sur_percent,sur_lastupdate,
	sur_deleted,last_update,EditorID,EditorName,GUID,TransferState) VALUES
	 (@sur_id,@sur_desc,@sur_type,@sur_amt,@sur_percent,@sur_lastupdate,@sur_deleted,GETDATE(),
	 @EditorID,@EditorName,@GUID,1)
    commit tran
    end try
    begin catch
		rollback tran
    end catch
    else if (@sqlType='SQLUPDATE')
    begin try
		begin tran
			SELECT  @innerSur_desc=sur_desc,@innerSur_type= sur_type,@innerSur_amt= sur_amt,@innerSur_percent= sur_percent,@innerSur_deleted= sur_deleted FROM CDM_tblSURCHARGES
			where sur_id=@sur_id
			
			UPDATE CDM_tblSURCHARGES SET sur_desc=@sur_desc,sur_type=@sur_type,sur_amt=@sur_amt,
			sur_percent=@sur_percent,sur_lastupdate=GETDATE(),sur_deleted=@sur_deleted,
			last_update=GETDATE(),EditorID=@EditorID,EditorName=@EditorName WHERE sur_id=@sur_id

			if (@innerSur_desc!=@sur_desc or @innerSur_type!=@Sur_type or @innerSur_amt!=@Sur_amt
			or @innerSur_percent!=@Sur_percent or @innerSur_deleted!=@Sur_deleted  )
					INSERT INTO CDM_Transfer_tblSURCHARGES(sur_id,sur_desc,sur_type,sur_amt,sur_percent,sur_lastupdate,
	sur_deleted,last_update,EditorID,EditorName,GUID,TransferState) VALUES
	 (@sur_id,@sur_desc,@sur_type,@sur_amt,@sur_percent,@sur_lastupdate,@sur_deleted,GETDATE(),
	 @EditorID,@EditorName,@GUID,1)
		commit tran
	end try
	begin catch
		rollback tran
    end catch
    else if (@sqlType='SQLDELETE')
    begin
		delete from  CDM_tblSURCHARGES WHERE sur_id=@sur_id
    end 
END
GO
