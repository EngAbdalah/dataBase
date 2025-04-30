-- 6. Create a view for student names with their subjects’ names which they will study.
create VIEW student_subjects_view as
SELECT s.e_name as student_name,sub.sub_name as subject_name
from student s 
join stu_sub ss ON s.id = ss.stu_id
join subject sub on sub.id=ss.sub_id;

-- 7. Create a view for tracks names and the subjects which belong to it.
CREATE VIEW track_subjects_view AS
SELECT t.track_name,s.sub_name AS subject_name
FROM track t
JOIN track_sub ts ON t.id = ts.track_id
JOIN subject s ON ts.sub_id = s.id
ORDER BY t.track_name, s.sub_name;

-------------------------------------------
select * from track_subjects_view;

-- -------------------------------------------
-- 1-Write a query to find out which subjects are not associated with any track.

SELECT 
    subject.id AS subject_id,
    subject.sub_name AS subject_name,
    subject.max_score
FROM 
    subject
LEFT JOIN 
    track_sub ts ON subject.id = ts.sub_id
WHERE 
    ts.sub_id IS NULL
ORDER BY 
    subject.sub_name;

-- 2-Display name and age of each students
SELECT e_name, EXTRACT(YEAR FROM AGE(birth_date)) AS age
from student;

SELECT e_name,AGE(birth_date) AS age
from student;

-- 3-Display the name of students with their rounded score in each subject

SELECT s.e_name AS student_name,sub.sub_name AS subject_name,ROUND(g.grade) AS rounded_score
FROM student s
JOIN grades g ON s.id = g.stu_id
JOIN subject sub ON g.sub_id = sub.id
ORDER BY s.e_name, sub.sub_name;

-- Display the name of students with the year of Birthdate
SELECT e_name AS student_name, EXTRACT(YEAR FROM birth_date) AS year_of_birth
FROM student;

-------------------------------------------------------
-- Add new exam result, in date column use NOW() function

INSERT INTO exam (date)
VALUES (NOW());
-----------------------------------------------------
-- Write a query to calculate the average grade obtained by a specific student across all exams.
INSERT INTO grades (stu_id, sub_id, exam_id, grade)
VALUES (6, 2, 1, 85);
select avg(grade) as average_grade
from grades
where stu_id=5;

------------------------------------------------------------------------------------
-- Write a query to replace all occurrences of 'gmail.com' in email addresses with 'iti.com'.
update student 
set email =replace (email ,'gmail.com','iti.com')
where email like '%gmail.com';

select * from student;
-------------------------------------------------------
-- Write a query to calculate the difference in days between the current date and each exam date.

select id as exam_id,date ,current_date -date days_difference
from exam;
-----------------------------------------------------------------------------------------------
-- Write a query to check if each student's email address ends with '.com'.

select e_name , email , email like '%.com' AS "end_with.com"
from student;

-----------------------------------------------------------------------------------------------
-- Display each exam date like ‘MM/DD/YYYY’.
select to_char(date,'MM/DD/YYYY') as date_formate 
from exam;

