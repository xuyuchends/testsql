SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[TranInsUpd_Employee]
@StoreID int,
@ID int ,
@FirstName nvarchar(50),
@LastName nvarchar(50), 
@PayrollID nvarchar(50), 
@SSN nvarchar(200), 
@DOE datetime, 
@Address1 nvarchar(200), 
@Address2 nvarchar(200), 
@City nvarchar(50), 
@State nvarchar(50), 
@ZipCode nvarchar(50), 
@Phone nvarchar(50), 
@EmergencyContact nvarchar(50), 
@EmergencyNumber nvarchar(50), 
@HasPayrollReport bit, 
@EmployeeLastUpdate datetime, 
@JobStatus nvarchar(50), 
@MaritalStatus nvarchar(50), 
@Gender nvarchar(50), 
@BirthDate datetime, 
@IsTerminated bit, 
@TerminatedReason nvarchar(50), 
@TerminationDate datetime, 
@Explanation nvarchar(50), 
@DriversLicenseExpDate datetime, 
@InsuranceExpDate datetime

AS
BEGIN
 begin try
	INSERT INTO Employee(StoreID,ID,FirstName,LastName,PayrollID,
		SSN,DOE,Address1,Address2,City,[State],
		ZipCode,Phone,EmergencyContact,EmergencyNumber,HasPayrollReport,
		EmployeeLastUpdate,JobStatus,MaritalStatus,Gender,BirthDate,
		IsTerminated,TerminatedReason,TerminationDate,Explanation,DriversLicenseExpDate,
		InsuranceExpDate,LastUpdate,Status)
	VALUES(@StoreID,@ID,@FirstName,@LastName,@PayrollID,
		@SSN,@DOE,@Address1,@Address2,@City,@State,
		@ZipCode,@Phone,@EmergencyContact,@EmergencyNumber,@HasPayrollReport,
		@EmployeeLastUpdate,@JobStatus,@MaritalStatus,@Gender,@BirthDate,
		@IsTerminated,@TerminatedReason,@TerminationDate,@Explanation,@DriversLicenseExpDate,
		@InsuranceExpDate,GETDATE(),'Normal')
end try
begin Catch
if @@ERROR<>0
 UPDATE Employee SET FirstName = @FirstName,LastName = @LastName,PayrollID = @PayrollID,SSN = @SSN,
	DOE = @DOE,Address1 = @Address1,Address2 = @Address2,City = @City,
	[State] = @State,ZipCode = @ZipCode,Phone = @Phone,EmergencyContact = @EmergencyContact,
	EmergencyNumber = @EmergencyNumber,HasPayrollReport = @HasPayrollReport,EmployeeLastUpdate = @EmployeeLastUpdate,
	JobStatus = @JobStatus,MaritalStatus = @MaritalStatus,Gender = @Gender,BirthDate = @BirthDate,
	IsTerminated = @IsTerminated,TerminatedReason = @TerminatedReason,TerminationDate = @TerminationDate,Explanation = @Explanation,
	DriversLicenseExpDate = @DriversLicenseExpDate,InsuranceExpDate = @InsuranceExpDate,LastUpdate = getDate() 
	,Status='Normal' where ID=@ID and StoreID=@StoreID
end Catch

END
GO
