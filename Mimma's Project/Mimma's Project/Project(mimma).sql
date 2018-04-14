create database Training_Management
go
use Training_Management
go
--Create store procedure with try catch(for Insert,Update,Delete)----
create table courses_by_type
(
	CoursetypeID int identity (1,1) primary key nonclustered,
	Coursetype varchar(50)
)
go
create clustered index ix_courses_by_type
on courses_by_type (Coursetype)
go
exec sp_helpindex courses_by_type
go
create proc spInsert_courses_by_type 
									@Coursetype varchar(50)
as
begin try
	insert into courses_by_type (Coursetype)values(@Coursetype)
end try
begin catch
	declare @msg varchar(100)
	set @msg = ERROR_MESSAGE()
	raiserror(@msg,10,1)
	return @msg
end catch
go
exec spInsert_courses_by_type 'weekend courses'
exec spInsert_courses_by_type 'certificate courses'
exec spInsert_courses_by_type 'customized courses'
exec spInsert_courses_by_type 'online courses'
go
-------------------------------------------------------------------
create table Course_Track
(
	Course_TrackID int identity (1,1) primary key,
	Course_Track varchar(50)
)
go
create proc spInsert_Course_Track 
								  @Course_Track varchar(50)
as
begin try
	insert into Course_Track values(@Course_Track)
end try
begin catch
	declare @msg varchar(100)
	set @msg = ERROR_MESSAGE()
	raiserror(@msg,10,1)
	return @msg
end catch
go
spInsert_Course_Track 'Administration'
exec spInsert_Course_Track 'Banking'
exec spInsert_Course_Track 'Business'
exec spInsert_Course_Track 'Development\NGO'
exec spInsert_Course_Track 'IT'
exec spInsert_Course_Track 'Law'
go
----------------------------------------------------------------------
create table Course_Track_Type
(
	Course_Track_TypeID int identity(1,1) primary key,
	coursetypeID int references courses_by_type(coursetypeID),
	Course_TrackID int references Course_Track(Course_TrackID)
)
go
insert into Course_Track_Type values(1,1),(1,2),(1,3),(1,4),(1,5),(1,6),
(2,1),(2,3),(2,5),(2,6)
go
------------------------------------------------------------------------
create table Courses
(
	CoursesID int identity (1,1) primary key nonclustered ,
	Course_Track_TypeID int references Course_Track_Type(Course_Track_TypeID),
	Courses varchar(100),
	Price money,
	Vat float
	
)
go
create proc spInsert_Course
							@Course_Track_TypeID int,
							@Courses varchar(100),
							@Price money,
							@Vat float
as
begin try
	insert into Courses values(@Course_Track_TypeID,@Courses,@Price,@Vat)
end try
begin catch
	declare @msg varchar(100)
	set @msg = ERROR_MESSAGE()
	raiserror(@msg,10,1)
	return @msg
end catch
go
spInsert_Course 1,'Management Skills for Administrative Professionals',8000,0.15
exec spInsert_Course 1,'Administration & Logistics Management',3500,0.15
exec spInsert_Course 7,'Management Skills for Administration and HR Professionals',8000,0.15
exec spInsert_Course 2,'Documentation of Loans and Advances',3000,0.15
exec spInsert_Course 3,'Export Import Business Management',3000,0.15
exec spInsert_Course 3,'Training on L/C - UPAS, Back to Back,Transferable, At Sight, Confirm, Irrevocable & others L/C',4500,0.15
exec spInsert_Course 4,'Project Proposal for Fund Raising',6000,0.15
exec spInsert_Course 4,'Professional Report Writing Skills',6000,0.15
exec spInsert_Course 5,'Microsoft Excel Formulas & Functions in Depth',5000,0.15
exec spInsert_Course 5,'Microsoft Excel 2013: Advanced Application Development',6000,0.15
exec spInsert_Course 6,'Disciplinary Action & Departmental Enquiry as Amended Labor Law - 2013',6000,0.15
exec spInsert_Course 10,'Labor Laws & Rules - 2015 in the Work Place',3500,0.15
exec spInsert_Course 8,'Documentation & Banking Procedure of Import Export Business',6000,0.15
exec spInsert_Course 9,'Microsoft Excel 2013 - Starter to Advance (with Case Studies)',7000,0.15
exec spInsert_Course 9,'Graphics Design Basics with Adobe Photoshop & Illustrator',6000,0.15
go
create proc spUpdate_Course
as
begin
	begin try
		begin transaction
			declare @CourseNew varchar(100), @Courses varchar(100)
			update Courses set Courses = @CourseNew where Courses = @Courses
		commit transaction
		print 'Update complete'
	end try
	begin catch
		rollback transaction
		print 'Update failed'
	end catch
