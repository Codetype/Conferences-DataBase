use aszaflar_a

--Coming_Conferences_v
IF OBJECT_ID ('Coming_Conferences_v', 'V') IS NOT NULL
	DROP VIEW Coming_Conferences_v

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW Coming_Conferences_v
AS
SELECT conferenceID, addressName, city, country
FROM ConferenceDay CD
INNER JOIN Conference C
ON CD.conferenceID_FK = c.conferenceID
INNER JOIN Address A
ON C.addressID_FK = A.addressID
WHERE startTime >= GETDATE()
GO

--Coming_Conferences_v
IF OBJECT_ID ('Finished_Conferences_v', 'V') IS NOT NULL
	DROP VIEW Finished_Conferences_v

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW Finished_Conferences_v
AS
SELECT conferenceID, addressName, city, country
FROM ConferenceDay CD
INNER JOIN Conference C
ON CD.conferenceID_FK = c.conferenceID
INNER JOIN Address A
ON C.addressID_FK = A.addressID
WHERE startTime < GETDATE()
GROUP BY conferenceID, addressName, city, country
GO

--members_of_coming_conferences_v
IF OBJECT_ID ('members_of_coming_conferences_v', 'V') IS NOT NULL
	DROP VIEW members_of_coming_conferences_v

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW members_of_coming_conferences_v
AS
SELECT c.conferenceID, P.participantID, P.firstname, P.lastname FROM Conference C
INNER JOIN ConferenceDay CD
ON C.conferenceID = CD.conferenceID_FK
INNER JOIN ConferenceDayReservation CDRs
ON CD.conferenceDayID = CDRs.conferenceDayID_FK
INNER JOIN ConferenceDayRegistration CDRg
ON CDRs.conferenceDayReservationID = CDRg.conferenceDayReservationID_FK
INNER JOIN Participant P
ON CDRg.participantID_FK = P.participantID
WHERE CD.startTime >= GETDATE()
GROUP BY c.conferenceID, P.participantID, P.firstname, P.lastname 
GO

--members_of_finished_conferences_v
IF OBJECT_ID ('members_of_finished_conferences_v', 'V') IS NOT NULL
	DROP VIEW members_of_finished_conferences_v

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW members_of_finished_conferences_v
AS
SELECT c.conferenceID, P.participantID, P.firstname, P.lastname FROM Conference C
INNER JOIN ConferenceDay CD
ON C.conferenceID = CD.conferenceID_FK
INNER JOIN ConferenceDayReservation CDRs
ON CD.conferenceDayID = CDRs.conferenceDayID_FK
INNER JOIN ConferenceDayRegistration CDRg
ON CDRs.conferenceDayReservationID = CDRg.conferenceDayReservationID_FK
INNER JOIN Participant P
ON CDRg.participantID_FK = P.participantID
WHERE CD.startTime < GETDATE()
GROUP BY c.conferenceID, P.participantID, P.firstname, P.lastname 
GO

-- ConferenceMemberNumber_v
IF OBJECT_ID ('Conference_MemberNumber_v', 'V') IS NOT NULL
	DROP VIEW Conference_MemberNumber_v

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW Conference_MemberNumber_v
AS
SELECT c.conferenceID, COUNT(P.participantID) as NumbersOfMembers
FROM Conference C
INNER JOIN ConferenceDay CD
ON C.conferenceID = CD.conferenceID_FK
INNER JOIN ConferenceDayReservation CDRs
ON CD.conferenceDayID = CDRs.conferenceDayID_FK
INNER JOIN ConferenceDayRegistration CDRg
ON CDRs.conferenceDayReservationID = CDRg.conferenceDayReservationID_FK
INNER JOIN Participant P
ON CDRg.participantID_FK = P.participantID
GROUP BY C.conferenceID
GO

-- ConfDaySeatsReservationsRegistrations
IF OBJECT_ID ('V_ConfDaySeatsReservationsRegistrations', 'V') IS NOT NULL
	DROP VIEW [dbo].[V_ConfDaySeatsReservationsRegistrations]

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[V_ConfDaySeatsReservationsRegistrations]
AS
SELECT ConDayRes.conferenceDayID_FK,
		ResCounts.TotalSeats,
		ResCounts.ReservedSeats,
		ResCounts.TotalSeats - ResCounts.ReservedSeats AS FreeSeats,
		ConDayRes.clientID_FK AS Client,
		ConDayRes.conferenceDayReservationID,
		ConDayRes.participantsNumber,
		ISNULL(RegCounts.Registrated, 0) AS Registrated,
		ISNULL(RegCounts.Students, 0) AS Students,
		ISNULL(RegCounts.Registrated - RegCounts.Students, 0) AS Others
