use aszaflar_a
--CreateParticpant
IF OBJECT_ID('dbo.CreateParticpant', 'P') IS NOT NULL
  DROP PROCEDURE dbo.CreateParticpant
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE CreateParticpant
@FirstName varchar(30),
@LastName varchar(30),
@Email varchar(100),
@Phone varchar(20),
@StudentNumCard int,
@Address_ID varchar(50)
AS
BEGIN
SET NOCOUNT ON;
IF @FirstName IS NULL
  THROW 51000, '@FirstName is null', 1
IF @LastName IS NULL
  THROW 51000, '@LastName is null', 1
IF @Email IS NULL
  THROW 51000, '@Email is null', 1
IF @Phone IS NULL
 THROW 51000, '@Phone is null', 1
IF @Address_ID IS NULL
  THROW 51000, 'Address_ID is null', 1
INSERT INTO Participant
(firstname, lastname, email, phone, studentNumCard, addressID_FK)
VALUES (@FirstName, @LastName, @Email, @Phone, @StudentNumCard, @Address_ID)
END
GO

--CreateAddress
IF OBJECT_ID('dbo.CreateAddress', 'P') IS NOT NULL
  DROP PROCEDURE dbo.CreateAddress
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE CreateAddress
@AddressName varchar(30),
@ZipCode varchar(6),
@City varchar(50),
@Street varchar(50),
@Number int,
@Country varchar(30)
AS
BEGIN
SET NOCOUNT ON;
IF @ZipCode IS NULL
	THROW 51000, '@ZipCode is null', 1
IF @City IS NULL
	THROW 51000, '@City is null', 1
IF @Street IS NULL
	THROW 51000, '@Street is null', 1
IF @Number IS NULL
	THROW 51000, '@Number is null', 1
IF @Country IS NULL
	THROW 51000, '@Country is null', 1
INSERT INTO Address
(addressName, zipCode, city, street, number, country)
VALUES (@AddressName, @ZipCode, @City, @Street, @Number, @Country)
END
GO

--CreateClient
IF OBJECT_ID('dbo.CreateClient', 'P') IS NOT NULL
  DROP PROCEDURE dbo.CreateClient
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE CreateClient
@CompanyID int,
@ParticpantID int
AS
BEGIN
SET NOCOUNT ON;
INSERT INTO Client
(CompanyID_FK, participantID_FK)
VALUES (@CompanyID, @ParticpantID)
END
GO

--CreateCompany
IF OBJECT_ID('dbo.CreateCompany', 'P') IS NOT NULL
  DROP PROCEDURE dbo.CreateCompany
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE CreateCompany
@Name varchar(100),
@NIP int,
@Regon varchar(100),
@Email varchar(100),
@Phone varchar(20),
@Fax varchar(20),
@Address_ID int
AS
BEGIN
SET NOCOUNT ON;
IF @Name IS NULL
	THROW 51000, '@Name is null', 1
IF @Nip IS NULL
	THROW 51000, '@Nip is null', 1
IF @Email IS NULL
	THROW 51000, '@Email is null', 1
IF @Phone IS NULL
	THROW 51000, '@Phone is null', 1
IF @Address_ID IS NULL
	THROW 51000, '@Address_ID is null', 1
INSERT INTO Company
(name, nip, regon, email, phone, fax, addressID_FK)
VALUES (@Name, @Nip, @Regon, @Email, @Phone, @Fax, @Address_ID)
END
GO

--CreateConference
IF OBJECT_ID('dbo.CreateConference', 'P') IS NOT NULL
  DROP PROCEDURE dbo.CreateConference
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE CreateConference
@Name varchar(100),
@Address_ID int
AS
BEGIN
SET NOCOUNT ON;
IF @Address_ID IS NULL
	THROW 51000, '@Address_ID is null', 1
INSERT INTO Conference
(conferenceName, addressID_FK)
VALUES (@Name, @Address_ID)
END
GO

--CreateConferenceDay
IF OBJECT_ID('dbo.CreateConferenceDay', 'P') IS NOT NULL
DROP PROCEDURE dbo.CreateConferenceDay
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE CreateConferenceDay
@Seats int,
@StartTime date,
@EndTime date,
@BasePrice numeric(10,2),
@ConferenceID int
AS
BEGIN
SET NOCOUNT ON;
IF @Seats IS NULL
	THROW 51000, '@Seats is null', 1
IF @StartTime IS NULL
	THROW 51000, '@StartTime is null', 1
IF @EndTime IS NULL
	THROW 51000, '@EndTime is null', 1
IF @BasePrice IS NULL
	THROW 51000, '@BasePrice is null', 1