end
go
create proc spDelete_Course
as
begin
	begin try
		begin transaction
			declare @Courses varchar(100)
			delete from Courses where Courses = @Courses
		commit
		print 'Delete complete'
	end try
	begin catch
		rollback transaction
		print 'Delete failed'
	end catch
end
go
--------------------------------------------------------------------------
create table Trainer
(
	TrainerID int identity (1,1) primary key,
	Trainer varchar(50),
	Qualification nvarchar(1000)
)
go
create proc spInsert_trainer 
							@Trainer varchar(50),
							@Qualification nvarchar(1000)
as
begin try
	insert into trainer values(@Trainer,@Qualification)
end try
begin catch
	declare @msg varchar(100)
	set @msg = ERROR_MESSAGE()
	raiserror(@msg,10,1)
	return @msg
end catch
go
exec spInsert_trainer 'Md. Arif Khan','M.Com, MBA, PGDIM, INT.DIPLOMA-SCM-(P), Switzerland'
exec spInsert_trainer 'Md. Delwar Hossain Bhuiyan', 'Managing Director'
exec spInsert_trainer 'Abu Shams Mahmood Arif', 'Associate Director'
exec spInsert_trainer 'Mostofa Monower','Analyst, Contact Experience, CSD Robi Axiata Limited'
exec spInsert_trainer 'Mohammad Mofidul Alam','General Manager, Training'
exec spInsert_trainer 'Moha. Rafiqul Islam','HR Professional'
go
create proc spDelete_trainer
as
begin
	begin try
		begin transaction
			declare @Trainer varchar(100)
			delete from trainer where trainer = @Trainer
		commit
		print 'Delete complete'
	end try
	begin catch
		rollback transaction
		print 'Delete failed'
	end catch
end
go
-------------------------------------------------------------------------------------
create table trainer_of_courses
(
	trainerID int references trainer(trainerID),
	coursesID int references courses(coursesID),
	primary key (trainerID,coursesID)
)
go
insert into trainer_of_courses values(1,1),(1,2),(1,10),
(2,2),(2,4),(2,12),
(3,3),(3,5),(3,11),
(4,4),(4,1),(4,13),
(5,5),(5,2),(5,14),
(6,6),(6,5),(6,12)
go
-------------------------------------------------------------------------------------------
create table Contact_Info
(
	Contact_InfoID int identity(1,1) primary key,
	Venue nvarchar(1000),
	Email varchar(20),
	Website varchar(30),
	Tell int,
	IP_Phone bigint,
	Cell_NO int

)
go
create proc spInsert_Contact_Info
							    @Venue nvarchar(1000),
								@Email varchar(20),
								@Website varchar(30),
								@Tell int,
								@IP_Phone bigint,
								@Cell_NO int
as
begin try
	insert into Contact_Info values(@Venue ,@Email,@Website,@Tell,@IP_Phone,@Cell_NO)
end try
begin catch
	declare @msg varchar(100)
	set @msg = ERROR_MESSAGE()
	raiserror(@msg,10,1)
	return @msg
