CREATE OR REPLACE FUNCTION get_customers(start_id int, end_id int)
RETURNS TABLE (
	customer_id smallint,
	address_id int
) AS 
$BODY$
BEGIN
    IF start_id <= 0 OR end_id <= 0 OR start_id >= end_id OR end_id >= 600 THEN
        RAISE EXCEPTION 'Range out of bounds';
    END IF;

	RETURN QUERY
	SELECT C.address_id, C.customer_id
	FROM customer AS C
	ORDER BY C.address_id
	LIMIT (end_id - start_id + 1) OFFSET (start_id - 1);
END;
$BODY$
language plpgsql;