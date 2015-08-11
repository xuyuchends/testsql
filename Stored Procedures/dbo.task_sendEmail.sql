SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[task_sendEmail]
	-- Add the parameters for the stored procedure here
	@Subject nvarchar(200),
	@ContentText nvarchar(max),
	@StoreID int,
	@UserID int,
	@OldSentToStores nvarchar(max),
	@TaskID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    if isnull(@OldSentToStores,'')=''
    set @OldSentToStores='-1'
    
    declare @AssignedStoreID nvarchar(max)
    declare @retValue nvarchar(max)
    declare @UserName nvarchar(200)
    select @UserName =FirstName+' '+LastName  from EnterpriseUser where ID=@UserID
    set @retValue=''
    declare cur cursor for
	select case when  AssignedStoreID=0 then 't-e' else 't-m-'+convert(nvarchar(20), AssignedStoreID) end
	from TaskDetail  b where b.AssignedStoreID not in 
	(select col from dbo.f_split(@OldSentToStores,',')) and TaskID=@TaskID
	
	open cur
	fetch next from cur into @AssignedStoreID 
	while @@FETCH_STATUS=0
	begin
		if @retValue=''
			set @retValue=@AssignedStoreID
			else
			set @retValue=@retValue+','+@AssignedStoreID
	fetch next from cur into @AssignedStoreID 
	end
	CLOSE cur
	DEALLOCATE cur
	
	if @retValue<>''
		INSERT INTO [EmailSendAgain]
			   ([Type]
			   ,[Subject]
			   ,[ContentText]
			   ,[AddressTo]
			   ,sendtime
			   ,HasSend
			   ,StoreID
			   ,FromUserID
			   )
		 VALUES
			   ('Task'
			   ,@Subject
			   ,@ContentText
			   ,@retValue
			   ,GETDATE()
			   ,0
			   ,@StoreID
			   ,@UserID
			   )
END
GO
