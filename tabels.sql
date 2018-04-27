use aszaflar_a
--dropy
IF OBJECT_ID('dbo.WorkshopRegistration', 'U') IS NOT NULL
    DROP TABLE dbo.WorkshopRegistration
IF OBJECT_ID('dbo.WorkshopReservation', 'U') IS NOT NULL
    DROP TABLE dbo.WorkshopReservation
IF OBJECT_ID('dbo.Workshop', 'U') IS NOT NULL
    DROP TABLE dbo.Workshop
IF OBJECT_ID('dbo.ConferenceDayRegistration', 'U') IS NOT NULL
    DROP TABLE dbo.ConferenceDayRegistration
IF OBJECT_ID('dbo.ConferenceDayReservation', 'U') IS NOT NULL
    DROP TABLE dbo.ConferenceDayReservation
IF OBJECT_ID('dbo.Client', 'U') IS NOT NULL
    DROP TABLE dbo.Client
IF OBJECT_ID('dbo.Participant', 'U') IS NOT NULL
    DROP TABLE dbo.Participant
IF OBJECT_ID('dbo.Company', 'U') IS NOT NULL
    DROP TABLE dbo.Company
IF OBJECT_ID('dbo.ConferenceDay', 'U') IS NOT NULL
    DROP TABLE dbo.ConferenceDay
IF OBJECT_ID('dbo.ConferencePrice', 'U') IS NOT NULL
    DROP TABLE dbo.ConferencePrice
IF OBJECT_ID('dbo.Conference', 'U') IS NOT NULL
    DROP TABLE dbo.Conference
IF OBJECT_ID('dbo.Address', 'U') IS NOT NULL
    DROP TABLE dbo.Address
