-- -----------------------------------------------------------------------------------------------------------------------------------
-- Objective
-- You are tasked with cleaning and validating a dataset containing the Permanent Account Numbers PAN of Indian nationals. 
-- The goal is to ensure that each PAN number adheres to the official format and is categorised as either Valid or Invalid. 
-- The dataset is given in a separate Excel file.

-- -----------------------------------------------------------------------------------------------------------------------------------

create database Pan_Card;

use Pan_Card;

create table pan
(
	pan_number text
);
select * from pan;

select * from pan 
where pan_numbers is null;

select pan_numbers , count(pan_numbers) as numbers_of_pan
from pan 
group by pan_numbers
having count(pan_numbers) > 1;

select upper(pan_numbers) from pan ;

select upper(trim(pan_numbers)) from pan;

select upper(trim(pan_numbers)) from pan
where trim(pan_numbers) != " ";

--  DATA CLEANING -------------------------------------------------------------------------

select distinct upper(trim(pan_numbers)) as pan_no
from pan
where trim(pan_numbers) != ""
and pan_numbers is not null;

-- function creation -------------------------------------------------------------------

DELIMITER $$

CREATE FUNCTION check_adjacent(p_str TEXT) 
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE str_len INT;
    
    SET str_len = CHAR_LENGTH(p_str);
    
    IF str_len < 2 THEN
        RETURN FALSE;
    END IF;

    WHILE i < str_len DO
        IF SUBSTR(p_str, i, 1) = SUBSTR(p_str, i + 1, 1) THEN
            RETURN TRUE;
        END IF;
        SET i = i + 1;
    END WHILE;

    RETURN FALSE;
END$$

DELIMITER ;

-- creating  function for sequence check ---------------------------------------------------------
DELIMITER $$

CREATE FUNCTION check_sequence(p_str TEXT) 
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE str_len INT;
    
    SET str_len = CHAR_LENGTH(p_str);
    
    IF str_len < 2 THEN
        RETURN FALSE;
    END IF;

    WHILE i < str_len DO
        IF ascii(SUBSTR(p_str, i+1, 1)) - ascii(SUBSTR(p_str, i, 1)) != 1 THEN
            RETURN FALSE;
        END IF;
        SET i = i + 1;
    END WHILE;

    RETURN TRUE;
END$$

DELIMITER ;

-- Checking the function work  -------------------------------------------------------------

select check_sequence("ABCD");
select check_adjacent("ASKDF");
select check_adjacent("ABKKDF");

-- validating  -----------------------------------------------------------------------------



with pancard as 
(with clean as 
(select distinct upper(trim(pan_numbers)) as pan_no
from pan
where trim(pan_numbers) != ""
and pan_numbers is not null) ,
cte_valid as (
select * from clean
where 
     check_adjacent(pan_no) = 0 and
     check_sequence(substr(pan_no,1,5)) = 0 and
     check_sequence(substr(pan_no,6,4)) = 0 and
	 pan_no REGEXP '^[A-Z]{5}[0-9]{4}[A-Z]$'
)
select 
pan_no,
case when check_adjacent(pan_no) = 1 then "invalid"
     when check_sequence(substr(pan_no,1,5)) = 1 then "invalid" 
     when check_sequence(substr(pan_no,6,4)) = 1 then "invalid"
     when pan_no not REGEXP '^[A-Z]{5}[0-9]{4}[A-Z]$' then "invalid"
     else "valid"
     end as status
from clean)

select 
pan_no
from pancard
where status = "valid";















