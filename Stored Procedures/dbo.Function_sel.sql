SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Function_sel]
@UserType int,
@UserID int,
@ParentID int,  --父FunctionID,
@Level	int,    --要取的Function 级别(1为父function,2为子function)
@TabMenuID int, --
@GroupID int,   --
@Type int
	
AS
BEGIN
	-- get available function list
	SET NOCOUNT ON;
	if @type=1
	begin
		-- enterprise user
		if (@UserType=1 or @UserType=2)
		begin
			select f.ID as ID,f.Name as Name,f.Path as Path from [Function]as f inner join GroupToFunction as gtf on f.ID=gtf.FunctionID
			inner join GroupToUser as gtu on gtf.GroupID=gtu.GroupID
			where gtu.UserID=@UserID and f.TabMenuID=@TabMenuID and f.PathLevel=@Level and f.Enable=1 and AllOrOneShow & @UserType=@UserType
			and f.ParnetID=@ParentID
			order by f.Sort asc
		end
		-- store manager
		else if (@UserType=4)
		begin
			select f.ID as ID,f.Name as Name,f.Path as Path from [Function] as f inner join GroupToFunction as gtf on f.ID=gtf.FunctionID
			inner join [Group] as g on g.ID=gtf.GroupID
			where g.Name='StoreManager' and f.TabMenuID=@TabMenuID and f.PathLevel=@Level and f.Enable=1 and f.ParnetID=@ParentID
			order by f.Sort asc
		end
		-- store user
		else if (@UserType=8)
		begin
			select f.ID as ID,f.Name as Name,f.Path as Path from [Function] as f inner join GroupToFunction as gtf on f.ID=gtf.FunctionID
			inner join [Group] as g on g.ID=gtf.GroupID
			where g.Name='StoreUser' and f.TabMenuID=@TabMenuID and f.PathLevel=@Level and f.Enable=1 and f.ParnetID=@ParentID
			order by f.Sort asc
		end
	end
	
	else if @Type=2
	-- select all function by group
	begin
	  select ID ,Name
	  from [Function]
	  where PathLevel=@Level and ParnetID=@ParentID and Enable=1 and TabMenuID=@TabMenuID
	  order by [Function].Sort asc
	end
	else if @Type=3
	begin
	  select *
	  from GroupToFunction gf
	  left join [Function] f on gf.FunctionID=f.ID
	  where gf.GroupID=@GroupID
	  order by f.Sort asc
	end
END

GO
