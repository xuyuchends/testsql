SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[TranInsUpd_MenuItem]
@StoreID int,
@ID int ,
@Name nvarchar(50),
@Category nvarchar(50),
@Department nvarchar(50),
@Price money,
@IsModifier bit,
@MIType varchar(10),
@ReportName  nvarchar(50),
@Cost money,
@UpcNumber nvarchar(50),
@DoubleItemID int,
@IsDouble bit
AS
BEGIN
declare @innerCategory nvarchar(50)
declare @innerDepartment nvarchar(50)
declare @innerReportCategory nvarchar(50)
declare @innerReportDepartment nvarchar(50)
declare @innerName nvarchar(50)
declare @innerReportName nvarchar(50)
select @innerCategory=Category ,@innerDepartment=Department,
@innerReportCategory=ReportCategory,@innerReportDepartment=ReportDepartment,
@innerName=Name,@innerReportName=ReportName from MenuItem  WHERE StoreID = @StoreID and ID = @ID
--if find,insert，not find update.
if @@ROWCOUNT=0
begin
	INSERT INTO MenuItem (StoreID,ID,Name,Category,Department,Price,IsModifier,ReportName,MIType,cost,LastUpdate,ReportCategory,ReportDepartment,[status],UpcNumber,doubleItemID,isDouble)
	 VALUES(@StoreID, @ID, @Name,@Category,@Department,@Price,@IsModifier,@Name, @MIType,@cost,getDate(),@Category,@Department,'Normal',@UpcNumber,@DoubleItemID,@IsDouble)
end
else
begin
	if (@Category<>@innerCategory)
	begin
		-- if menuitem category=menuitem reportcategory ,update category and reportcategory column
		if (@innerCategory=@innerReportCategory)
		begin
			UPDATE MenuItem SET Category=@Category ,ReportCategory=@Category WHERE StoreID = @StoreID and ID = @ID
		end
		-- if menuitem category<>menuitem reportcategory ,not update category and reportcategory column
		else
		begin
			UPDATE MenuItem SET Category=@Category WHERE StoreID = @StoreID and ID = @ID
		end
	end
	if (@Department<>@innerDepartment)
	begin
		-- if menuitem Department=menuitem reportDepartment ,update Department and reportDepartment column
		if (@innerDepartment=@innerReportDepartment)
		begin
			UPDATE MenuItem SET Department=@Department,ReportDepartment=@Department WHERE StoreID = @StoreID and ID = @ID
		end
		-- if menuitem Department<>menuitem reportDepartment ,not update Department and reportDepartment column
		else
		begin
			UPDATE MenuItem SET Department=@Department WHERE StoreID = @StoreID and ID = @ID
		end
	end
	if (@Name<>@innerName)
	begin
		-- if menuitem Name=menuitem reportName ,update Name and reportName column
		if (@innerName=@innerReportName)
		begin
			UPDATE MenuItem SET Name=@Name,ReportName=@Name WHERE StoreID = @StoreID and ID = @ID
		end
		-- if menuitem Name<>menuitem reportName ,not update Name and reportName column
		else
		begin
			UPDATE MenuItem SET Name=@Name WHERE StoreID = @StoreID and ID = @ID
		end
	end
	UPDATE MenuItem SET Price=@Price,IsModifier=@IsModifier,LastUpdate = getDate(),MIType=@MIType ,Cost=@Cost,[status]='Normal'
	,UpcNumber=@UpcNumber,doubleItemID=@DoubleItemID,isDouble=@IsDouble
	WHERE StoreID = @StoreID and ID = @ID
end
END

GO
