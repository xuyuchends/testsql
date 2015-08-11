SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
 create proc [dbo].[RptGetAllPaymentName]
        (
			@StoreID int
        )
        as
        select dbo.fn_GetPaymentName(@StoreID)
GO
