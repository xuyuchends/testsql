SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CDM_tblTAX_RATES_InUpDel]
	-- Add the parameters for the stored procedure here
	@tax_id int,
	@tax_name nvarchar(16) ,
	@tax_rate decimal(18, 4) ,
	@tax_min_amt money ,
	@tax_type varchar(10) ,
	@tax_make_exclusive char(1) ,
	@tax_make_tax_id int ,
	@tax_deleted char(1) ,
	@EditorID int ,
	@EditorName nvarchar(50) ,
	@GUID uniqueidentifier,
	@sqlType nvarchar(200)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	declare	@innertax_name nvarchar(16) 
	declare	@innertax_rate decimal(18, 4) 
	declare	@innertax_min_amt money 
	declare	@innertax_type varchar(10) 
	declare	@innertax_make_exclusive char(1) 
	declare	@innertax_make_tax_id int 
	declare	@innertax_deleted char(1) 
	if (@sqlType='SQLINSERT')
	 begin try
    begin tran
		declare @returnID int=0
		INSERT INTO CDM_tblTAX_RATES(tax_name,tax_rate,tax_min_amt,tax_type,tax_lastupdate,tax_make_exclusive
           ,tax_make_tax_id,tax_deleted,last_update,EditorID,EditorName)
		VALUES
           (@tax_name,@tax_rate,@tax_min_amt,@tax_type,GETDATE(),@tax_make_exclusive,@tax_make_tax_id,@tax_deleted,GETDATE(),@EditorID,@EditorName)
       
       set @returnID=@@IDENTITY;
       
       INSERT INTO CDM_Transfer_tblTAX_RATES(tax_id,tax_name,tax_rate,tax_min_amt,tax_type,tax_lastupdate,
       tax_make_exclusive,tax_make_tax_id,tax_deleted,last_update,EditorID,EditorName,GUID,TransferState) VALUES (@tax_id,@tax_name,@tax_rate,@tax_min_amt,@tax_type,GETDATE(),
       @tax_make_exclusive,@tax_make_tax_id,@tax_deleted,GETDATE(),@EditorID,@EditorName,@GUID,1)
       
       
       select @returnID
    commit tran
    end try
    begin catch
		rollback tran
    end catch
    else if (@sqlType='SQLUPDATE')
    begin try
    begin tran
		 SELECT @innertax_name= tax_name,@innertax_rate= tax_rate,
		 @innertax_min_amt= tax_min_amt,@innertax_make_exclusive= tax_make_exclusive,
		 @innertax_make_tax_id= tax_make_tax_id,@innertax_deleted= tax_deleted
		FROM CDM_tblTAX_RATES where tax_id=@tax_id
		
		UPDATE  CDM_tblTAX_RATES
		SET tax_name = @tax_name,tax_rate = @tax_rate,tax_min_amt = @tax_min_amt,tax_type = @tax_type,tax_lastupdate = GETDATE()
		,tax_make_exclusive = @tax_make_exclusive,tax_make_tax_id = @tax_make_tax_id,tax_deleted = @tax_deleted,last_update = GETDATE(),EditorID = @EditorID,EditorName = @EditorName
		WHERE tax_id=@tax_id
		
		if (@innertax_name!=@tax_name or @innertax_rate!=@tax_rate or @innertax_min_amt!=@innertax_min_amt
		or @innertax_type!=@tax_type or @innertax_make_exclusive!=@tax_make_exclusive 
		or @innertax_make_tax_id!=@tax_make_tax_id or @innertax_deleted!=@tax_deleted )
		       INSERT INTO CDM_Transfer_tblTAX_RATES(tax_id,tax_name,tax_rate,tax_min_amt,tax_type,tax_lastupdate,
       tax_make_exclusive,tax_make_tax_id,tax_deleted,last_update,EditorID,EditorName,GUID,TransferState) VALUES (@tax_id,@tax_name,@tax_rate,@tax_min_amt,@tax_type,GETDATE(),
       @tax_make_exclusive,@tax_make_tax_id,@tax_deleted,GETDATE(),@EditorID,@EditorName,@GUID,1)
    commit tran
	end try
	begin catch
		rollback tran
    end catch
    else if (@sqlType='SQLDELETE')
    begin
		delete from  CDM_tblTAX_RATES WHERE tax_id=@tax_id
    end 
END
GO
