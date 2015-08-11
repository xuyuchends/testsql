SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Inv_Location_Sel]
(
	@ID int,
	@Name nvarchar(200),
	@ParentID int,
	@StoreID nvarchar(200),
	@LastUpdate datetime,
	@Creator int,
	@Editor int
)
as
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;		  
		if ISNULL(@ID,0)<>0
		begin
			SELECT [ID]
			  ,[Name]
			  ,[ParentID]
			  ,[StoreID]
			  ,[DisplaySeq]
			  ,[LastUpdate]
			  ,[Creator]
			  ,[Editor] from Inv_Location where ID=@ID and [StoreID]=@StoreID order by DisplaySeq asc
		end
		else 
		begin
			if @ParentID is not null
			begin
			select [ID]
			  ,[Name]
			  ,[ParentID]
			  ,[StoreID]
			  ,[DisplaySeq]
			  ,[LastUpdate]
			  ,[Creator]
			  ,[Editor] from Inv_Location where [ParentID]=@ParentID and [StoreID]=@StoreID order by DisplaySeq asc
			end
			else
			begin
				select [ID]
			  ,[Name]
			  ,[ParentID]
			  ,[StoreID]
			  ,[DisplaySeq]
			  ,[LastUpdate]
			  ,[Creator]
			  ,[Editor] from Inv_Location where [StoreID]=@StoreID order by DisplaySeq asc
			end
		end
		
END

GO
