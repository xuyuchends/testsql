SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CDM_tblMENU_ITEM_ALTERNATE_PRICING_InUpDel]
@Menu_ItemID nvarchar(10) ,
@Effective_Day char(1) ,
@Effective_Begin_Time datetime ,
@Effective_End_Time datetime ,
@Alternate_Price money ,
@All_Day_Price char(1) ,
	@sqlType nvarchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	if (@sqlType='SQLINSERT')
		INSERT INTO CDM_tblMENU_ITEM_ALTERNATE_PRICING(Menu_ItemID,Effective_Day,Effective_Begin_Time,Effective_End_Time,Alternate_Price,All_Day_Price) VALUES (@Menu_ItemID,@Effective_Day,@Effective_Begin_Time,@Effective_End_Time,@Alternate_Price,@All_Day_Price)
	else if (@sqlType='SQLDELETE')
		delete from CDM_tblMENU_ITEM_ALTERNATE_PRICING where Menu_ItemID=@Menu_ItemID
END
GO
