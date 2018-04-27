use aszaflar_a
--getParticipantID
IF OBJECT_ID (N'getParticipantID', N'FN') IS NOT NULL
    DROP FUNCTION getParticipantID

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[getParticipantID]
(
	@name varchar(50),
	@surname varchar(50)
)
RETURNS int
as
BEGIN
	RETURN (select participantID from Participant where firstname = @name and lastname = @surname)
END
GO

--getParticipantConferences
IF OBJECT_ID (N'getParticipantConferences', N'FN') IS NOT NULL
    DROP FUNCTION getParticipantConferences

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION dbo.getParticipantConferences
(
	@name varchar(50),
	@surname varchar(50)
)
RETURNS int
AS
BEGIN
	RETURN (select conferenceName
			from Participant P
			INNER JOIN ConferenceDayRegistration CDReg
			ON P.participantID = CDReg.participantID_FK
			INNER JOIN ConferenceDay CD
			ON CDReg.conferenceDayReservationID_FK = CD.conferenceDayID
			INNER JOIN Conference C
			ON C.conferenceID = CD.conferenceID_FK
			WHERE firstname = @name  AND lastname = @surname )
END
GO

--getParticipantWorkshops
IF OBJECT_ID (N'getParticipantWorkshops', N'FN') IS NOT NULL
    DROP FUNCTION getParticipantWorkshops
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION dbo.getParticipantWorkshops
(
	@name varchar(50),
	@surname varchar(50)
)
RETURNS int
AS
BEGIN
	RETURN (select W.name
			from Participant P
			INNER JOIN ConferenceDayRegistration CDReg
			ON P.participantID = CDReg.participantID_FK
			INNER JOIN WorkshopRegistration Wreg
			ON CDreg.conferenceDayRegistrationID = Wreg.conferenceDayRegistrationID_FK
			INNER JOIN  WorkshopReservation Wres
			ON Wreg.workshopReservationID_FK = Wres.workshopReservationID
			INNER JOIN Workshop W
			ON W.workshopID = Wres.workshopID_FK)
END
GO

--getComapnyID
IF OBJECT_ID (N'getComapnyID', N'FN') IS NOT NULL
	DROP FUNCTION [dbo].[getComapnyID]
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[getComapnyID]
(
	@name varchar(50)
)
RETURNS int
as
BEGIN
	RETURN (select companyID from Company where Name = @name)
END
GO

--ConferenceDayCost
IF OBJECT_ID (N'ConferenceDayCost', N'FN') IS NOT NULL
	DROP FUNCTION [dbo].[ConferenceDayCost]
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[ConferenceDayCost](
 @reservations INT,
 @studentReservations INT,
 @basePrice NUMERIC(16, 2),
 @priceModifier NUMERIC(3, 2),
 @studentDiscount NUMERIC(3, 2)
 )
  RETURNS NUMERIC(16, 2)
  WITH RETURNS NULL ON NULL INPUT, SCHEMABINDING
  AS BEGIN
  DECLARE @price NUMERIC(20, 6) = (@reservations - @studentReservations) * @basePrice * @priceModifier +
								   @studentReservations * @basePrice * @priceModifier * @studentDiscount
	DECLARE @result NUMERIC(16, 2) = CONVERT(NUMERIC(16, 2), ROUND(@price, 2))
	RETURN @result
END
GO
