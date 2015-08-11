SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[TranInsUpd_DeliveryReimbursements]
@StoreID   int,
@EmployeeID   nvarchar(10),
@ReimbursementTtl   money,
@Status   nvarchar(10),
@BusinessDate   datetime
AS
begin try
    INSERT INTO [DeliveryReimbursements]
           ([StoreID]
           ,[EmployeeID]
           ,[ReimbursementTtl]
           ,[Status]
           ,[BusinessDate]
           ,[LastUpdate])
     VALUES
           (@StoreID
           ,@EmployeeID
           ,@ReimbursementTtl
           ,@Status
           ,@BusinessDate
           ,GETDATE())
END TRY
BEGIN CATCH
	if @@ERROR <>0
		UPDATE [DeliveryReimbursements]
   SET [ReimbursementTtl] = @ReimbursementTtl
      ,[Status] = @Status
      ,[BusinessDate] = @BusinessDate
      ,[LastUpdate] = GETDATE()
 WHERE [StoreID] = @StoreID and [EmployeeID] = @EmployeeID
end  CATCH

GO
