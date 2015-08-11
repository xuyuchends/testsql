SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[TranInsUpd_Payment]
@StoreID int ,
@CheckID bigint ,
@LineNum int ,
@MethodID nvarchar(50) ,
@Amount money ,
@AmountReceived money,
@Tip money ,
@Gratuity money ,
@BusinessDate datetime ,
@Status nvarchar(20)
AS
begin try
	INSERT INTO Payment (StoreID,CheckID,LineNum,MethodID,Amount,AmountReceived,
		Tip,Gratuity,BusinessDate,LastUpdate,Status)
	VALUES(@StoreID,@CheckID,@LineNum,@MethodID,@Amount,@AmountReceived,
		@Tip,@Gratuity,@BusinessDate,GETDATE(),@Status)
END TRY
BEGIN CATCH
	if @@ERROR <>0
		UPDATE Payment SET MethodID=@MethodID,Amount=@Amount,AmountReceived=@AmountReceived,Tip=@Tip,Gratuity=@Gratuity,
		BusinessDate=@BusinessDate,LastUpdate=GETDATE(),Status=@Status
		where  StoreID=@StoreID and CheckID=@CheckID and LineNum=@LineNum and BusinessDate=@BusinessDate
end  CATCH
GO
