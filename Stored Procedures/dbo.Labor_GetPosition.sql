SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE proc [dbo].[Labor_GetPosition]
@StoreID int,
@Oper nvarchar(20)
as
if(@Oper = 'ALL')
begin
SELECT distinct Name  FROM  Position
end
ELSE
BEGIN
SELECT *  FROM  Position where StoreID =@StoreID
END
GO
