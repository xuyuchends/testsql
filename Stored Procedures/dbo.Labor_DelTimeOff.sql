SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create proc [dbo].[Labor_DelTimeOff]
@ID int
as
delete from LaborTimeOff where ID = @ID
GO
