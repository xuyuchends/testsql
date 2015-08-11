SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[fn_GetAlterAllValue]
 
 (
	@StoreIDList nvarchar(2000),
	@AdjustedType nvarchar(20),
	@AlertFrequency int,
	@CreateDate datetime
 )  
 
 RETURNS nvarchar(100)
 
 AS  
 
 BEGIN 
declare @retValue nvarchar(2000)
declare @StoreID nvarchar(20)
declare @selValue nvarchar(20)
set @retValue=''
declare cur cursor
read_only
for select * from dbo.f_split(@StoreIDList,',')

open cur
fetch next from cur into @StoreID
while(@@fetch_status=0)
begin
	if ISNULL(@StoreID,'')<>''
	begin
		if isnull(@AdjustedType,'')='Comps'
		begin
			select @selValue=isnull(sum(AdjustedPrice*Qty),0) from orderlineitem where recordType='Comp'
			and storeID=@StoreID and BusinessDate between dbo.fn_GetAlterBeginDate(@AlertFrequency,@CreateDate) and dbo.fn_GetAlterEndDate(@AlertFrequency,@CreateDate)
		end
		else if isnull(@AdjustedType,'')='Voids'
		begin
			select @selValue=isnull(sum(AdjustedPrice*Qty),0) from orderlineitem where recordType='VOID'
			and storeID=@StoreID and BusinessDate between dbo.fn_GetAlterBeginDate(@AlertFrequency,@CreateDate) and dbo.fn_GetAlterEndDate(@AlertFrequency,@CreateDate)
		end
		else if isnull(@AdjustedType,'')='Overtime Cost'
		begin
			select @selValue=isnull(sum(ets.OT1HoursWorked*ets.OT1Payrate+ ets.OT2HoursWorked*ets.OT2Payrate),0) 
			from EmployeeTimeSheet as ets
			where  ets.StoreID=@StoreID and (ets.OT1HoursWorked*ets.OT1Payrate+ ets.OT2HoursWorked*ets.OT2Payrate)>0 
			and ets.BusinessDate BETWEEN dbo.fn_GetAlterBeginDate(@AlertFrequency,@CreateDate) and dbo.fn_GetAlterEndDate(@AlertFrequency,@CreateDate)
		end
		else if isnull(@AdjustedType,'')='Overtime Hours'
		begin
			select @selValue=isnull(sum(ets.OT1HoursWorked+ets.OT2HoursWorked),0) 
			from EmployeeTimeSheet as ets
			where  ets.StoreID=@StoreID and (ets.OT1HoursWorked*ets.OT1Payrate+ ets.OT2HoursWorked*ets.OT2Payrate)>0 
			and ets.BusinessDate BETWEEN dbo.fn_GetAlterBeginDate(@AlertFrequency,@CreateDate) and dbo.fn_GetAlterEndDate(@AlertFrequency,@CreateDate)
		end
		else if isnull(@AdjustedType,'')='Labor Costs'
		begin
			SELECT @selValue=SUM(ts.PayRate * ts.HoursWorked) + SUM(ts.OT1HoursWorked * ts.OT1Payrate+ts.OT2HoursWorked  * ts.OT2Payrate )
			FROM EmployeeTimeSheet as ts LEFT OUTER JOIN EmployeeJob  as ej
			ON ts.PositionID = ej.PositionID AND ts.EmployeeID = ej.EmployeeID and ts.StoreID=ej.StoreID
			WHERE ej.WageType = 'HOURLY'  AND ts.StoreID =@StoreID
			and ts.BusinessDate BETWEEN dbo.fn_GetAlterBeginDate(@AlertFrequency,@CreateDate) and dbo.fn_GetAlterEndDate(@AlertFrequency,@CreateDate)
		end
		
		else if isnull(@AdjustedType,'')='Net Cash Received'
		begin
			SELECT @selValue=dbo.fn_GetAlterNetCashReceived(dbo.fn_GetAlterBeginDate(@AlertFrequency,@CreateDate),dbo.fn_GetAlterEndDate(@AlertFrequency,@CreateDate),@StoreID)
		end
		else if isnull(@AdjustedType,'')='Cash Over'
		begin
			SELECT @selValue=dbo.[fn_GetAlterCashDeposit](dbo.fn_GetAlterBeginDate(@AlertFrequency,@CreateDate),dbo.fn_GetAlterEndDate(@AlertFrequency,@CreateDate),@StoreID)
		end
		else if isnull(@AdjustedType,'')='Cash Short'
		begin
			SELECT @selValue=dbo.[fn_GetAlterCashDeposit](dbo.fn_GetAlterBeginDate(@AlertFrequency,@CreateDate),dbo.fn_GetAlterEndDate(@AlertFrequency,@CreateDate),@StoreID)-dbo.fn_GetAlterNetCashReceived(dbo.fn_GetAlterBeginDate(@AlertFrequency,@CreateDate),dbo.fn_GetAlterEndDate(@AlertFrequency,@CreateDate),@StoreID)
		end
		
		if @retValue=''
			set @retValue=@selValue
		else
			set @retValue=@retValue+','+@selValue
	end

fetch next from cur into @StoreID
end
close cur
deallocate cur
 
 	RETURN @retValue
 
 END
 
GO
