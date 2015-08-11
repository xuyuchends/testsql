SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[task_SendCompleteEmail]
	-- Add the parameters for the stored procedure here
	@TaskID int,
	@UserID int,
	@StoreID int,
	@Subject nvarchar(200),
	@content nvarchar(max)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    
    declare @CreateUserID int
    declare @userType nvarchar(20)
    select @userType=case when IsManager=1 and StoreID>0 then 't-m-'+CONVERT(nvarchar(20),StoreID) 
    when StoreID=0 then 't-e' end  from EnterpriseUser where ID=@UserID
    
    select @CreateUserID=UpdateUserID from Task where ID=@TaskID
  
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
			   ,@content
			   ,'t-u-'+CONVERT(nvarchar(20), @UserID)+','+'t-u-'+CONVERT(nvarchar(20),@CreateUserID)
			   +','+@userType
			   ,GETDATE()
			   ,0
			   ,@StoreID
			   ,@UserID
			   )
			   
			
END
GO
