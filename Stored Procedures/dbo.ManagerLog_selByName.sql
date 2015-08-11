SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create proc [dbo].[ManagerLog_selByName]
(
	@Name nvarchar(50)
)
as

declare @ManagerLogID int
select @ManagerLogID=ID from ManagerLog where Name=@Name
select * from ManagerLog where ParentID=@ManagerLogID
GO
