SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create PROCEDURE [dbo].[QB_AdjustmentCategorySelNew]
@ID int,
@Type int,
@Cateogry nvarchar(20),
@adjustType nvarchar(50),
@adjustName nvarchar(50),
@StoreID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    if(@Type = 0)
		begin
			if ISNULL(@Cateogry,'')=''
			begin
				if isnull(@adjustType,'')=''
				begin
					select  ID,Name,Type from QB_AdjustmentCategory where ID = @ID order by name
				end
				else
				begin
					select ID,Name,Type,case when am.QBID is null then 1 else 0 end IsCheck
					from QB_AdjustmentCategory ac left join 
					QB_AdjustmentMatch am on ac.ID=am.OppQBID 
					and StoreID=@StoreID and AdjustType=@adjustType
					order by IsCheck,Name
				end
			end	
			else if ISNULL(@Cateogry,'')='Category'
			begin
				--select StoreID,Name,Type,case when am.QBID is null then 1 else 0 end IsCheck
				--from QB_AdjustmentCategory ac left join 
				--QB_AdjustmentMatch am on ac.ID=am.QBID and am.AdjustName=@adjustName and am.AdjustType=@adjustType
				--and StoreID=@StoreID
				--where type=@Cateogry
				--order by IsCheck,Name
				select isnull(storeid,0) storeid, ID,Name,Type,am.AdjustName,am.AdjustType,case when am.QBID is null then 1 else 0 end IsCheck
				from QB_AdjustmentCategory ac inner join 
				QB_AdjustmentMatch am on ac.ID=am.QBID 
				where type=@Cateogry
				order by IsCheck,Name
			 end
			 else if isnull(@Cateogry,'')='ClassRet'
			 begin
				  select ID,Name,Type,case when id=(select distinct QBClassID from QB_AdjustmentMatch where AdjustType=@adjustType
 and storeid=@StoreID) then 0 else 1 end IsCheck
				from QB_AdjustmentCategory 
				where type=@Cateogry
				order by IsCheck,Name
				
			 end
			 else if isnull(@Cateogry,'')='VendorRet'
			 begin
				select ID,Name,Type,case when am.QBVendorID is null then 1 else 0 end IsCheck
				from QB_AdjustmentCategory ac left join 
				QB_AdjustmentMatch am on ac.ID=am.QBVendorID and am.AdjustName=@adjustName and am.AdjustType=@adjustType
				and StoreID=@StoreID
				where type=@Cateogry
				order by IsCheck,Name
			 end
		end
	else if(@Type = 1)
		begin
			if ISNULL(@Cateogry,'')=''
			select  ID,Name,Type from QB_AdjustmentCategory where ID = @ID order by name
			else
			select ID,Name,Type from QB_AdjustmentCategory where ID = @ID and type=@Cateogry order by name
		end
		else if @type=2
		begin
			if ISNULL(@Cateogry,'')='Category'
			begin
			select  ID,Name,Type from QB_AdjustmentCategory where type=@Cateogry  order by Name
			end
		end
END

GO
