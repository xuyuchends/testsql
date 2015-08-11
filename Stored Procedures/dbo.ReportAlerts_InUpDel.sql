SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[ReportAlerts_InUpDel]
(
	@SQLOperationType nvarchar(50),
	@AlertID int,
	@AlertName nvarchar(50),
	@TriggerBelowValues nvarchar(50),
	@TriggerAboveValues nvarchar(50),
	@StartDate datetime,
	@EndDate datetime,
	@AlertFrequency int,
	@SendtoStore nvarchar(20),
	@UserID int,
	@Sendto nvarchar(5)
)
as
if @SQLOperationType='SQLInsert'
begin
INSERT INTO ReportAlert
           ([AlertName]
           ,[TriggerBelowValues]
           ,[TriggerAboveValues]
           ,[StartDate]
           ,[EndDate]
           ,[AlertFrequency]
           ,[SendtoStore]
           ,[UserID]
           ,[CreateDate]
           ,[Sendto])
     VALUES
           (
           @AlertName,
           @TriggerBelowValues,
           @TriggerAboveValues,
           @StartDate,
           @EndDate,
           @AlertFrequency,
           @SendtoStore,
           @UserID,
           GETDATE(),
           @Sendto)
           select @@IDENTITY
end
else if @SQLOperationType='SQLUpdate'
begin
UPDATE ReportAlert
SET [AlertName] = @AlertName
      ,[TriggerBelowValues] = @TriggerBelowValues
      ,[TriggerAboveValues] = @TriggerAboveValues
      ,[StartDate] = @StartDate
      ,[EndDate] = @EndDate
      ,[AlertFrequency] = @AlertFrequency
      ,[SendtoStore] = @SendtoStore
      ,[UserID] =@UserID
      ,[Sendto] = @Sendto
WHERE ID=@AlertID
end
else if @SQLOperationType='SQLDelete'
	begin
		delete from ReportAlert where ID=@AlertID
		select @@ERROR	
	end
GO
