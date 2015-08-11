SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[LoopingCalculateDailySummaryByTransDateRecord]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

declare @ID int
declare @storeID int
declare @BeginTime datetime
declare @EndTime datetime
declare curTransDateRecord cursor for select ID, StoreID,BeginTime,EndTime from TransDateRecord where HasCalculated=0 
open curTransDateRecord
fetch next from curTransDateRecord into @ID, @storeID,@BeginTime,@EndTime
while (@@FETCH_STATUS=0)
begin
exec CalculateDailySummaryPeriod  @BeginTime,@EndTime,@storeID
update TransDateRecord set HasCalculated=1 where ID=@ID
fetch next from curTransDateRecord into @ID, @storeID,@BeginTime,@EndTime
end
CLOSE curTransDateRecord
DEALLOCATE curTransDateRecord
END
GO
