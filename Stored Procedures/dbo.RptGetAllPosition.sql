SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
 create proc [dbo].[RptGetAllPosition]
        (
			@StoreID int
        )
        as
        select dbo.fn_GetPosition(@StoreID)
GO
