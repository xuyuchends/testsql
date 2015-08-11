SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Rpt_GetDriverReimbursement]
(
	@BeginDate datetime,
	@EndDate datetime,
	@storeID nvarchar(200)
)
as
begin
Declare @Sql as nvarchar(max)
SET NOCOUNT ON;
set @sql='SELECT isnull(SUM(ReimbursementTtl) ,0) ReimbursementTtl
FROM	DeliveryReimbursements
WHERE  status = ''CLOSED'' and    BusinessDate BETWEEN '''+ Convert(nvarchar,@BeginDate,120)+ ''' AND '''+ Convert(nvarchar,@EndDate,120) + '''
AND StoreID in ('+@storeID+')'
--select @Sql
exec sp_executesql @sql
end
GO
