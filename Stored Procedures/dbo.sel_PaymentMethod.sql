SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[sel_PaymentMethod]
(
	@storeID int,
	@PaymentType nvarchar(50)
)
as
begin
Declare @Sql as nvarchar(max)
SET NOCOUNT ON;
if isnull(@PaymentType,'')=''
set @Sql='select distinct PaymentType from PaymentMethod where StoreID='+convert(nvarchar(20),@storeID )
else
set @Sql='select distinct ID,Name from PaymentMethod where StoreID='+convert(nvarchar(20),@storeID)
+' and PaymentType='''+ @PaymentType+''''
--select @sql
exec sp_executesql @sql
end
GO
