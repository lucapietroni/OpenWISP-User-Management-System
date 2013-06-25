DELIMITER $$

CREATE
    TRIGGER trig_total_surfing_time BEFORE UPDATE ON radacct 
    FOR EACH ROW
    BEGIN
        SELECT TotalSurfingTime INTO @session_surf_time FROM radacct WHERE UserName = NEW.UserName AND TotalSurfingTime != 0 AND is_surf = 1 ORDER BY RadAcctId DESC LIMIT 1;
    	IF NOT (NEW.AcctStopTime <=> OLD.AcctStopTime) THEN
    		SELECT TIMESTAMPDIFF(SECOND, NEW.AcctStartTime, NEW.AcctStopTime) INTO @total_last_seconds FROM radacct WHERE RadAcctId = NEW.RadAcctId LIMIT 1;
    		SET NEW.TotalSurfingTime = @total_last_seconds + @session_surf_time;
    	END IF;
    END;
$$