end catch
go
spInsert_Contact_Info 'Bdjobs Training, BDBL Building (Level 19),
		 12 Kawran Bazar C/A, Dhaka 1215.','training@jobs.com','www.jobstraining.com', 9117179,09612444888,01811410862
go
---------------------------------------------------------------------------------------
create table Schedules
(
	SchedulesID int identity (1,1) primary key,
	Contact_InfoID int references Contact_Info(Contact_InfoID),
	CoursesID int references Courses(CoursesID),
	StartDates date,
	EndDates date,
	duration varchar(100),
	registration_last_date date,
	
)
go
create proc spInsert_schedules
								@Contact_InfoID int,
								@CoursesID int,
								@StartDates date,
								@EndDates date,
								@duration varchar(100),
								@registration_last_date date
as
begin try
	insert into schedules values(@Contact_InfoID,@CoursesID,@StartDates,@EndDates,@duration,@registration_last_date)
end try
begin catch
	declare @msg varchar(100)
	set @msg = ERROR_MESSAGE()
	raiserror(@msg,10,1)
	return @msg
end catch
go
exec spInsert_schedules 1,1,'9/15/2017','9/16/2017','Day(9.30 AM-5.30 PM)','9/14/2017'
exec spInsert_schedules 1,2,'10/14/2017','10/14/2017',' Morning(9:30 AM-5:30 PM)','9/12/2017'
exec spInsert_schedules 1,3,'9/29/2017','9/29/2017',' Day(9:30 AM-5:30 PM)','9/28/2017'
exec spInsert_schedules 1,4,'10/13/2017','10/13/2017','Day(9.30 AM-5.30 PM)','10/12/2017'
exec spInsert_schedules 1,5, '9/22/2017','9/22/2017','Day(9.30 AM-5.30 PM)','9/21/2017'
exec spInsert_schedules 1,6 ,'9/29/2017','9/29/2017','Day(9.30 AM-5.30 PM)','9/28/2017'
exec spInsert_schedules 1,7, '8/25/2017','8/26/2017','Day(9:30 AM-5:30 PM)','8/24/2017'
exec spInsert_schedules 1,8, '9/8/2017','9/8/2017','Day(9:30 AM-5:30 PM)','9/7/2017'
exec spInsert_schedules 1,9,'8/25/2017','8/25/2017','Day(9.30 AM-5.30 PM)','8/24/2017'
exec spInsert_schedules 1,10,'8/25/2017','8/26/2017','Day(9.30 AM-5.30 PM)','8/24/2017'
exec spInsert_schedules 1,11,'8/25/2017','8/26/2017','Day(9.30 AM-5.30 PM)','8/24/2017'
exec spInsert_schedules 1,12,'9/28/2017','10/8/2017','Day(9.30 AM-5.30 PM)','9/23/2017'
exec spInsert_schedules 1,13,'8/21/2017','9/6/2017','Evening(6.30pm-9.30pm)','8/20/2017'
exec spInsert_schedules 1,14,'8/21/2017','9/10/2017','Evening(6:30 PM-9:30 PM)','8/20/2017'
exec spInsert_schedules 1,15,'9/20/2017','10/4/2017','Evening(6:30 PM-9:30 PM)','9/19/2017'
go
create proc spUpdate_schedules
as
begin
	begin try
		declare     @StartDates date,
					@EndDates date,
					@duration varchar(100),
					@registration_last_date date,
					@CoursesID varchar(100)
			update schedules set StartDates = @StartDates where CoursesID = @CoursesID

			update schedules set EndDates = @EndDates where CoursesID = @CoursesID
			
			update schedules set duration = @duration where CoursesID = @CoursesID
			
			update schedules set registration_last_date = @registration_last_date where CoursesID = @CoursesID
			
		print 'Update complete'
	end try
	begin catch
		rollback
		print 'Update failed'
	end catch
