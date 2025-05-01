-- Lab 4
-- 1. Create a multiply function that accepts two numbers and returns their product.
CREATE FUNCTION multiply(num1 NUMERIC, num2 NUMERIC)
RETURNS NUMERIC AS $$
BEGIN
    RETURN num1 * num2;
END;
$$ LANGUAGE plpgsql;

SELECT multiply(2,2);
-------------------------------------------------------------------------------------------------
-- 2. Create a hello_world function that takes a name as input and returns a personalized welcome message for that name.

create FUNCTION hello_world( name varchar)
RETURNS VARCHAR as $$
begin 
	RETURN 'Hello '|| name || ' welcome' ;
end;
$$ LANGUAGE plpgsql;

select hello_world('Abdallah');

drop FUNCTION hello_world( name varchar);


-------------------------------------------------------------------------------------------------
-- 3. Create a function that accepts a number and determines whether it is odd or even.

CREATE  OR REPLACE FUNCTION odd_or_even (num INTEGER )
RETURNS VARCHAR AS $$
BEGIN
	if num % 2 = 0 then 
    	RETURN 'event';
	ELSE 
		RETURN 'odd';
	END IF;
END ;
$$ LANGUAGE plpgsql;

SELECT odd_or_even(5);

drop FUNCTION odd_or_even (num INTEGER ) ;
-------------------------------------------------------------------------------------------------
-- 4. Create a function that takes a Student ID as input and retrieves all information related to that student.

Create or REPLACE FUNCTION get_student_info( student_id INTEGER )
RETURNS TABLE (id INTEGER,e_name VARCHAR,email VARCHAR )
as $$
BEGIN
    RETURN QUERY SELECT student.id,student.e_name,student.email FROM student WHERE student.id =get_student_info.student_id;
END;
$$ LANGUAGE plpgsql;


select get_student_info(5);

DROP FUNCTION get_student_info(integer);
-------------------------------------------------------------------------------------------------
-- 5. Implement a function that takes the name of a subject and calculates the average grades for that subject.
CREATE OR REPLACE FUNCTION subject_avg(subject_name VARCHAR)
RETURNS NUMERIC AS $$
DECLARE
    avg_grade NUMERIC;
BEGIN
    SELECT AVG(g.grade) INTO avg_grade
    FROM grades g
    JOIN subject s ON g.sub_id = s.id  -- Corrected: Use s.id (primary key of subject)
    WHERE s.sub_name = subject_avg.subject_name;  -- Ensure subject.name is correct
    
    RETURN COALESCE(avg_grade, 0);
END;
$$ LANGUAGE plpgsql;

select subject_avg('Database Systems');


-------------------------------------------------------------------------------------------------
-- 6. Create a trigger to automatically save deleted student records from the  Student table to the Deleted_Students table.

-------------------------------------------------------------------------------------------------
-- 7. Create a trigger to monitor changes made to the student table,
-- including additions, updates, and deletions. This trigger will record
-- the time of each action and provide a description of the action in
-- another table

-- Create Audit Table (if not exists)
CREATE TABLE IF NOT EXISTS Student_Audit (
    action_type VARCHAR(10),
    action_time TIMESTAMP,
    student_id INTEGER,
    description TEXT
);

-- Trigger Function
CREATE OR REPLACE FUNCTION log_student_changes()
RETURNS TRIGGER AS $$
BEGIN
    IF TG = 'INSERT' THEN
        INSERT INTO Student_Audit (action_type, action_time, student_id, description)
        VALUES ('INSERT', NOW(), NEW.id, 'New student added: ' || NEW.e_name);
    ELSIF TG = 'UPDATE' THEN
        INSERT INTO Student_Audit (action_type, action_time, student_id, description)
        VALUES ('UPDATE', NOW(), NEW.id, 'Updated student: ' || NEW.e_name);
    ELSIF TG = 'DELETE' THEN
        INSERT INTO Student_Audit (action_type, action_time, student_id, description)
        VALUES ('DELETE', NOW(), OLD.id, 'Deleted student: ' || OLD.e_name);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create Trigger
CREATE TRIGGER monitor_student_changes
AFTER INSERT OR UPDATE OR DELETE ON student
FOR EACH ROW
EXECUTE FUNCTION log_student_changes();

-----------------------------this is my test----------------------------------
select * from Student_Audit;

INSERT INTO student (id, e_name, email,address ,track_id,birth_date,gender)
        VALUES (1,'abdallah Ahmed','abd@gmail.com','banha',2,'2000-03-26','Male');
 

update student set e_name = 'abdallah Ahmed saide' 
where id =1;

delete from student 
where id =5;