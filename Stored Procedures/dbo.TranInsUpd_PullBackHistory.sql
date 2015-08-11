SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[TranInsUpd_PullBackHistory]
@StoreID int,
@OrderID bigint,
@CheckID bigint,
@Seat nvarchar(50),
@ServerID nvarchar(50),
@UserID nvarchar(50),
@PullBackDate datetime,
@ToTable nvarchar(50),
@Amount decimal,
@MethodID nvarchar(50),
@businessDate datetime,
@lineNum int
AS
BEGIN
 begin try
	INSERT INTO [PullBackHistory]
           ([StoreID]
           ,[OrderID]
           ,[CheckID]
           ,[Seat]
           ,[ServerID]
           ,[UserID]
           ,[PullBackDate]
           ,[ToTable]
           ,Amount
           ,MethodID
           ,BusinessDate
           ,LineNum
           ,[LastUpdate])
     VALUES
           (@StoreID
           ,@OrderID
           ,@CheckID
           ,@Seat
           ,@ServerID
           ,@UserID
           ,@PullBackDate
           ,@ToTable
           ,@Amount
           ,@MethodID
           ,@businessDate
           ,@lineNum
           ,getDate())
   end try
   begin Catch
   if @@ERROR<>0
   begin
 
		UPDATE [PullBackHistory]
		SET [StoreID] = @StoreID
		  ,[OrderID] =@OrderID
		  ,[CheckID] = @CheckID
		  ,[Seat] = @Seat
		  ,[ServerID] = @ServerID
		  ,[UserID] = @UserID
		  ,[PullBackDate] = @PullBackDate
		  ,[ToTable] = @ToTable
		  ,Amount=@Amount
		  ,MethodID=@MethodID
		  ,[LastUpdate] = getDate()
		WHERE StoreID = @StoreID and OrderID = @OrderID and BusinessDate=@businessDate
		and CheckID=@CheckID
		and LineNum=@lineNum
   end
end Catch
END
GO
