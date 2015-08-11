SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Company_InUpDel]
	@ShowRolesDesc bit
as 
update Company set ShowRolesDesc=@ShowRolesDesc
select @@ERROR
GO
