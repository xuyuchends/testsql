SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[sel_ConstTable]
	@category nvarchar(20)
	
as
select id,Value,IsDefault,Describe from ConstTable where Category=@category

GO