IF @ConferenceID IS NULL
	THROW 51000, '@ConferenceID is null', 1
INSERT INTO ConferenceDay
(seats, startTime, endTime, basePrice, conferenceID_FK)
VALUES (@Seats, @StartTime, @EndTime, @BasePrice, @ConferenceID)
END
GO

--CreateConfDayReg
IF OBJECT_ID('dbo.CreateConfDayReg', 'P') IS NOT NULL
  DROP PROCEDURE dbo.CreateConfDayReg
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE CreateConfDayReg
@ConfRes_ID int,
@Participant_ID int
AS
BEGIN
SET NOCOUNT ON;
IF @ConfRes_ID IS NULL
	THROW 51000, '@ConfResID is null', 1
IF @Participant_ID IS NULL
	THROW 51000, '@Participant_ID is null', 1
INSERT INTO ConferenceDayRegistration
(conferenceDayReservationID_FK,participantID_FK)
VALUES (@ConfRes_ID, @Participant_ID)
END
GO

--CreateConfDayRes
IF OBJECT_ID('dbo.CreateConfDayRes', 'P') IS NOT NULL
DROP PROCEDURE dbo.CreateConfDayRes
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE CreateConfDayRes
@ReservationDate date,
@CancelledDate date,
@Paid numeric(10,2),
@ParticipantsNumber int,
@ConfDay_ID int,
@Client_ID int
AS
BEGIN
SET NOCOUNT ON;
IF @ReservationDate IS NULL
	THROW 51000, '@ReservationDate is null', 1
IF @Paid IS NULL
	THROW 51000, '@Paid is null', 1
IF @ParticipantsNumber IS NULL
	THROW 51000, '@ParticipantsNumbe is null', 1
IF @ConfDay_ID IS NULL
	THROW 51000, '@ConfDay_ID is null', 1
IF @Client_ID IS NULL
	THROW 51000, '@Client_ID is null', 1
INSERT INTO ConferenceDayReservation
(reservationDate, cancelledDate, paid, participantsNumber, conferenceDayID_FK, clientID_FK)
VALUES (@ReservationDate, @CancelledDate, @Paid, @ParticipantsNumber, @ConfDay_ID, @Client_ID)
END
GO

--CreateConfPrice
IF OBJECT_ID('dbo.CreateConfPrice', 'P') IS NOT NULL
  DROP PROCEDURE dbo.CreateConfPrice
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE CreateConfPrice
@Discount numeric(10,2),
@Remains smallint,
@Conference_ID int
AS
BEGIN
SET NOCOUNT ON;
IF @Conference_ID IS NULL
	THROW 51000, '@Conference_ID is null', 1
INSERT INTO ConferencePrice
(discountForStudents, daysRemain, conferenceID_FK)
VALUES (@Discount, @Remains, @Conference_ID)
END
GO

--CreateWorkshop
IF OBJECT_ID('dbo.CreateWorkshop', 'P') IS NOT NULL
  DROP PROCEDURE dbo.CreateWorkshop
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE CreateWorkshop
@Name varchar(30),
@Descript varchar(255),
@Seats int,
@StartTime datetime,
@EndTime datetime,
@Price numeric(10,2),
@ConfDay_ID int
AS
BEGIN
SET NOCOUNT ON;
IF @Name IS NULL
	THROW 51000, '@Name is null', 1
IF @Seats IS NULL
	THROW 51000, '@Seats is null', 1
IF @StartTime IS NULL
	THROW 51000, '@StartTime is null', 1
IF @EndTime IS NULL
	THROW 51000, '@EndTime is null', 1
IF @Price IS NULL
	THROW 51000, '@Price is null', 1
IF @ConfDay_ID IS NULL
	THROW 51000, '@ConfDay_ID is null', 1
INSERT INTO Workshop
(name, shortDescription, seats, startTime, endTime, price, conferenceDayID_FK)
VALUES (@Name, @Descript, @Seats, @StartTime, @EndTime, @Price, @ConfDay_ID)
END
GO

--CreateWorkshopReg
IF OBJECT_ID('dbo.CreateWorkshopReg', 'P') IS NOT NULL
DROP PROCEDURE dbo.CreateWorkshopReg
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE CreateWorkshopReg
@WorkshopRes_ID int,
@ConferenceReg_ID int
AS
BEGIN
SET NOCOUNT ON;
IF @ConferenceReg_ID IS NULL
	THROW 51000, '@ConferenceReg_ID is null', 1
IF @WorkshopRes_ID IS NULL
	THROW 51000, '@WorkshopRes_ID is null', 1
INSERT INTO WorkshopRegistration
(workshopReservationID_FK, conferenceDayRegistrationID_FK)
VALUES (@WorkshopRes_ID, @ConferenceReg_ID)
END
GO

