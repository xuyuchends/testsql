SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[TranInsUpd_TransDateRecord]
(
	@StoreID int,
	@BeginTime datetime,
	@EndTime datetime,
	@TransferType nvarchar(50),
	@HasCalculated bit,
	@SQLType nvarchar(50)
)
as
if @SQLType='SQLINSERT'
	insert into TransDateRecord(StoreID,BeginTime,EndTime,SendDate,TransferType,HasCalculated) values(@StoreID,@BeginTime,@EndTime,GETDATE(),@TransferType,@HasCalculated)
else if @SQLType='SQLUPDATE'
	update TransDateRecord set HasCalculated=1 where StoreID=@StoreID
GO
