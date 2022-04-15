CREATE OR REPLACE FUNCTION get_address()
RETURNS TABLE (
    address character varying(50),
	address_id int
) AS
$BODY$
BEGIN
    RETURN query
    SELECT AD.address, AD.address_id
	FROM address AS AD
	WHERE AD.address LIKE '%11%' AND AD.city_id > 400 AND AD.city_id < 600;
END;
$BODY$
LANGUAGE plpgsql;