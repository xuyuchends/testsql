SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create PROCEDURE [dbo].[TranInsUpd2_Payment]
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
	INSERT INTO Payment (StoreID,CheckID,LineNum,MethodID,Amount,AmountReceived,Tip,Gratuity,BusinessDate,LastUpdate,Status)
	VALUES(@StoreID,@CheckID,@LineNum,@MethodID,@Amount,@AmountReceived,@Tip,@Gratuity,@BusinessDate,GETDATE(),@Status)

GO
