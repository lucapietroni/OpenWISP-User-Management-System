DROP TRIGGER IF EXISTS trig_total_surfing_time; 

DELIMITER $$

CREATE
    TRIGGER trig_total_surfing_time BEFORE INSERT ON radacct 
    FOR EACH ROW
    BEGIN
        SELECT TotalSurfingTime INTO @session_surf_time FROM radacct WHERE UserName = NEW.UserName AND TotalSurfingTime != 0 AND is_surf = 1 ORDER BY RadAcctId DESC LIMIT 1;
    	
		SELECT TIMESTAMPDIFF(SECOND, NEW.AcctStartTime, NEW.AcctStopTime) INTO @total_last_seconds FROM radacct WHERE RadAcctId = NEW.RadAcctId LIMIT 1;
		
		IF @session_surf_time THEN
			SET NEW.TotalSurfingTime = TIMESTAMPDIFF(SECOND, NEW.AcctStartTime, NEW.AcctStopTime) + @session_surf_time;
		ELSE
			SET NEW.TotalSurfingTime = TIMESTAMPDIFF(SECOND, NEW.AcctStartTime, NEW.AcctStopTime);
		END IF;	
    	
    END;
$$