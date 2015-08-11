SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Subscription_InUpDel]
(
	@SQLOperationType nvarchar(50),
	@ID int,
	@Name nvarchar(50),
	@ReportDetailID int,
	@Frequency nvarchar(50),
	@Startdate datetime,
	@EndDate datetime,
	@SendTime nvarchar(20),
	@SendToMe bit,
	@SendTo nvarchar(20),
	@FileType nvarchar(20),
	@lastSendDate datetime,
	@UserID int
	
)
as
declare @NameOld nvarchar(50)
declare @ReportDetailIDOld int
declare @FrequencyOld nvarchar(50)
declare @StartDateOld datetime
declare @EndDateOld datetime
declare @SendTimeOld nvarchar(20)
declare @SendToMeOld bit
declare @SendToOld nvarchar(20)
declare @FileTypeOld nvarchar(20)
declare @lastSendDateOld datetime
declare @error int
if @SQLOperationType='SQLInsert'
begin
	INSERT INTO [ReportSubscription]
           ([Name]
           ,[ReportDetailID]
           ,[Frequency]
           ,[StartDate]
           ,[EndDate]
           ,[SendTime]
           ,[SendToMe]
           ,[SendTo]
           ,[FileType]
           ,[CreatedDate]
           ,UserID)
     VALUES(@Name,@ReportDetailID,@Frequency,@Startdate,@EndDate,@SendTime,@SendToMe,@SendTo,@FileType,GETDATE(),@UserID)
   select @@IDENTITY
end
else if @SQLOperationType='SQLUpdate'
	begin
		select @NameOld=[Name],@ReportDetailIDOld=[ReportDetailID],@FrequencyOld=[Frequency],@StartDateOld=[StartDate],@EndDateOld=[EndDate],@SendTimeOld=[SendTime],@SendToMeOld=[SendToMe],@SendToOld=[SendTo],@FileTypeOld=[FileType],	@lastSendDateOld=LastSendDate from [ReportSubscription] where ID=@ID
		if ISNULL(@Name,'')='' begin set @Name=@NameOld end
		if ISNULL(@ReportDetailID,'0')='0' begin set @ReportDetailID=@ReportDetailIDOld end
		if ISNULL(@Frequency,'')='' begin set @Frequency=@FrequencyOld end
		if ISNULL(@StartDate,'')='' begin set @StartDate=@StartDateOld end
		if ISNULL(@EndDate,'')='' begin set @EndDate=@EndDateOld end
		if ISNULL(@SendTime,'')='' begin set @SendTime=@SendTimeOld end
		if ISNULL(@SendToMe,'')='' begin set @SendToMe=@SendToMeOld end
		if ISNULL(@SendTo,'')='' begin set @SendTo=@SendToOld end
		if ISNULL(@FileType,'')='' begin set @FileType=@FileTypeOld end
		if ISNULL(@lastSendDate,'')='' begin set @lastSendDate=@lastSendDateOld end
		update [ReportSubscription] set Name=@Name,ReportDetailID=@ReportDetailID,Frequency=@Frequency,StartDate=@StartDate,EndDate=@EndDate,SendTime=@SendTime,SendToMe=@SendToMe,SendTo=@SendTo,FileType=@FileType,LastSendDate=@lastSendDate
	where ID=@ID
		select @@ERROR	
	end
	else if @SQLOperationType='SQLDelete'
	begin
		begin tran
		delete from ReportParaValue where SubscriptionID=@ID
		set  @error = @@ERROR	
		delete from [ReportSubscription] where ID=@ID
		set  @error = @error+@@ERROR	
		if @error>0
		rollback tran
		else
		commit tran	
	end
GO