FROM ConferenceDayReservation ConDayRes
JOIN (
	SELECT ConDay.conferenceDayID,
			ConDay.seats AS TotalSeats,
			ISNULL(SUM(ConDayRes.participantsNumber), 0) AS ReservedSeats
	FROM dbo.ConferenceDay ConDay
	JOIN dbo.ConferenceDayReservation ConDayRes
	ON ConDay.conferenceDayID = ConDayRes.conferenceDayID_FK
	GROUP BY ConDay.conferenceDayID, ConDay.seats
) ResCounts
ON ConDayRes.conferenceDayID_FK = ResCounts.conferenceDayID
LEFT JOIN (
	SELECT ConDayReg.conferenceDayReservationID_FK,
			COUNT(ConDayReg.participantID_FK) AS Registrated,
			COUNT(Par.studentNumCard) AS Students
	FROM dbo.ConferenceDayRegistration ConDayReg
	JOIN dbo.Participant Par
	ON ConDayReg.participantID_FK = Par.participantID
	GROUP BY ConDayReg.conferenceDayReservationID_FK
) RegCounts
ON ConDayRes.conferenceDayReservationID = RegCounts.conferenceDayReservationID_FK
GO

--V_ConferenceDates
IF OBJECT_ID ('V_ConferenceDates', 'V') IS NOT NULL
	DROP VIEW [dbo].[V_ConferenceDates]

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[V_ConferenceDates]
AS
SELECT	Con.conferenceID,
		COUNT_BIG(ConDay.ConferenceDayID) AS NumberOfDays,
		MIN(ConDay.startTime) AS StartTime,
		MAX(ConDay.endTime) AS EndTime
FROM dbo.Conference Con
JOIN dbo.ConferenceDay ConDay
ON Con.conferenceID = ConDay.conferenceID_FK
GROUP BY Con.conferenceID
GO

-- ConferencePopularity
IF OBJECT_ID ('V_ConferencePopularity', 'V') IS NOT NULL
	DROP VIEW [dbo].[V_ConferencePopularity]

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[V_ConferencePopularity]
AS
SELECT	Con.conferenceID,
		Con.conferenceName,
		SUM(ConDayRes.participantsNumber) AS TotalReservations,
		ISNULL(SUM(TotalReg.Coun), 0) AS TotalRegistrations
FROM Conference Con
LEFT JOIN ConferenceDay ConDay
ON Con.conferenceID = ConDay.conferenceID_FK
LEFT JOIN  ConferenceDayReservation ConDayRes
ON ConDay.conferenceDayID = ConDayRes.conferenceDayID_FK
LEFT JOIN (
	SELECT ConferenceDayReservationID_FK as ConferenceDayReservationID,
			COUNT(*) as Coun
	FROM ConferenceDayRegistration
	GROUP BY conferenceDayReservationID_FK
) TotalReg
ON ConDayRes.conferenceDayReservationID = TotalReg.ConferenceDayReservationID
GROUP BY Con.conferenceID, Con.conferenceName
GO

-- WorkshopPopularity
IF OBJECT_ID ('V_WorkshopPopularity', 'V') IS NOT NULL
	DROP VIEW [dbo].[V_WorkshopPopularity]

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[V_WorkshopPopularity]
AS
SELECT	Wor.workshopID,
		Wor.name,
		SUM(WorRes.participantsNumber) AS TotalReservations,
		ISNULL(SUM(TotalReg.Coun), 0) AS TotalRegistrations
FROM Workshop Wor
LEFT OUTER JOIN WorkshopReservation WorRes
ON Wor.workshopID = WorRes.workshopID_FK
LEFT OUTER JOIN (
	SELECT workshopReservationID_FK AS workshopReservationID,
			COUNT(*) AS Coun
	FROM WorkshopRegistration
	GROUP BY workshopReservationID_FK
) AS TotalReg
ON WorRes.workshopReservationID = TotalReg.workshopReservationID
GROUP BY Wor.workshopID, Wor.name
GO

-- ComingWorkshop+
IF OBJECT_ID ('V_ComingWorkshop', 'V') IS NOT NULL
	DROP VIEW [dbo].[V_ComingWorkshop]
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[V_ComingWorkshop]
AS
SELECT	Wor.workshopID,
		Wor.name,
		Wor.shortDescription,
		Wor.seats,
		Wor.startTime,
		Wor.endTime,
		Ad.addressName,
		Ad.street,
		Ad.number,
		Ad.zipCode,
		Ad.city,
		Ad.country
FROM Workshop Wor
INNER JOIN ConferenceDay ConDay
ON Wor.conferenceDayID_FK = ConDay.conferenceDayID
INNER JOIN Conference Con
ON ConDay.conferenceID_FK = Con.conferenceID
INNER JOIN Address Ad
ON Con.addressID_FK = Ad.addressID
WHERE Wor.startTime >= GETDATE()
GO
