SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create PROCEDURE [dbo].[QB_AllAdjustment_SelNew]
	-- Add the parameters for the stored procedure here
	@adjustType nvarchar(200),
	@StoreID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    if ISNULL(@adjustType,'')='VOID'
	select v.StoreID,ID,Name,'VOID' AdjustedType,case when ISNULL(AdjustName,'')='' then 0 else 1 end isCheck,am.QBType from Void v left join QB_AdjustmentMatch am
on v.Name=am.AdjustName and am.AdjustType='VOID' and v.StoreID=am.storeid
where v.StoreID=@StoreID
--order by Name

	 if ISNULL(@adjustType,'')='COMP'
	select v.StoreID,ID,Name,'COMP' AdjustedType,case when ISNULL(AdjustName,'')='' then 0 else 1 end isCheck,am.QBType from Comp v left join QB_AdjustmentMatch am
on v.Name=am.AdjustName and am.AdjustType='COMP' and v.StoreID=am.storeid
where v.StoreID=@StoreID
--order by Name

	if ISNULL(@adjustType,'')='DISCOUNT'
	select v.StoreID,ID,Name,'DISCOUNT' AdjustedType,case when ISNULL(AdjustName,'')='' then 0 else 1 end isCheck,am.QBType from Discount v left join QB_AdjustmentMatch am
on v.Name=am.AdjustName and am.AdjustType='DISCOUNT' and v.StoreID=am.storeid
where v.StoreID=@StoreID
--order by Name

	if ISNULL(@adjustType,'')='COUPON'
	select v.StoreID,ID,Name,'COUPON' AdjustedType,case when ISNULL(AdjustName,'')='' then 0 else 1 end isCheck,am.QBType from Coupon v left join QB_AdjustmentMatch am
on v.Name=am.AdjustName and am.AdjustType='COUPON' and v.StoreID=am.storeid
where v.StoreID=@StoreID
--order by Name

--Other Income
if ISNULL(@adjustType,'')='Other Income'
begin
	select StoreID,0,'Gift Certificate Sales' Name,'Other Income' AdjustedType,case when ISNULL(AdjustName,'')='' then 0 else 1 end isCheck,am.QBType
	 from Store s left join QB_AdjustmentMatch am on s.ID=am.StoreID 
	and AdjustType='Other Income' and AdjustName='Gift Certificate Sales'
	where id=@StoreID
	union
	select StoreID,0,'In House Payments' Name,'Other Income' AdjustedType,case when ISNULL(AdjustName,'')='' then 0 else 1 end isCheck,am.QBType
	from Store s left join QB_AdjustmentMatch am on s.ID=am.StoreID 
	and AdjustType='Other Income' and AdjustName='In House Payments'
	where ID=@StoreID
	union
	select s.id StoreID,0,'Advance Payments (net)' Name,'Other Income' AdjustedType,case when ISNULL(AdjustName,'')='' then 0 else 1 end isCheck,am.QBType
	 from Store s left join QB_AdjustmentMatch am on s.ID=am.StoreID 
	and AdjustType='Other Income' and AdjustName='Advance Payments (net)'
	where ID=@StoreID
	union
	select s.ID StoreID,0,'Surcharge Collected' Name,'Other Income' AdjustedType,case when ISNULL(AdjustName,'')='' then 0 else 1 end isCheck,am.QBType
	 from Store s left join QB_AdjustmentMatch am on s.ID=am.StoreID 
	and AdjustType='Other Income' and AdjustName='Surcharge Collected'
	where ID=@StoreID
	end
	
	-- Expenditures / Adjustments
	if  ISNULL(@adjustType,'')='Expenditures / Adjustments'
	begin
		select id StoreID,0,'Previous payments from Future Order' Name,'Expenditures / Adjustments' AdjustedType,
		am.AdjustType ,
		case when ISNULL(AdjustName,'')='' then 0 else 1 end isCheck,am.QBType
	from Store s left join QB_AdjustmentMatch am on s.ID=am.StoreID 
	and AdjustType='Expenditures / Adjustments' and AdjustName='Previous payments from Future Order'
	where ID=@StoreID
	end
	
	if ISNULL(@adjustType,'')='Gross Sales'
	begin
		select a.StoreID,0,Department Name,'Gross Sales' AdjustedType,
		case when ISNULL(AdjustName,'')='' then 0 else 1 end isCheck,am.QBType
		 from (select distinct Department,StoreID from MenuItem) a left join QB_AdjustmentMatch am
		on a.StoreID=am.StoreID and a.Department=am.AdjustName and am.AdjustType='Gross Sales'
		where a.StoreID=@storeid order by Department
	end
	if ISNULL(@adjustType,'')='Payment'
	begin
		select a.StoreID,0,a.Name,'Payment' AdjustedType,
		case when ISNULL(AdjustName,'')='' then 0 else 1 end isCheck,am.QBType
		 from PaymentMethod a left join QB_AdjustmentMatch am
		on a.StoreID=am.StoreID and a.Name=am.AdjustName and am.AdjustType='Payment'
		where a.StoreID=@StoreID 
		order by Name
	end
	if ISNULL(@adjustType,'')='Tax'
	begin
		select a.StoreID,0,a.Name,'Tax' AdjustedType,
		case when ISNULL(AdjustName,'')='' then 0 else 1 end isCheck,am.QBType
		 from TaxCategory a left join QB_AdjustmentMatch am
		on a.StoreID=am.StoreID and a.Name=am.AdjustName and am.AdjustType='Tax'
		where a.StoreID=@StoreID
		order by Name
	end
	if ISNULL(@adjustType,'')='Paid Ins'
	begin
		select ID StoreID,0,'Paid Ins' Name,'Paid Ins' AdjustedType,
		case when ISNULL(AdjustName,'')='' then 0 else 1 end isCheck ,am.QBType
		from Store s left join QB_AdjustmentMatch am on s.ID=am.StoreID and am.AdjustType='Paid Ins'
		and AdjustName='Paid Ins'
		where ID=@StoreID
	end
	if ISNULL(@adjustType,'')='Paid Out'
	begin
		select ID StoreID,0,'Paid Out' Name,'Paid Out' AdjustedType,
		case when ISNULL(AdjustName,'')='' then 0 else 1 end isCheck ,am.QBType
		from Store s left join QB_AdjustmentMatch am on s.ID=am.StoreID and am.AdjustType='Paid Out'
		and AdjustName='Paid Out'
		where ID=@StoreID
	end
END
GO
