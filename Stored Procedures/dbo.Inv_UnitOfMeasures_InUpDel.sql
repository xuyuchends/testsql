SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create proc [dbo].[Inv_UnitOfMeasures_InUpDel]
(
	@ID int,
	@Name nvarchar(200),
	@Creator int,
	@Editor int,
	@sqlType nvarchar(200)
)
as
if ISNULL(@sqlType,'')='SQLINSERT'
begin
	INSERT INTO Inv_UnitOfMeasures
           (Name
           ,Creator
           ,Editor
           ,[LastUpdate])
     VALUES (@Name,@Creator,@Editor,GETDATE())
     select @@IDENTITY
end
else if ISNULL(@sqlType,'')='SQLUPDATE'
begin
	update Inv_UnitOfMeasures set Name=@Name,[Editor]=@Editor,[LastUpdate]=GETDATE() where id=@ID
end

GO
