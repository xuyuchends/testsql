SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Group_sel]
	@ID int,
	@name nvarchar(200),
	@type int
AS
BEGIN
	if @type=1
	-- select all group
	begin
		select g.ID as ID,g.Name as name   from [Group] as g where g.Name<>'StoreUser'
	end
	else if @type=2
	-- select  group by id
	begin
		select g.ID as ID,g.Name as name,g.CanDelete as CanDelete,roleType as roleType  from [Group] as g where ID=@ID
	end
	else if @type=3
	-- select  group by Name
	begin
		select g.ID as ID,g.Name as name  from [Group] as g where name=@name
	end
	else if @type=4
	-- select enterprise group
	begin
		select g.ID as ID,g.Name as name  from [Group] as g where roleType=1
		order by case when candelete=0 then 1 else 2 end 
	end
	else if @type=5
	-- select store manager group
	begin
		select g.ID as ID,g.Name as name  from [Group] as g where roleType=2
		order by case when candelete=0 then 1 else 2 end 
	end
END
GO