--CreateWorkshopRes
IF OBJECT_ID('dbo.CreateWorkshopRes', 'P') IS NOT NULL
	DROP PROCEDURE dbo.CreateWorkshopRes
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE CreateWorkshopRes
@ParticipantsNumber int,
@ReservationDate date,
@CancelledDate date,
@Paid numeric(10,2),
@ConfDayRes_ID int,
@Workshop_ID int
AS
BEGIN
SET NOCOUNT ON;
IF @ReservationDate IS NULL
	THROW 51000, '@ReservationDate is null', 1
IF @Paid IS NULL
	THROW 51000, '@Paid is null', 1
IF @ParticipantsNumber IS NULL
	THROW 51000, '@ParticipantsNumbe is null', 1
IF @ConfDayRes_ID IS NULL
	THROW 51000, '@ConfDay_ID is null', 1
IF @Workshop_ID IS NULL
	THROW 51000, '@Client_ID is null', 1
INSERT INTO WorkshopReservation
(reservationDate, cancelledDate, paid, conferenceDayReservationID_FK, workshopID_FK)
VALUES (@ReservationDate, @CancelledDate, @Paid, @ConfDayRes_ID, @Workshop_ID)
END
GO

--cancellConferenceDayReservation
IF OBJECT_ID('dbo.cancellConferenceDayReservation', 'P') IS NOT NULL
	DROP PROCEDURE dbo.cancellConferenceDayReservation
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE cancellConferenceDayReservation
	@Name varchar(50),
	@Surname varchar(50)
AS
BEGIN
	UPDATE ConferenceDayReservation
	SET cancelledDate = GETDATE()
	FROM Participant P
	INNER JOIN ConferenceDayRegistration CDReg
	ON P.participantID = CDReg.participantID_FK
	INNER JOIN ConferenceDayReservation CDRes
	ON CDReg.conferenceDayReservationID_FK = CDRes.conferenceDayReservationID
	WHERE P.firstname = @Name AND P.lastname = @Surname
END
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--cancellWorkshopReservation
IF OBJECT_ID('dbo.cancellWorkshopReservation', 'P') IS NOT NULL
	DROP PROCEDURE dbo.cancellWorkshopReservation
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE cancellWorkshopReservation
	@Name varchar(50),
	@Surname varchar(50)
AS
BEGIN
	UPDATE WorkshopReservation
	SET cancelledDate = GETDATE()
	FROM Participant P
	INNER JOIN ConferenceDayRegistration CDReg
	ON P.participantID = CDReg.participantID_FK
	INNER JOIN ConferenceDayReservation CDRes
	ON CDReg.conferenceDayReservationID_FK = CDRes.conferenceDayReservationID
	INNER JOIN WorkshopReservation WRes
	ON WRes.conferenceDayReservationID_FK = CDres.conferenceDayReservationID
	WHERE P.firstname = @Name AND P.lastname = @Surname
END
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--payForConferenceDay
IF OBJECT_ID('dbo.payForConferenceDay', 'P') IS NOT NULL
	DROP PROCEDURE dbo.payForConferenceDay
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE payForConferenceDay
	@Name varchar(50),
	@Surname varchar(50),
	@Money numeric(10,2)
AS
BEGIN
	UPDATE ConferenceDayReservation
	SET paid = @Money, reservationDate = GETDATE()
	FROM Participant P
	INNER JOIN ConferenceDayRegistration CDReg
	ON P.participantID = CDReg.participantID_FK
	INNER JOIN ConferenceDayReservation CDRes
	ON CDReg.conferenceDayReservationID_FK = CDRes.conferenceDayReservationID
	WHERE P.firstname = @Name AND P.lastname = @Surname
END
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--payForWorkshop
IF OBJECT_ID('dbo.PayForWorkshop', 'P') IS NOT NULL
	DROP PROCEDURE dbo.payForWorkshop
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE payForWorkshop
	@Name varchar(50),
	@Surname varchar(50),
	@Money numeric(10,2)
AS
BEGIN
	UPDATE WorkshopReservation
	SET paid = @Money, reservationDate = GETDATE()
	FROM Participant P
	INNER JOIN ConferenceDayRegistration CDReg
	ON P.participantID = CDReg.participantID_FK
	INNER JOIN ConferenceDayReservation CDRes
	ON CDReg.conferenceDayReservationID_FK = CDRes.conferenceDayReservationID
	INNER JOIN WorkshopReservation WRes
	ON WRes.conferenceDayReservationID_FK = CDres.conferenceDayReservationID
	WHERE P.firstname = @Name AND P.lastname = @Surname
