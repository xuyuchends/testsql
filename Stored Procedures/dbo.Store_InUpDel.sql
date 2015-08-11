SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Store_InUpDel]
(
	@SQLOperationType nvarchar(50),
	@StoreID int,
	@StoreName nvarchar(50),
	@LocationID nvarchar(50),
	@Phone nvarchar(50),
	@Address nvarchar(50),
	@AddressCont nvarchar(50),
	@City nvarchar(20),
	@State nvarchar(50),
	@ZipCode nvarchar(20)
)
as
declare @RowCount int
declare @reValue int
if @SQLOperationType='SQLUpdate'
begin
	select @RowCount=COUNT(*) from Store where LocationID=@LocationID and id<>@StoreID
	if @RowCount=0
	begin
		update Store set StoreName=@StoreName,
						LocationID=@LocationID,
						Phone=@Phone,
						Address=@Address,
						[Address Cont.]=@AddressCont,
						City=@City,
						[State/Province]=@State,
						[Zip/Postal Code]=@ZipCode
						where ID=@StoreID
		set @reValue=0
	end
	else
	begin
		set @reValue=1  --LocationID is Exist
	end
end
select @reValue
GO
