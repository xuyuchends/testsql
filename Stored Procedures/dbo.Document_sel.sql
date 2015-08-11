SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Document_sel]
	@ID int,
	@CategoryID int,
	@type int,
	@UserID int,
	@StoreID int
AS
BEGIN
	declare @UserType nvarchar(20)
	
	select @UserType=(case when StoreID=0 then 'EnterpriseUser' 
				when StoreID>0 and IsManager=1 then 'StoreManager'
				else 'StoreEmployee' end)   from EnterpriseUser where ID=@UserID
	--if @UserType='EnterpriseUser' and @StoreID>0
	--begin
	--	set @UserType='StoreManager'
	--end
	if @type=1
	begin
		print @UserType
		if @UserType='EnterpriseUser'
		begin
			if @StoreID>0
			begin
				SELECT 
				COUNT(*) as [count],
				dm.CategoryID,
				case dm.CategoryID when 0 then  'Unfiled Documents' else dc.Name end as CategoryName
				FROM [DocumentManager] dm
				left join [DocumentCateogry] dc on dm.CategoryID=dc.ID
				where (@StoreID in (select * from dbo.f_split(dm.CanViewStoreID,',')) and (WhoCanView=2
				or WhoCanView=3 or WhoCanView=6 or WhoCanView=7 )) or (dm.UserID=@UserID and isnull(CanViewStoreID,'0')='0' and PubStoreID=@StoreID)
				group by dm.CategoryID,dc.Name
			end
			else
			begin
			SELECT 
			COUNT(*) as [count],
			dm.CategoryID,
			case dm.CategoryID when 0 then  'Unfiled Documents' else dc.Name end as CategoryName
			FROM [DocumentManager] dm
			left join [DocumentCateogry] dc on dm.CategoryID=dc.ID
			where dm.pubStoreID=@StoreID and (WhoCanView=1
			or WhoCanView=3 or WhoCanView=5 or WhoCanView=7 or dm.UserID=@UserID)
			group by dm.CategoryID,dc.Name
			end
		end
		else if @UserType='StoreManager'
		begin
			SELECT 
			COUNT(*) as [count],
			dm.CategoryID,
			case dm.CategoryID when 0 then  'Unfiled Documents' else dc.Name end as CategoryName
			FROM [DocumentManager] dm
			left join [DocumentCateogry] dc on dm.CategoryID=dc.ID
			where (@StoreID in (select * from dbo.f_split(dm.CanViewStoreID,',')) and (WhoCanView=2
			or WhoCanView=3 or WhoCanView=6 or WhoCanView=7 )) or (dm.UserID=@UserID and isnull(CanViewStoreID,'0')='0')
			group by dm.CategoryID,dc.Name
		end
		else if @UserType='StoreEmployee'
		begin
			SELECT 
			COUNT(*) as [count],
			dm.CategoryID,
			case dm.CategoryID when 0 then  'Unfiled Documents' else dc.Name end as CategoryName
			FROM [DocumentManager] dm
			left join [DocumentCateogry] dc on dm.CategoryID=dc.ID
			where @StoreID in (select * from dbo.f_split(dm.CanViewStoreID,',')) and (WhoCanView=4
			or WhoCanView=5 or WhoCanView=6 or WhoCanView=7)
			group by dm.CategoryID,dc.Name
		end
		
	end
	else if @type=2
	begin
		if @UserType='EnterpriseUser'
		begin
			if @StoreID>0
			begin
				SELECT dm.[ID]
				  ,dm.[Name]
				  ,[Description]
				  ,[FileSize]
				  ,[FilePath]
				  ,[FileAlias]
				  ,[CategoryID]
				  ,[UserID]
				  ,eu.FirstName+' '+eu.LastName UserName
				  ,[UpdateTime]
				  ,[FileType]
				  ,case dm.CategoryID when 0 then  'Unfiled Documents' else dc.Name end as CategoryName
				  ,WhoCanView
				  ,WhoCanEdit
				  ,CanViewStoreID
				  ,PubStoreID
				  ,UpdateUserID
			FROM [DocumentManager] dm
			left join [DocumentCateogry] dc on dm.CategoryID=dc.ID
			inner join EnterpriseUser eu on dm.UserID=eu.ID
			where (@StoreID in (select * from dbo.f_split(dm.CanViewStoreID,',')) and (WhoCanView=2
			or WhoCanView=3 or WhoCanView=6 or WhoCanView=7 )) or (dm.UserID=@UserID and isnull(CanViewStoreID,'0')='0' and PubStoreID=@StoreID)
			end
			else
			begin
			SELECT dm.[ID]
				  ,dm.[Name]
				  ,[Description]
				  ,[FileSize]
				  ,[FilePath]
				  ,[FileAlias]
				  ,[CategoryID]
				  ,[UserID]
				  ,eu.FirstName+' '+eu.LastName UserName
				  ,[UpdateTime]
				  ,[FileType]
				  ,case dm.CategoryID when 0 then  'Unfiled Documents' else dc.Name end as CategoryName
				  ,WhoCanView
				  ,WhoCanEdit
				  ,CanViewStoreID
				  ,PubStoreID
				  ,UpdateUserID
			FROM [DocumentManager] dm
			left join [DocumentCateogry] dc on dm.CategoryID=dc.ID
			inner join EnterpriseUser eu on dm.UserID=eu.ID
			where dm.pubStoreID=@StoreID and (WhoCanView=1
				or WhoCanView=3 or WhoCanView=5 or WhoCanView=7 or dm.UserID=@UserID) 
				End
			end
		else if @UserType='StoreManager'
		begin
			SELECT dm.[ID]
				  ,dm.[Name]
				  ,[Description]
				  ,[FileSize]
				  ,[FilePath]
				  ,[FileAlias]
				  ,[CategoryID]
				  ,[UserID]
				  ,eu.FirstName+' '+eu.LastName UserName
				  ,[UpdateTime]
				  ,[FileType]
				  ,case dm.CategoryID when 0 then  'Unfiled Documents' else dc.Name end as CategoryName
				  ,WhoCanView
				  ,WhoCanEdit
				  ,CanViewStoreID
				  ,PubStoreID
				  ,UpdateUserID
			FROM [DocumentManager] dm
			left join [DocumentCateogry] dc on dm.CategoryID=dc.ID
			inner join EnterpriseUser eu on dm.UserID=eu.ID
			where (@StoreID in (select * from dbo.f_split(dm.CanViewStoreID,',')) and (WhoCanView=2
			or WhoCanView=3 or WhoCanView=6 or WhoCanView=7 )) or (dm.UserID=@UserID and isnull(CanViewStoreID,'0')='0')
		end 
		else if @UserType='StoreEmployee'
		begin
			SELECT dm.[ID]
				  ,dm.[Name]
				  ,[Description]
				  ,[FileSize]
				  ,[FilePath]
				  ,[FileAlias]
				  ,[CategoryID]
				  ,[UserID]
				  ,eu.FirstName+' '+eu.LastName UserName
				  ,[UpdateTime]
				  ,[FileType]
				  ,case dm.CategoryID when 0 then  'Unfiled Documents' else dc.Name end as CategoryName
				  ,WhoCanView
				  ,WhoCanEdit
				  ,CanViewStoreID
				  ,PubStoreID
				  ,UpdateUserID
			FROM [DocumentManager] dm
			left join [DocumentCateogry] dc on dm.CategoryID=dc.ID
			inner join EnterpriseUser eu on dm.UserID=eu.ID
			where @StoreID in (select * from dbo.f_split(dm.CanViewStoreID,',')) and (WhoCanView=4
			or WhoCanView=5 or WhoCanView=6 or WhoCanView=7)
		End
	end
	else if @type=3
	begin
		if @UserType='EnterpriseUser'
		begin
			if @StoreID>0
			begin
				SELECT dm.[ID]
				  ,dm.[Name]
				  ,[Description]
				  ,[FileSize]
				  ,[FilePath]
				  ,[FileAlias]
				  ,[CategoryID]
				  ,[UserID]
				  ,eu.FirstName+' '+eu.LastName UserName
				  ,[UpdateTime]
				  ,[FileType]
				  ,case dm.CategoryID when 0 then  'Unfiled Documents' else dc.Name end as CategoryName
				  ,WhoCanView
				  ,WhoCanEdit
				  ,CanViewStoreID
				  ,PubStoreID
				  ,UpdateUserID
			FROM [DocumentManager] dm
			left join [DocumentCateogry] dc on dm.CategoryID=dc.ID
			inner join EnterpriseUser eu on dm.UserID=eu.ID
			where dm.[CategoryID]=@CategoryID
			and ((@StoreID in (select * from dbo.f_split(dm.CanViewStoreID,',')) and (WhoCanView=2
			or WhoCanView=3 or WhoCanView=6 or WhoCanView=7 )) or (dm.UserID=@UserID and isnull(CanViewStoreID,'0')='0' and PubStoreID=@StoreID))
			end
			else
			begin
			SELECT dm.[ID]
				  ,dm.[Name]
				  ,[Description]
				  ,[FileSize]
				  ,[FilePath]
				  ,[FileAlias]
				  ,[CategoryID]
				  ,[UserID]
				  ,eu.FirstName+' '+eu.LastName UserName
				  ,[UpdateTime]
				  ,[FileType]
				  ,case dm.CategoryID when 0 then  'Unfiled Documents' else dc.Name end as CategoryName
				  ,WhoCanView
				  ,WhoCanEdit
				  ,CanViewStoreID
				  ,PubStoreID
				  ,UpdateUserID
			FROM [DocumentManager] dm
			left join [DocumentCateogry] dc on dm.CategoryID=dc.ID
			inner join EnterpriseUser eu on dm.UserID=eu.ID
			where dm.[CategoryID]=@CategoryID
			and dm.pubStoreID=@StoreID and (WhoCanView=1
				or WhoCanView=3 or WhoCanView=5 or WhoCanView=7 or dm.UserID=@UserID) 
				end
			end
		else if @UserType='StoreManager'
		begin
			SELECT dm.[ID]
				  ,dm.[Name]
				  ,[Description]
				  ,[FileSize]
				  ,[FilePath]
				  ,[FileAlias]
				  ,[CategoryID]
				  ,[UserID]
				  ,eu.FirstName+' '+eu.LastName UserName
				  ,[UpdateTime]
				  ,[FileType]
				  ,case dm.CategoryID when 0 then  'Unfiled Documents' else dc.Name end as CategoryName
				  ,WhoCanView
				  ,WhoCanEdit
				  ,CanViewStoreID
				  ,PubStoreID
				  ,UpdateUserID
			FROM [DocumentManager] dm
			left join [DocumentCateogry] dc on dm.CategoryID=dc.ID
			inner join EnterpriseUser eu on dm.UserID=eu.ID
			where dm.[CategoryID]=@CategoryID
			and ((@StoreID in (select * from dbo.f_split(dm.CanViewStoreID,',')) and (WhoCanView=2
			or WhoCanView=3 or WhoCanView=6 or WhoCanView=7 )) or (dm.UserID=@UserID and isnull(CanViewStoreID,'0')='0'))
		end 
		else if @UserType='StoreEmployee'
		begin
			SELECT dm.[ID]
				  ,dm.[Name]
				  ,[Description]
				  ,[FileSize]
				  ,[FilePath]
				  ,[FileAlias]
				  ,[CategoryID]
				  ,[UserID]
				  ,eu.FirstName+' '+eu.LastName UserName
				  ,[UpdateTime]
				  ,[FileType]
				  ,case dm.CategoryID when 0 then  'Unfiled Documents' else dc.Name end as CategoryName
				  ,WhoCanView
				  ,WhoCanEdit
				  ,CanViewStoreID
				  ,PubStoreID
				  ,UpdateUserID
			FROM [DocumentManager] dm
			left join [DocumentCateogry] dc on dm.CategoryID=dc.ID
			inner join EnterpriseUser eu on dm.UserID=eu.ID
			where dm.[CategoryID]=@CategoryID
			and @StoreID in (select * from dbo.f_split(dm.CanViewStoreID,',')) and (WhoCanView=4
			or WhoCanView=5 or WhoCanView=6 or WhoCanView=7)
		End
	end
	else if @type=4
	begin
		SELECT dm.[ID]
			  ,dm.[Name]
			  ,[Description]
			  ,[FileSize]
			  ,[FilePath]
			  ,[FileAlias]
			  ,[CategoryID]
			  ,[UserID]
			  ,eu.FirstName+' '+eu.LastName UserName
			  ,[UpdateTime]
			  ,[FileType]
			  ,case dm.CategoryID when 0 then  'Unfiled Documents' else dc.Name end as CategoryName
			  ,WhoCanView
			  ,WhoCanEdit
			  ,CanViewStoreID
			  ,PubStoreID
			  ,UpdateUserID
		FROM [DocumentManager] dm
		left join [DocumentCateogry] dc on dm.CategoryID=dc.ID
		inner join EnterpriseUser eu on dm.UserID=eu.ID
		where dm.[ID]=@ID
			
	end
END
GO
