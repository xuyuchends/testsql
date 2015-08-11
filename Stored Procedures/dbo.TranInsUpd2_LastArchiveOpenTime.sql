SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[TranInsUpd2_LastArchiveOpenTime]
	@storeID int,
	@lastArchiveOpenTime datetime

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
update ConstTable set value=@lastArchiveOpenTime where Category='LastArchiveOpenTime' and id=@storeID
if (@@ROWCOUNT=0)
insert into ConstTable (Category,id,Value,IsDefault,Describe) values ('LastArchiveOpenTime',@storeID,@lastArchiveOpenTime,0,'')
END
GO