--tabele
--Address
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create table Address(
    addressID int not null identity(1,1),
	addressName varchar(30) null,
	zipCode varchar(6) not null,
	city varchar(50) not null,
	street varchar(50) not null,
	number int not null,
	country varchar(30) not null,
PRIMARY KEY CLUSTERED (
addressID ASC
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF,
ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
)
ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [Unique_Index_Address_street_number_city_zipcode]
ON [dbo].[Address]
(
	street ASC,
	number ASC,
	city ASC,
	zipcode ASC
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF,
DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
ON[PRIMARY]
GO
ALTER TABLE [dbo].[Address] ADD DEFAULT ('') FOR [addressName]
GO
ALTER TABLE [dbo].[Address] WITH NOCHECK ADD CONSTRAINT [Check_Address_zipCode]
CHECK (( [Address].[zipCode] like '[0-9][0-9]-[0-9][0-9][0-9]' ))
GO
ALTER TABLE [dbo].[Address] CHECK CONSTRAINT [Check_Address_zipCode]
GO
ALTER TABLE [dbo].[Address] WITH NOCHECK ADD CONSTRAINT [Check_Address_city]
CHECK (( ltrim([city]) <> '' ))
GO
ALTER TABLE [dbo].[Address] CHECK CONSTRAINT [Check_Address_city]
GO
ALTER TABLE [dbo].[Address] WITH NOCHECK ADD CONSTRAINT [Check_Address_street]
CHECK (( ltrim([street]) <> '' ))
GO
ALTER TABLE [dbo].[Address] CHECK CONSTRAINT [Check_Address_street]
GO
ALTER TABLE [dbo].[Address] WITH NOCHECK ADD CONSTRAINT [Check_Address_country]
CHECK (( ltrim([country]) <> '' ))
GO
ALTER TABLE [dbo].[Address] CHECK CONSTRAINT [Check_Address_country]
GO
--Company
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create table Company(
    companyID int not null identity(1,1),
	name varchar(100) not null,
	nip varchar(13) not null,
	regon varchar(14) null,
	email varchar(255) not null,
	phone varchar(13) not null,
	fax varchar(20) null,
	addressID_FK int not null
PRIMARY KEY CLUSTERED (
companyID ASC
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF,
ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
)
ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [Unique_Index_Company_nip]
ON [dbo].[Company]
(
	nip ASC
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF,
DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
ON[PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [Unique_Index_Company_regon]
ON [dbo].[Company]
(
	regon ASC
) WHERE (regon IS NOT NULL)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF,
DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
ON[PRIMARY]
GO
ALTER TABLE [dbo].[Company] WITH NOCHECK ADD CONSTRAINT [Check_Company_addressID_FK]
FOREIGN KEY([addressID_FK])
REFERENCES [dbo].[Address] ([addressID])
GO
ALTER TABLE [dbo].[Company] CHECK CONSTRAINT [Check_Company_addressID_FK]
GO

ALTER TABLE [dbo].[Company] WITH NOCHECK ADD CONSTRAINT [Check_Company_name]
CHECK (( ltrim([name]) <> '' ))
GO
ALTER TABLE [dbo].[Company] CHECK CONSTRAINT [Check_Company_name]
GO
-- nip jest 10 cyfrowy, czesty format XXX-XXX-XX-XX
ALTER TABLE [dbo].[Company] WITH NOCHECK ADD CONSTRAINT [Check_nip]
CHECK (( [nip] like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' or
	[nip] like '[0-9][0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]' ))
GO
ALTER TABLE [dbo].[Company] CHECK CONSTRAINT [Check_nip]
GO
-- REGON jest 9 lub 14 cyfrowy
ALTER TABLE [dbo].[Company] WITH NOCHECK ADD CONSTRAINT [Check_regon]
CHECK (( [regon] like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' or
	[regon] like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' ))
GO
ALTER TABLE [dbo].[Company] CHECK CONSTRAINT [Check_regon]
GO
ALTER TABLE [dbo].[Company] WITH NOCHECK ADD CONSTRAINT [Check_email]
CHECK (( [email] like '%_@_%.__%' ))
GO
ALTER TABLE [dbo].[Company] CHECK CONSTRAINT [Check_regon]
GO
-- dozwalamy formaty typu [2cyfry][2cyfry][9cyfr]
ALTER TABLE [dbo].[Company] WITH NOCHECK ADD CONSTRAINT [Check_phone]
CHECK (( [phone] like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' or
		[phone] like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' or
		[phone] like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'))
GO
ALTER TABLE [dbo].[Company] CHECK CONSTRAINT [Check_phone]
GO
--Participant
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create table Participant(
    participantID int not null identity(1,1),
	firstname varchar(30) not null,
	lastname varchar(30) not null,
	email varchar(100) not null,
	phone varchar(13) not null,
	studentNumCard int null,
	addressID_FK int not null
PRIMARY KEY CLUSTERED (
participantID ASC
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF,
ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
)
ON [PRIMARY]
CREATE UNIQUE NONCLUSTERED INDEX [Unique_Index_Participant_email]
ON [dbo].[Participant]
(
	email ASC
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF,
DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
ON[PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [Unique_Index_Participant_studentNumCard]
ON [dbo].[Participant]
(
	studentNumCard ASC
) WHERE (studentNumCard IS NOT NULL)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF,
DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
ON[PRIMARY]
GO
ALTER TABLE [dbo].[Participant] WITH NOCHECK ADD CONSTRAINT [Check_Participant_addressID_FK]
FOREIGN KEY([addressID_FK]) REFERENCES [dbo].[Address]([addressID])
GO
ALTER TABLE [dbo].[Participant] CHECK CONSTRAINT [Check_Participant_addressID_FK]
GO
ALTER TABLE [dbo].[Participant] WITH NOCHECK ADD CONSTRAINT [Check_Participant_firstname]
CHECK (( ltrim([firstname]) <> '' ))
GO
ALTER TABLE [dbo].[Participant] CHECK CONSTRAINT [Check_Participant_firstname]
GO
ALTER TABLE [dbo].[Participant] WITH NOCHECK ADD CONSTRAINT [Check_Participant_lastname]
CHECK (( ltrim([lastname]) <> '' ))
GO
ALTER TABLE [dbo].[Participant] CHECK CONSTRAINT [Check_Participant_lastname]
GO
ALTER TABLE [dbo].[Participant] WITH NOCHECK ADD CONSTRAINT [Check_Participant_email]
CHECK (( [email] like '%_@_%.__%' ))
GO
ALTER TABLE [dbo].[Participant] CHECK CONSTRAINT [Check_Participant_email]
GO
ALTER TABLE [dbo].[Participant] WITH NOCHECK ADD CONSTRAINT [Check_Participant_phone]
CHECK (( [phone] like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' or
		[phone] like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]' or
		[phone] like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'))
GO
ALTER TABLE [dbo].[Participant] CHECK CONSTRAINT [Check_Participant_phone]
GO
ALTER TABLE [dbo].[Participant] WITH NOCHECK ADD CONSTRAINT [Check_Participant_studentNumCard]
CHECK (( [studentNumCard] IS NULL OR ltrim([studentNumCard])<>'' ))
GO
ALTER TABLE [dbo].[Participant] CHECK CONSTRAINT [Check_Participant_studentNumCard]
GO
--Client
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create table Client(
    clientID int not null identity(1,1),
	companyID_FK int null,
	participantID_FK int null
PRIMARY KEY CLUSTERED (
ClientID ASC
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF,
ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
)
ON [PRIMARY]
-- brak indexu poprzez companyID_FK lub participantID_FK, bo jedna firma/uczestnik może być klientem kilku różnych konferencji
ALTER TABLE [dbo].[Client] WITH NOCHECK ADD CONSTRAINT [Check_Client_companyID_FK]
FOREIGN KEY([companyID_FK]) REFERENCES [dbo].[Company]([companyID])
GO
ALTER TABLE [dbo].[Client] CHECK CONSTRAINT [Check_Client_companyID_FK]
GO
ALTER TABLE [dbo].[Client] WITH NOCHECK ADD CONSTRAINT [Check_Client_participantID_FK]
FOREIGN KEY([participantID_FK]) REFERENCES [dbo].[Participant]([participantID])
GO
ALTER TABLE [dbo].[Client] CHECK CONSTRAINT [Check_Client_participantID_FK]
GO
ALTER TABLE [dbo].[Client] WITH NOCHECK ADD CONSTRAINT [Check_Client_OneFK]
CHECK (( ([companyID_FK] is not null AND [participantID_FK] is null) or
			([companyID_FK] is null AND [participantID_FK] is not null) ))
GO
ALTER TABLE [dbo].[Client] CHECK CONSTRAINT [Check_Client_OneFK]
GO
--Conference
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create table Conference(
    conferenceID int not null identity(1,1),
	conferenceName varchar(100) null,
	addressID_FK int not null
PRIMARY KEY CLUSTERED (
conferenceID ASC
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF,
ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
)
ON [PRIMARY]
ALTER TABLE [dbo].[Conference] WITH NOCHECK ADD CONSTRAINT [Check_Conference_addressID_FK]
FOREIGN KEY([addressID_FK]) REFERENCES [dbo].[Address] ([addressID])
GO
ALTER TABLE [dbo].[Conference] CHECK CONSTRAINT [Check_Conference_addressID_FK]
GO
--ConferencePrice
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create table ConferencePrice(
    conferencePriceID int not null identity(1,1),
	discountForStudents numeric(10, 2) null,
	daysRemain smallint null,
	conferenceID_FK int not null
PRIMARY KEY CLUSTERED (
conferencePriceID ASC
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF,
ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
)
ON [PRIMARY]
ALTER TABLE [dbo].[ConferencePrice] WITH NOCHECK ADD CONSTRAINT [Check_ConferencePrice_conferenceID_FK]
FOREIGN KEY([conferenceID_FK]) REFERENCES [dbo].[Conference] ([conferenceID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ConferencePrice] CHECK CONSTRAINT [Check_ConferencePrice_conferenceID_FK]
GO
--ConferenceDay
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create table ConferenceDay(
	conferenceDayID int not null identity(1,1),
	seats int not null,
	startTime datetime not null,
	endTime datetime not null,
	basePrice numeric(10, 2) not null,
	conferenceID_FK int not null
PRIMARY KEY CLUSTERED (
conferenceDayID ASC
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF,
ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
)
ON [PRIMARY]
ALTER TABLE [dbo].[ConferenceDay] WITH NOCHECK ADD CONSTRAINT [Check_ConferenceDay_conferenceID_FK]
FOREIGN KEY([conferenceID_FK]) REFERENCES [dbo].[Conference] ([conferenceID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ConferenceDay] CHECK CONSTRAINT [Check_ConferenceDay_conferenceID_FK]
GO
ALTER TABLE [dbo].[ConferenceDay] WITH NOCHECK ADD CONSTRAINT [Check_ConferenceDay_seats]
CHECK (( [seats] between 1 and 100000 ))
GO
ALTER TABLE [dbo].[ConferenceDay] CHECK CONSTRAINT [Check_ConferenceDay_seats]
GO
ALTER TABLE [dbo].[ConferenceDay] WITH NOCHECK ADD CONSTRAINT [Check_ConferenceDay_Date]
CHECK (( (datediff(day, [startTime], [endTime]) <= 30) and
		([startTime] < [endTime]) ))
GO
ALTER TABLE [dbo].[ConferenceDay] CHECK CONSTRAINT [Check_ConferenceDay_Date]
GO
ALTER TABLE [dbo].[ConferenceDay] WITH NOCHECK ADD CONSTRAINT [Check_ConferenceDay_basePrice]
CHECK (( [basePrice] >= 0 ))
GO
ALTER TABLE [dbo].[ConferenceDay] CHECK CONSTRAINT [Check_ConferenceDay_basePrice]
GO
--ConferenceDayReservation
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create table ConferenceDayReservation(
	conferenceDayReservationID int not null identity(1,1),
	reservationDate date not null,
	cancelledDate date null,
	participantsNumber int not null,
	paid numeric(10, 2) not null,
	conferenceDayID_FK int not null,
	clientID_FK int not null
PRIMARY KEY CLUSTERED (
conferenceDayReservationID ASC
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF,
ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
)
ON [PRIMARY]
ALTER TABLE [dbo].[ConferenceDayReservation]
WITH NOCHECK ADD CONSTRAINT [Check_ConferenceDayReservation_conferenceDayID_FK]
FOREIGN KEY([conferenceDayID_FK]) REFERENCES [dbo].[ConferenceDay] ([conferenceDayID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ConferenceDayReservation] CHECK CONSTRAINT [Check_ConferenceDayReservation_conferenceDayID_FK]
GO
ALTER TABLE [dbo].[ConferenceDayReservation]
WITH NOCHECK ADD CONSTRAINT [Check_ConferenceDayReservation_clientID_FK]
FOREIGN KEY([clientID_FK]) REFERENCES [dbo].[Client] ([clientID])
GO
ALTER TABLE [dbo].[ConferenceDayReservation] CHECK CONSTRAINT [Check_ConferenceDayReservation_clientID_FK]
GO
ALTER TABLE [dbo].[ConferenceDayReservation] ADD DEFAULT ((0)) for [paid]
GO
ALTER TABLE [dbo].[ConferenceDayReservation] WITH NOCHECK ADD CONSTRAINT [Check_ConferenceDayReservation_paid]
CHECK (( [paid] >= 0 ))
GO
ALTER TABLE [dbo].[ConferenceDayReservation] CHECK CONSTRAINT [Check_ConferenceDayReservation_paid]
GO
--ConferenceDayRegistration
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create table ConferenceDayRegistration(
	conferenceDayRegistrationID int not null identity(1,1),
	conferenceDayReservationID_FK int not null,
	participantID_FK int not null
PRIMARY KEY CLUSTERED (
conferenceDayRegistrationID ASC
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF,
ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
)
ON [PRIMARY]
CREATE UNIQUE NONCLUSTERED INDEX
[Unique_Index_ConferenceDayRegistration_conferenceDayReservationID_FK_participantID_FK]
ON [dbo].[ConferenceDayRegistration]
(
	conferenceDayReservationID_FK ASC,
	participantID_FK ASC
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF,
DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
ON[PRIMARY]
GO
ALTER TABLE [dbo].[ConferenceDayRegistration]
WITH NOCHECK ADD CONSTRAINT [Check_ConferenceDayRegistration_ParticipantID_FK]
FOREIGN KEY([participantID_FK])
REFERENCES [dbo].[Participant] ([participantID])
GO
ALTER TABLE [dbo].[ConferenceDayRegistration]
CHECK CONSTRAINT [Check_ConferenceDayRegistration_ParticipantID_FK]
GO
ALTER TABLE [dbo].[ConferenceDayRegistration]
WITH NOCHECK ADD CONSTRAINT [Check_ConferenceDayRegistration_ConferenceDayReservationID_FK]
FOREIGN KEY([conferenceDayReservationID_FK]) REFERENCES [dbo].[ConferenceDayReservation] ([ConferenceDayReservationID])
GO
ALTER TABLE [dbo].[ConferenceDayRegistration]
CHECK CONSTRAINT [Check_ConferenceDayRegistration_ConferenceDayReservationID_FK]
GO
--Workshop
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create table Workshop(
	workshopID int not null identity(1,1),
	name varchar(30) not null,
	shortDescription varchar(255) null,
	seats int not null,
	startTime datetime not null,
	endTime datetime not null,
	price numeric(10, 2) not null,
	conferenceDayID_FK int not null
PRIMARY KEY CLUSTERED (
workshopID ASC
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF,
ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
)
ON [PRIMARY]
CREATE UNIQUE NONCLUSTERED INDEX [Unique_Index_Workshop_name_conferenceDayID_FK]
ON [dbo].[Workshop]
(
	name ASC,
	conferenceDayID_FK ASC
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF,
DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
ON[PRIMARY]
GO
ALTER TABLE [dbo].[Workshop] WITH NOCHECK ADD CONSTRAINT [Check_Workshop_conferenceDayID_FK]
FOREIGN KEY([conferenceDayID_FK]) REFERENCES [dbo].[ConferenceDay] ([ConferenceDayID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Workshop] CHECK CONSTRAINT [Check_Workshop_conferenceDayID_FK]
GO
ALTER TABLE [dbo].[Workshop] WITH NOCHECK ADD CONSTRAINT [Check_Workshop_name]
CHECK (( ltrim([name])<>'' ))
GO
ALTER TABLE [dbo].[Workshop] CHECK CONSTRAINT [Check_Workshop_name]
GO
ALTER TABLE [dbo].[Workshop] WITH NOCHECK ADD CONSTRAINT [Check_Workshop_seats]
CHECK (( [seats] between 1 and 1000 ))
GO
ALTER TABLE [dbo].[Workshop] CHECK CONSTRAINT [Check_Workshop_seats]
GO
ALTER TABLE [dbo].[Workshop] WITH NOCHECK ADD CONSTRAINT [Check_Workshop_Date]
CHECK (( (datediff(day, [startTime], [endTime]) = 0) and
		([startTime] < [endTime]) ))
GO
ALTER TABLE [dbo].[Workshop] CHECK CONSTRAINT [Check_Workshop_Date]
GO
ALTER TABLE [dbo].[Workshop] WITH NOCHECK ADD CONSTRAINT [Check_Workshop_price]
CHECK (( [price] > 0 ))
GO
ALTER TABLE [dbo].[Workshop] CHECK CONSTRAINT [Check_Workshop_price]
GO
--WorkshopReservation
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create table WorkshopReservation(
	workshopReservationID int not null identity(1,1),
	participantsNumber int not null,
	reservationDate date not null,
	cancelledDate date null,
	paid numeric(10, 2) not null,
	conferenceDayReservationID_FK int not null,
	workshopID_FK int not null
PRIMARY KEY CLUSTERED (
workshopReservationID ASC
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF,
ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
)
ON [PRIMARY]
CREATE UNIQUE NONCLUSTERED INDEX
[Unique_Index_WorkshopReservation_conferenceDayReservationID_FK_workshopID_FK]
ON [dbo].[WorkshopReservation]
(
	conferenceDayReservationID_FK ASC,
	workshopID_FK ASC
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF,
DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
ON[PRIMARY]
GO
ALTER TABLE [dbo].[WorkshopReservation]
WITH NOCHECK ADD CONSTRAINT [Check_WorkshopReservation_conferenceDayReservationID_FK]
FOREIGN KEY([conferenceDayReservationID_FK])
REFERENCES [dbo].[ConferenceDayReservation] ([conferenceDayReservationID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[WorkshopReservation]
CHECK CONSTRAINT [Check_WorkshopReservation_conferenceDayReservationID_FK]
GO
ALTER TABLE [dbo].[WorkshopReservation] WITH NOCHECK ADD CONSTRAINT [Check_WorkshopReservation_workshopID_FK]
FOREIGN KEY([workshopID_FK]) REFERENCES [dbo].[Workshop] ([workshopID])
GO
ALTER TABLE [dbo].[WorkshopReservation] CHECK CONSTRAINT [Check_WorkshopReservation_workshopID_FK]
GO
ALTER TABLE [dbo].[WorkshopReservation] ADD DEFAULT (( 1 )) FOR [participantsNumber]
GO
ALTER TABLE [dbo].[WorkshopReservation] WITH NOCHECK ADD CONSTRAINT [Check_WorkshopReservation_participantsNumber]
CHECK (( [participantsNumber] >= 1 ))
GO
ALTER TABLE [dbo].[WorkshopReservation] CHECK CONSTRAINT [Check_WorkshopReservation_participantsNumber]
GO
ALTER TABLE [dbo].[WorkshopReservation] ADD DEFAULT (( 0 )) FOR [paid]
GO
ALTER TABLE [dbo].[WorkshopReservation] WITH NOCHECK ADD CONSTRAINT [Check_WorkshopReservation_paid]
CHECK (( [paid] >= 0 ))
GO
ALTER TABLE [dbo].[WorkshopReservation] CHECK CONSTRAINT [Check_WorkshopReservation_paid]
GO
--WorkshopRegistration
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create table WorkshopRegistration(
	workshopRegistrationID int not null identity(1,1),
	workshopReservationID_FK int not null,
	conferenceDayRegistrationID_FK int not null,
PRIMARY KEY CLUSTERED (
workshopRegistrationID ASC
) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF,
ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
)
ON [PRIMARY]
ALTER TABLE [dbo].[WorkshopRegistration]
WITH NOCHECK ADD CONSTRAINT [Check_WorkshopRegistration_workshopReservationID_FK]
FOREIGN KEY([workshopReservationID_FK])
REFERENCES [dbo].[WorkshopReservation] ([workshopreservationID])
GO
ALTER TABLE [dbo].[WorkshopRegistration]
CHECK CONSTRAINT [Check_WorkshopRegistration_workshopReservationID_FK]
GO
ALTER TABLE [dbo].[WorkshopRegistration]
WITH NOCHECK ADD CONSTRAINT [Check_WorkshopRegistration_conferenceDayRegistrationID_FK]
FOREIGN KEY([conferenceDayRegistrationID_FK])
REFERENCES [dbo].[ConferenceDayRegistration] ([conferenceDayRegistrationID])
GO
ALTER TABLE [dbo].[WorkshopRegistration]
CHECK CONSTRAINT [Check_WorkshopRegistration_conferenceDayRegistrationID_FK]
GO
