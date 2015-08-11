SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Inv_ItemCategory_Sel]
(
	@ID int,
	@Name nvarchar(200),
	@ParentID int,
	@GroupID int,
	@GLAccount nvarchar(200),
	@IsActive bit,
	@LastUpdate datetime,
	@Creator int,
	@Editor int,
	@SQLOperationType nvarchar(50)
)
as
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	if (@SQLOperationType='SQLSELECT')
		if (isnull(@IsActive,'')='')
			SELECT ID,Name,ParentID,GroupID,GLAccount,DisplaySeq,IsActive,LastUpdate,Creator,Editor,Layer from Inv_ItemCategory
			order by DisplaySeq asc
		else
			SELECT ID,Name,ParentID,GroupID,GLAccount,DisplaySeq,IsActive,LastUpdate,Creator,Editor,Layer from Inv_ItemCategory
			where IsActive=@IsActive
			order by DisplaySeq asc
			
	else if (@SQLOperationType='SQLSELECTDETAIL')
		SELECT ic.ID as ID,ic.Name as Name,ic.ParentID as ParentID, pic.Name as ParentName,ic.GroupID,
		ig.Name as GroupName, ic.GLAccount as GLAccount,ic.DisplaySeq as DisplaySeq,
		ic.IsActive as IsActive,ic.LastUpdate as LastUpdate,ic.Creator as Creator,ic.Editor  as Editor,ic.Layer
		from Inv_ItemCategory as ic left outer join Inv_ItemCategory as pic on ic.ParentID=pic.id
		left outer join Inv_ItemGroup as ig on ic.GroupID=ig.ID
		where ic.ID=@ID
END
GO
