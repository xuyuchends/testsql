SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Position_InUpDel]
(
@SQLOperationType nvarchar(50),
	@PositionName nvarchar(50),
	@AllowShiftTrades bit,
	@ManagerApprovalforTrades bit,
	@ViewAllSchedules bit,
	@StoreID nvarchar(200)
	
)
as
declare @sqlAll nvarchar(2000)
if @SQLOperationType='SQLUpdate'
	begin
		set @sqlAll =  'update Position set AllowShiftTrades='+convert(nvarchar(20),@AllowShiftTrades)+',
						ManagerApprovalforTrades='+convert(nvarchar(20),@ManagerApprovalforTrades)+',
						[View/PrintAllSchedules]='+convert(nvarchar(20),@ViewAllSchedules)+'
						where Name='''+@PositionName+''' and StoreID in ('+@StoreID+')'
						
						execute sp_executesql @sqlAll
		
	end

select @@ERROR
GO
