CREATE OR REPLACE FUNCTION register_user_on_activity(id_user bigint, id_activity bigint) RETURNS registration AS $$


DECLARE
	retour registration%rowtype;
BEGIN

	SELECT * INTO retour FROM registration WHERE user_id = id_user AND activity_id = id_activity;
	if FOUND then
		raise exception 'registration_already_exists';
	end if;

	INSERT INTO registration (id, registration_date,  user_id, activity_id)
	VALUES (nextval('id_generator'), now(),  id_user, id_activity);
	SELECT * INTO retour FROM registration WHERE user_id = id_user AND activity_id = id_activity;
	RETURN retour;
	
	
END;
$$ LANGUAGE plpgsql; 


DROP TRIGGER IF EXISTS action_log_registration on registration;

CREATE OR REPLACE FUNCTION action_log_registration() RETURNS TRIGGER AS $$
BEGIN

	INSERT INTO action_log (id, action_name, entity_name, entity_id, author, action_date)
	VALUES(nextval('id_generator'), 'insert', 'registration', new.id, user, now());
	RETURN NULL;

END;
$$ language plpgsql;


CREATE TRIGGER action_log_registration
	AFTER INSERT ON registration
	FOR EACH ROW EXECUTE PROCEDURE action_log_registration();
	
	
	
CREATE OR REPLACE FUNCTION unregister_user_on_activity(id_user bigint, id_activity bigint) RETURNS void AS $$

DECLARE
	retour registration%rowtype;
BEGIN

	SELECT * INTO retour FROM registration WHERE user_id = id_user AND activity_id = id_activity;
	if NOT FOUND then
		raise exception 'registration_not_found';
	end if;

	DELETE FROM registration
	WHERE user_id = id_user AND activity_id = id_activity;
	
END;
$$ LANGUAGE plpgsql;


DROP TRIGGER IF EXISTS action_log_registration_delete on registration;

CREATE OR REPLACE FUNCTION action_log_registration_delete() RETURNS TRIGGER AS $$
BEGIN

	INSERT INTO action_log (id, action_name, entity_name, entity_id, author, action_date)
	VALUES(nextval('id_generator'), 'delete', 'registration', old.id, user, now());
	RETURN NULL;

END;
$$ language plpgsql;


CREATE TRIGGER action_log_registration_delete
	AFTER DELETE ON registration
	FOR EACH ROW EXECUTE PROCEDURE action_log_registration_delete();