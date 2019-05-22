/* Fonction qui ajoute une activité avec son propriétaire */
CREATE OR REPLACE FUNCTION add_activity(in_title character, in_description text, in_owner_id bigint) RETURNS activity AS $$

	--Je suis un commentaire
	/* Moi aussi */
	
	/* But de la fonction */
	-- On ajoute une ligne dans activity avec les éléments fournis en paramètres
	-- Si in_owner_id n'est pas fourni, on le remplace par l'id du default owner
	-- On renvoie ensuite la ligne correspondant à la nouvelle activité
	
	/* Début du code */

DECLARE
	retour activity%rowtype;
	
BEGIN

	INSERT INTO activity (id, title, description, creation_date, modification_date, owner_id)
	VALUES (nextval('id_generator'), in_title, in_description, now(), now(), in_owner_id);
	SELECT * INTO retour FROM activity WHERE title = in_title AND description = in_description AND owner_id = in_owner_id;
	
	return retour;
	
END;
$$ LANGUAGE plpgsql;




/* Fonction qui ajoute une activité sans son propriétaire */
CREATE OR REPLACE FUNCTION add_activity(in_title character, in_description text) RETURNS activity AS $$

DECLARE
	retour activity%rowtype;
	default_id bigint;

BEGIN

	SELECT id INTO default_id FROM get_default_owner();
	INSERT INTO activity (id, title, description, creation_date, modification_date, owner_id)
	VALUES (nextval('id_generator'), in_title, in_description, now(), now(), default_id);
	SELECT * INTO retour FROM activity WHERE title = in_title AND description = in_description;
	
	return retour;
	 
END;
$$ LANGUAGE plpgsql;	




/* Fonction qui renvoie toutes les activités avec leur propriétaire respectif */
CREATE OR REPLACE FUNCTION find_all_activities(pointeur refcursor) RETURNS refcursor AS $$

BEGIN

	OPEN pointeur for SELECT activity.id, activity.title, "user".username FROM activity
	LEFT JOIN "user" ON "user".id = activity.owner_id;
	return pointeur;
	
END;
	
$$ LANGUAGE plpgsql;
