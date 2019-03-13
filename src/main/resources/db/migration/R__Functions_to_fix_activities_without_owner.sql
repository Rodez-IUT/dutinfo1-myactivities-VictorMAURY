CREATE OR REPLACE FUNCTION get_default_owner() RETURNS "user" AS $$

-- On vérifie que Default Owner n'existe pas, on ne fait rien si il existe.
-- Sinon on l'ajoute en même temps que son id qui sera générée aléatoirement
-- La fonction get_default_owner() renvoie la ligne correspondante à Default Owner
-- dans les deux cas

	DECLARE
		defaultOwner "user"%rowtype;
		defaultOwnerUsername varchar(500) := 'Default Owner';
	BEGIN
		select * into defaultOwner from "user"
			where username = defaultOwnerUsername;
		if not found then
			insert into "user" (id, username)
				values(nextval('id_generator'), defaultOwnerUsername);
			select * into defaultOwner from "user"
				where username = defaultOwnerUsername;
		end if;
		return defaultOwner;
	END
$$ LANGUAGE plpgsql;