end
go
update schedules set registration_last_date = '10/20/2017' where CoursesID = '15'
go
------------------------------------------------------------------------------------------------------------------
create table Payment
(
	Payment_No int identity(1,1) primary key,
	Amount money,
	Payment_Date date,
	CoursesID int references Courses(CoursesID)
)
go
create proc spInsert_Payment
							@Amount money,
							@Payment_Date date,
							@CoursesID int
as
begin try
	insert into Payment values(@Amount,@Payment_Date,@CoursesID)
end try
begin catch
	declare @msg varchar(100)
	set @msg = ERROR_MESSAGE()
	raiserror(@msg,10,1)
	return @msg
end catch
go
spInsert_Payment 2000,'7/8/2017',1
exec spInsert_Payment 3000,'8/5/2017',5
exec spInsert_Payment 3500,'7/20/2017',8
go
------------------------------------------------------------------------------------------------------
create proc spUpdate_Payment
as
begin
	begin try
		begin transaction
			declare @amount money, @payment_no int
			update Payment set Amount = @amount where Payment_No = @payment_no
		commit
		print 'Update complete'
	end try
	begin catch
		rollback transaction
		print 'Update failed'
	end catch
end
go
-------------------------------------------------------------------------------------------------------
create table Applicants
(
	Applicants_id int identity(1,1) primary key,
	Applicant_Name varchar (50),
	Transaction_Status varchar(20),
	Registration_No int references Payment(Payment_No)
)
go
------------------------------------------------------------------------------------------------------
create proc spInsert_Applicants
							    @Applicant_Name varchar (50),
								@Transaction_Status varchar(20),
								@Registration_No int
as
begin try
	insert into Applicants values(@Applicant_Name,@Transaction_Status,@Registration_No)
end try
begin catch
	declare @msg varchar(100)
	set @msg = ERROR_MESSAGE()
	raiserror(@msg,10,1)
	return @msg
end catch
go
-------------------------------------------------------------------------------------------------------
create proc spUpdate_Applicants
as
begin
	begin try
			declare   @Applicant_Name varchar (50),
					  @Transaction_Status varchar(20),
					  @Registration_No int
			update Applicants set Applicant_Name = @Applicant_Name where Registration_No = @Registration_No
			update Applicants set Transaction_Status = @Transaction_Status where Registration_No = @Registration_No

		print 'Update complete'
	end try
	begin catch
		rollback
		print 'Update failed'
	end catch
end
go
------------------------------------------------------------------------------------------------------------------
create proc spDelete_Applicants
as
begin
	begin try
		begin transaction
			declare @Applicant_Name varchar(100)
			delete from Applicants where Applicant_Name = @Applicant_Name
		commit
		print 'Delete complete'
	end try
	begin catch
		rollback transaction
		print 'Delete failed'
	end catch
end
go
--Create view to display all records-------------------------------------------------------------------
create view vw_coursedetails
as
select Coursetype,Course_Track,Courses,Trainer,StartDates,EndDates,duration,registration_last_date,
Venue,Price,Vat
from courses_by_type
inner join Course_Track_Type
on courses_by_type.CoursetypeID=Course_Track_Type.coursetypeID
inner join Course_Track
on Course_Track.Course_TrackID=Course_Track_Type.Course_TrackID
inner join Courses
on Courses.Course_Track_TypeID=Course_Track_Type.Course_Track_TypeID
inner join trainer_of_courses
on trainer_of_courses.coursesID= Courses.CoursesID
inner join trainer
on trainer.TrainerID=trainer_of_courses.trainerID
inner join schedules
on schedules.CoursesID=Courses.CoursesID
inner join Contact_Info
on Contact_Info.Contact_InfoID=schedules.Contact_InfoID
go
--Create view to display Contact information--------------------------------------------------------
create view vw_ContactInfo
as
select * from Contact_Info
go
--Create function to get price of a course(User will provide course name)---------------------------
create function fn_PriceOfCourse(@Courses varchar (100))
returns money
as
begin
	declare @price money
	select @price = Price+Price*Vat from Courses
	where Courses=@Courses
	return @price
