DROP TRIGGER IF EXISTS log_delete_activity on activity;

CREATE OR REPLACE FUNCTION log_delete_activity() RETURNS TRIGGER AS $$
BEGIN

INSERT INTO action_log (id, action_name, entity_name, entity_id, author, action_date)
VALUES(nextval('id_generator'), 'delete', 'activity', old.id, user, now());
RETURN NULL;
        
        
END;
$$ language plpgsql;

CREATE TRIGGER log_delete_activity
	AFTER DELETE ON activity
	FOR EACH ROW EXECUTE PROCEDURE log_delete_activity();
	
	

			