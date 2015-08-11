SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [dbo].[QB_EventInUpDel]
@RefNumber int,
@ProfileID int,
@BeginTime datetime,
@EndTime datetime,
@State int,
@EditorID int,
@EditorName nvarchar(200),
@LastUpdate datetime,
@Type int,
@RefID int output,
@isBalance nvarchar(20) output
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	if(@Type =1)
		begin
		declare @error int
		set @error=0
			begin tran
			exec QB_GetNotBalanceOrder @BeginTime,@EndTime,@RefID
			insert into QB_Event(ProfileID,BeginTime,EndTime,[State],EditorID,LastUpdate,EditorName,isBalance)
			values(@ProfileID,@BeginTime,@EndTime,@State,@EditorID,@LastUpdate,@EditorName,'Y')
			set @error=@error+@@ERROR
			set @RefID = @@IDENTITY
			 exec QB_CheckIsBalance @RefID,@isBalance output
			 set @error=@error+@@ERROR
			update QB_Event set isBalance=@isBalance where RefNum=@RefID
			set @error=@error+@@ERROR
			update QB_ExcludeOrder set EventID=@RefID where EventID is null
			set @error=@error+@@ERROR
			select * from QB_ExcludeOrder where eventID=@RefID
			set @error=@error+@@ERROR
			if @error>0
				rollback tran
			else
				commit tran
			
		end
	else if(@Type = 2)
		begin
			update QB_Event set ProfileID =@ProfileID,BeginTime=@BeginTime,EndTime = @EndTime,[State]=@State,EditorID=@EditorID,LastUpdate=@LastUpdate
			where RefNum =@RefNumber 
		end
	else if(@Type =3)
		begin
			delete from QB_Event where RefNum = @RefNumber
			delete from QB_ExcludeOrder where eventid=@RefNumber
		end
	else if(@Type =4)
		begin
		update QB_Event set [State]=@State ,DownLoadUserName =@EditorName
		where RefNum =@RefNumber 
		end
END

GO
