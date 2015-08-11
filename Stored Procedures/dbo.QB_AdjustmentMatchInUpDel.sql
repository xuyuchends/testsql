SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[QB_AdjustmentMatchInUpDel]
	@AdjustType nvarchar(200),
	@AdjustName nvarchar(200),
	@StoreID int,
	@QBID nvarchar(200),
	@QBType nvarchar(200),
	@OppQBID nvarchar(200),
	@QBClassID nvarchar(50),
	@QBVendorID nvarchar(50),
	@Type int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    if(@Type=0)
		begin
			insert into QB_AdjustmentMatch(AdjustName,StoreID,AdjustType,QBID,QBType,OppQBID,QBClassID,QBVendorID) 
			values (@AdjustName,@StoreID,@AdjustType,@QBID,@QBType,@OppQBID,@QBClassID,@QBVendorID)
		end
	else if(@Type=1)
		begin
			delete from QB_AdjustmentMatch 
		end
END
GO
