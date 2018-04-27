use aszaflar_a
IF OBJECT_ID('dbo.tr_ConfDayValidate', 'TR') IS NOT NULL
	drop trigger tr_ConfDayValidate
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[tr_ConfDayValidate]
	ON [dbo].[ConferenceDayReservation]
AFTER INSERT, UPDATE
AS BEGIN
	DECLARE @conf_day_reservation_id INT

	IF @@ROWCOUNT = 0
		RETURN
	IF @@ROWCOUNT = 1
		BEGIN
			SELECT @conf_day_reservation_id = conferencedayreservationid
			FROM INSERTED

			EXEC validateRegistrNumber @conf_day_reservation_id
		END
	ELSE
		BEGIN
			DECLARE cur_Inserted CURSOR LOCAL FAST_FORWARD
			FOR SELECT DISTINCT conferencedayreservationid
				FROM INSERTED

			 OPEN cur_Inserted


		FETCH NEXT FROM cur_Inserted
		INTO @conf_day_reservation_id
		WHILE @@FETCH_STATUS = 0
			BEGIN
				EXEC validateRegistrNumber @conf_day_reservation_id

				FETCH NEXT FROM cur_Inserted
				INTO @conf_day_reservation_id
			END
			CLOSE cur_Inserted
			DEALLOCATE cur_Inserted
		END
	END
 GO
 ALTER TABLE [dbo].[ConferenceDayReservation] ENABLE TRIGGER [tr_ConfDayValidate]
 GO

 IF OBJECT_ID('dbo.tr_WorkshopValidate', 'TR') IS NOT NULL
 	drop trigger tr_WorkshopValidate
 SET ANSI_NULLS ON
 GO
 SET QUOTED_IDENTIFIER ON
 GO
 CREATE TRIGGER [dbo].[tr_WorkshopValidate]
 ON [dbo].[WorkshopReservation]
 AFTER INSERT, UPDATE
 AS
 BEGIN
 DECLARE
 @workshop_reservation_id INT
 IF @@ROWCOUNT = 0
 RETURN
 IF @@ROWCOUNT = 1
 BEGIN
 SELECT @workshop_reservation_id = workshopreservationid
 FROM INSERTED
 EXEC validateWorkshopRegistrNumber @workshop_reservation_id
 END
 ELSE
 BEGIN
 DECLARE cur_Inserted
 CURSOR LOCAL FAST_FORWARD FOR
 SELECT DISTINCT workshopreservationid
 FROM INSERTED
 OPEN cur_Inserted
 FETCH NEXT FROM cur_Inserted
 INTO @workshop_reservation_id
 WHILE @@FETCH_STATUS = 0 BEGIN
 EXEC validateWorkshopRegistrNumber @workshop_reservation_id
 FETCH NEXT FROM cur_Inserted
 INTO @workshop_reservation_id
 END
 CLOSE cur_Inserted
 DEALLOCATE cur_Inserted
 END
 END
 GO
 ALTER TABLE [dbo].[WorkshopReservation] ENABLE TRIGGER [tr_WorkshopValidate]
 GO
