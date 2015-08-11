SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[QB_AdjustmentMatchSel]
@Type int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    if(@Type = 0)
		begin
			select AdjustType,AdjustName,StoreID,QBID,QBType,OppQBID,QBClassID,QBVendorID from QB_AdjustmentMatch
		end

END
GO
