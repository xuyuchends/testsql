SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[sel_AllAdjustmentRpt]
(
	@storeID nvarchar(2000)
)
as
begin
set nocount on

select distinct AdjustName from (
select distinct Name+'(VOID)' as AdjustName,StoreID from Void
union all
select distinct Name+'(COMP)' as AdjustName,StoreID from Comp
union all
select distinct Name+'(COUPON)' as AdjustName,StoreID from Coupon
union all
select distinct Name+'(DISCOUNT)' as AdjustName,StoreID from Discount) b
where StoreID in (select * from dbo.f_split(@storeid,','))

end
GO
