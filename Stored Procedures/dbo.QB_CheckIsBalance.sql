SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
---new sql

CREATE  proc [dbo].[QB_CheckIsBalance]
 
 (
	@eventID int,
	@isBalance nvarchar(20) output
 )  
 AS  

 BEGIN 
 	 declare @DEBIT decimal(18,2)
	 declare @CREDIT decimal(18,2)
 	   declare @BeginTime datetime
    declare @EndTime datetime
    declare @ProfileID int
    select @BeginTime=BeginTime,@EndTime=EndTime,@ProfileID=ProfileID from QB_Event where RefNum=@eventID
	declare @adjestmentTable table
	(
	[EventID] [int] NULL,
	[BeginTime] [datetime] NULL,
	[EndTime] [datetime] NULL,
	[Adjustments] [decimal](38, 6) NULL,
	[AdjustName] [nvarchar](200) NOT NULL,
	[AdjustType] [nvarchar](50) NOT NULL,
	[QBType] [nvarchar](50) NOT NULL,
	[QBName] [nvarchar](200) NOT NULL,
	[ClassName] [nvarchar](200) NOT NULL,
	[Vendor] [nvarchar](200) NULL
	)
	insert into @adjestmentTable exec QB_Adjustment @eventID
	select @DEBIT=sum(Adjustments) from @adjestmentTable where QBType='DEBIT'
	 select @CREDIT=sum(Adjustments) from @adjestmentTable where QBType='CREDIT'
	if @DEBIT-@CREDIT<>0
		set @isBalance='N'
	else 
	begin
		set @isBalance='Y'
	end
 END
GO