END
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--updatePriceForStudents
IF OBJECT_ID('dbo.UpdatePriceForStudents', 'P') IS NOT NULL
	DROP PROCEDURE dbo.updatePriceForStudents
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE updatePriceForStudents
	@Money numeric(10,2)
AS
BEGIN
	UPDATE ConferenceDayReservation
	SET paid = paid - @Money
	FROM Participant P
	INNER JOIN ConferenceDayRegistration CDReg
	ON P.participantID = CDReg.participantID_FK
	INNER JOIN ConferenceDayReservation CDRes
	ON CDReg.conferenceDayReservationID_FK = CDRes.conferenceDayReservationID
	WHERE P.studentNumCard IS NOT NULL
	UPDATE CP
	SET discountForStudents = @Money
	FROM Participant P
	INNER JOIN ConferenceDayRegistration CDReg
	ON P.participantID = CDReg.participantID_FK
	INNER JOIN ConferenceDayReservation CDRes
	ON CDReg.conferenceDayReservationID_FK = CDRes.conferenceDayReservationID
	INNER JOIN ConferenceDay CD
	ON CD.conferenceDayID = CDRes.conferenceDayID_FK
	INNER JOIN Conference C
	ON C.conferenceID = cd.conferenceID_FK
	INNER JOIN ConferencePrice CP
	ON CP.conferenceID_FK = C.conferenceID
	WHERE P.studentNumCard IS NOT NULL
END
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--updatePriceForStudentsWshops
IF OBJECT_ID('dbo.UpdatePriceForStudentsWshops', 'P') IS NOT NULL
	DROP PROCEDURE dbo.updatePriceForStudentsWshops
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE updatePriceForStudentsWshops
	@Money numeric(10,2)
AS
BEGIN
	UPDATE WorkshopReservation
	SET WorkshopReservation.paid = WorkshopReservation .paid - @Money
	FROM Participant P
	INNER JOIN ConferenceDayRegistration CDReg
	ON P.participantID = CDReg.participantID_FK
	INNER JOIN ConferenceDayReservation CDRes
	ON CDReg.conferenceDayReservationID_FK = CDRes.conferenceDayReservationID
	WHERE P.studentNumCard IS NOT NULL
END
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--validateRegistrNumber
IF OBJECT_ID('dbo.validateRegistrNumber', 'P') IS NOT NULL
  DROP PROCEDURE dbo.validateRegistrNumber
SET ANSI_NULLS ON
GO 
SET QUOTED_IDENTIFIER ON 
GO  
CREATE PROCEDURE [dbo].[validateRegistrNumber] 
@conf_day_reservation_id INT 
AS 
BEGIN 
SET NOCOUNT ON; 
DECLARE 
@reservations INT,
@registrations INT,
@msg NVARCHAR(2048)
SELECT @reservations = participantsNumber
FROM ConferenceDayReservation 

SELECT @registrations= COUNT(CDR.participantid_fk)
FROM ConferenceDayRegistration CDR
JOIN Participant P ON CDR.participantid_fk = P.participantid 

IF 
@registrations > @reservations 
BEGIN
 SET 
 @msg = FORMATMESSAGE('There more number of registrations than reservations, @conf_day_reservation_id = %d', @conf_day_reservation_id); 
 THROW 51000, @msg, 1 END 
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--validateWorkshopRegistrNumber
IF OBJECT_ID('dbo.validateWorkshopRegistrNumber', 'P') IS NOT NULL
	DROP PROCEDURE validateWorkshopRegistrNumber
SET ANSI_NULLS ON 
GO 
SET QUOTED_IDENTIFIER ON 
GO 
CREATE PROCEDURE [dbo].[validateWorkshopRegistrNumber] @workshop_reservation_id 
INT 
AS 
BEGIN 
SET NOCOUNT ON; 
DECLARE 
@reservations INT, 
@registrations INT, 
@msg NVARCHAR(2048)
SELECT @reservations = participantsNumber
FROM WorkshopReservation 
WHERE workshopreservationid = @workshop_reservation_id 
SELECT @registrations = COUNT(WR.conferencedayregistrationid_fk)
FROM WorkshopRegistration WR 
join conferencedayregistration cdreg
on WR.conferencedayregistrationid_fk = cdreg.conferencedayregistrationid
JOIN Participant P
ON cdreg.participantid_fk = P.participantid 
WHERE WR.workshopreservationid_fk = @workshop_reservation_id
IF @registrations > @reservations 
BEGIN SET @msg = FORMATMESSAGE('There are more registrations than reservations, @workshop_reservation_id=%d', 
@workshop_reservation_id); THROW 51000, @msg, 1 END 
END 
GO