end
go
--Create a table valued function to display all information of a course------------------------------------
create function fn_tablevalued (@CoursesTrack varchar(100), @CoursesType varchar(50))
returns table
as
return(select Coursetype,Course_Track,Courses,Trainer,StartDates,EndDates,duration,registration_last_date,
Venue,Price,Vat
from courses_by_type
inner join Course_Track_Type
on courses_by_type.CoursetypeID=Course_Track_Type.coursetypeID
inner join Course_Track
on Course_Track.Course_TrackID=Course_Track_Type.Course_TrackID
inner join Courses
on Courses.Course_Track_TypeID=Course_Track_Type.Course_Track_TypeID
inner join trainer_of_courses
on trainer_of_courses.coursesID= Courses.CoursesID
inner join trainer
on trainer.TrainerID=trainer_of_courses.trainerID
inner join schedules
on schedules.CoursesID=Courses.CoursesID
inner join Contact_Info
on Contact_Info.Contact_InfoID=schedules.Contact_InfoID
where Course_Track.Course_Track=@CoursesTrack and courses_by_type.Coursetype=@CoursesType)
go
--Create Trigger for restricted-------------------------------------------------------------------------
alter view ApplicantsPayment
as
select  dbo.fn_PriceOfCourse(Courses) 'Course Price', Applicants.Applicants_id,Applicants.Applicant_Name,Applicants.Registration_No,Applicants.Transaction_Status,
Payment.Amount,Payment.CoursesID,Payment.Payment_No,Payment.Payment_Date,Schedules.registration_last_date
from Applicants
inner join Payment
on Payment.Payment_No=Applicants.Registration_No
inner join schedules
on schedules.CoursesID=Payment.CoursesID
inner join Courses
on schedules.CoursesID=Courses.CoursesID
go
alter trigger tr_Applicants
on ApplicantsPayment
instead of insert
as
begin
	begin try
		begin transaction
			declare @amount money,@courses varchar(100),@Payment_Date date,@registration_last_date date
			select @amount = [Course Price] from Payment
			join inserted on inserted.Payment_No=Payment.Payment_No
			if @Payment_Date <= @registration_last_date
				begin
					insert into Applicants(Applicant_Name,Transaction_Status,Registration_No)
					select Applicant_Name,Transaction_Status,Registration_No
					from inserted
					print 'Registration Success'
				end
		commit
		
	end try
	begin catch
		rollback transaction
		print 'Registration failed. Please pay the total amount of the course'
	end catch
end
go
-------------------------------------------------------------------------------------------
--create trigger tr_Payment
--on Payment
--for insert
--as
--begin
--	begin transaction
--		declare @amount money
--		select @amount = dbo.fn_PriceOfCourse(Courses) from Courses
--		if @amount = (dbo.fn_PriceOfCourse(Courses) from Courses where course)
--	commit
--	rollback transaction
--end
go
-----------------------------------------------------------------------------------
select*from courses_by_type
select*from Course_Track
select*from Courses
select*from Schedules
select*from Contact_Info
select*from Applicants
------------------------------------------------------------------------------------
exec sp_helpindex courses_by_type
select * from vw_coursedetails
select * from ApplicantsPayment
select dbo.fn_PriceOfCourse('Management Skills for Administrative Professionals')
select dbo.fn_tablevalued('Administration','weekend courses')
exec spInsert_Payment 9200,'9/9/2017',1
exec spInsert_Payment 200,'9/9/2017',1
insert into ApplicantsPayment ([Course Price], Applicants.Applicants_id,Applicants.Applicant_Name,Applicants.Registration_No,Applicants.Transaction_Status,
Payment.Amount,Payment.CoursesID,Payment.Payment_No)
values(9200,101,'Mimma',123,'Paid',200,1,123)
insert into Applicants values(101,'Mimma','Paid',123)