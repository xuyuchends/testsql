SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CDM_tblTAXES_CONDITIONAL_InUpDel]
	-- Add the parameters for the stored procedure here
	@con_tax_id int  ,
	@con_desc nvarchar(15) ,
	@con_type varchar(10) ,
	@con_primary_tax_id int ,
	@con_quantity int ,
	@con_check_total money ,
	@con_category nvarchar(4000) ,
	@con_success_tax_id int ,
	@con_fail_tax_id int ,
	@con_deleted char(1) ,
	@EditorID int ,
	@EditorName nvarchar(50) ,
	@GUID uniqueidentifier,
	@sqlType nvarchar(200)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	declare @innerCon_desc nvarchar(15) 
	declare @innerCon_type varchar(10)
	declare @innerCon_primary_tax_id int 
	declare @innerCon_quantity int 
	declare @innerCon_check_total money 
	declare @innerCon_category nvarchar(4000) 
	declare @innerCon_success_tax_id int 
	declare @innerCon_fail_tax_id int 
	declare @innerCon_deleted char(1) 
	if (@sqlType='SQLINSERT')
	 begin try
    begin tran
		declare @returnID int=0
		INSERT INTO CDM_tblTAXES_CONDITIONAL(con_desc,con_type,con_primary_tax_id,con_quantity,con_check_total,
		con_category,con_success_tax_id,con_fail_tax_id,con_lastupdate,con_deleted,EditorID,EditorName) 
		VALUES (@con_desc,@con_type,@con_primary_tax_id,@con_quantity,@con_check_total,@con_category,
		@con_success_tax_id,@con_fail_tax_id,GETDATE(),@con_deleted,@EditorID,@EditorName)

		set @returnID=@@IDENTITY;

		INSERT INTO CDM_Transfer_tblTAXES_CONDITIONAL(con_tax_id,con_desc,con_type,con_primary_tax_id,
		con_quantity,con_check_total,con_category,con_success_tax_id,con_fail_tax_id,con_lastupdate,
		con_deleted,EditorID,EditorName,GUID,TransferState) VALUES (@con_tax_id,@con_desc,
		@con_type,@con_primary_tax_id,@con_quantity,@con_check_total,@con_category,@con_success_tax_id,
		@con_fail_tax_id,GETDATE(),@con_deleted,@EditorID,@EditorName,@GUID,1)
		select @returnID
    commit tran
    end try
    begin catch
		rollback tran
    end catch
    else if (@sqlType='SQLUPDATE')
    begin try
		begin tran
			SELECT @innerCon_desc=con_desc,@innerCon_type=con_type,@innerCon_primary_tax_id=con_primary_tax_id,@innerCon_quantity=con_quantity,@innerCon_check_total=con_check_total,@innerCon_category=con_category,@innerCon_success_tax_id=con_success_tax_id,@innerCon_fail_tax_id=con_fail_tax_id,@innerCon_deleted=con_deleted FROM CDM_tblTAXES_CONDITIONAL
			where con_tax_id=@con_tax_id
			
			UPDATE CDM_tblTAXES_CONDITIONAL SET con_desc=@con_desc,con_type=@con_type,con_primary_tax_id=@con_primary_tax_id,con_quantity=@con_quantity,con_check_total=@con_check_total,con_category=@con_category,con_success_tax_id=@con_success_tax_id,con_fail_tax_id=@con_fail_tax_id,con_lastupdate=GETDATE(),con_deleted=@con_deleted,EditorID=@EditorID,EditorName=@EditorName
			where con_tax_id=@con_tax_id

			if (@innerCon_desc!=@Con_desc or @innerCon_type!=@Con_type or @innerCon_primary_tax_id!=@Con_primary_tax_id 
			or @innerCon_quantity!=@Con_quantity or @innerCon_check_total!=@Con_check_total 
			or @innerCon_category!=@Con_category or @innerCon_success_tax_id!=@Con_success_tax_id 
			or @innerCon_fail_tax_id!=@Con_fail_tax_id or @innerCon_deleted!=@Con_deleted  )
						INSERT INTO CDM_Transfer_tblTAXES_CONDITIONAL(con_tax_id,con_desc,con_type,con_primary_tax_id,
		con_quantity,con_check_total,con_category,con_success_tax_id,con_fail_tax_id,con_lastupdate,
		con_deleted,EditorID,EditorName,GUID,TransferState) VALUES (@con_tax_id,@con_desc,
		@con_type,@con_primary_tax_id,@con_quantity,@con_check_total,@con_category,@con_success_tax_id,
		@con_fail_tax_id,GETDATE(),@con_deleted,@EditorID,@EditorName,@GUID,1)
		commit tran
	end try
	begin catch
		rollback tran
    end catch
    else if (@sqlType='SQLDELETE')
    begin
		delete from  CDM_tblTAXES_CONDITIONAL WHERE con_tax_id=@con_tax_id
    end 
END
GO
