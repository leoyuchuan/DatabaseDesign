/**
 * Database Project Phase III E Select
 */

/**
 * 1. Retrieve name and phone number of students living in Richardson.
 */
SELECT p.last_name, p.middle_name, p.first_name, p.phone_number
FROM PEOPLE p, STUDENT s
WHERE (p.net_id = s.net_id)
AND (p.city = 'richardson');

/**
 * 2. Retrieve the SSN and name of lecturers and TA's working for CS department.
 */
SELECT e.ssn, p.last_name, p.middle_name, p.first_name
FROM (
	SELECT l.net_id
	FROM LECTURER l, HIRE h
	WHERE l.net_id = h.net_id
	AND h.dept_abbreviation = 'cs'
	UNION
	SELECT ta.net_id
	FROM TA ta, HIRE h
	WHERE ta.net_id = h.net_id
	AND h.dept_abbreviation = 'cs'
) lt, EMPLOYEE e, PEOPLE p
WHERE lt.net_id = e.net_id
AND lt.net_id = p.net_id; 

/**
 * 3. Retrieve the name and web site address of departments which have the most number of buildings.
 */
SELECT d.full_name, d.website_address
FROM (
	SELECT dept_abbreviation
	FROM BUILDING
	GROUP BY dept_abbreviation
	HAVING COUNT(*)=(
		SELECT MAX(num)
		FROM(
			SELECT Count(*) AS num
			FROM BUILDING
			GROUP BY dept_abbreviation
		)
	)
) abbr, DEPARTMENT d
WHERE (abbr.dept_abbreviation=d.abbreviation);

/**
 * 4. Retrieve the name and total capacity of all courses.
 */
SELECT c.name, sc.capacity
FROM (
	SELECT course_number, SUM(capacity) AS capacity
	FROM SECTION
	GROUP BY course_number
) sc, COURSE c
WHERE sc.course_number = c.course_number;

/**
 * 5. For students who work as both TA and RA, retrieve their name, address, and course sections they work for.
 */
SELECT p.last_name, p.middle_name, p.first_name, p.state, p.city, p.street, p.zip_code, c.name, s.course_number, s.section_number, s.year, s.semester
FROM TA t, RA r, PEOPLE p, SECTION_HAS_TA s, COURSE c
WHERE(t.net_id=r.net_id)
AND (t.net_id=p.net_id)
AND (t.net_id=s.ta_net_id)
AND (s.course_number=c.course_number);

/**
 * 6.	For each department, retrieve the name and salary of employees whose salary is higher than the average salary of the department.
 */
SELECT p.last_name, p.middle_name, p.first_name, e.salary
FROM (
	SELECT AVG(salary) AS avg_salary, dept_abbreviation
	FROM (
		SELECT em.net_id, hi.dept_abbreviation, em.salary
		FROM EMPLOYEE em, HIRE hi
		WHERE em.net_id = hi.net_id
	)
	GROUP BY dept_abbreviation
) avg, PEOPLE p, EMPLOYEE e, HIRE h
WHERE (avg.dept_abbreviation = h.dept_abbreviation)
AND (p.net_id = e.net_id) 
AND (e.net_id = h.net_id) 
AND (e.salary > avg.avg_salary);

/**
 * 7.	Retrieve the number of buildings which have classrooms with capacity higher than 200.
 */
SELECT COUNT(DISTINCT building_abbreviation)
FROM CLASSROOM
WHERE capacity>200;

/**
 * 8.	For each lecturer whose course sections have total capacity higher than 150, retrieve the lecturer's name and salary.
 */
SELECT DISTINCT p.last_name, p.middle_name, p.first_name, e.salary
FROM PEOPLE p, LECTURER l, SECTION s, EMPLOYEE e
WHERE (p.net_id = l.net_id) 
AND (l.net_id = s.instructor_net_id) 
AND (l.net_id = e.net_id)
AND (s.capacity > 150);

/**
 * 9.	Retrieve the name and id of students who have taken all core courses but have no advisor.
 */
SELECT p.last_name, p.middle_name, p.first_name, p.net_id 
FROM (
	SELECT net_id
	FROM STUDENT
	MINUS (
		SELECT DISTINCT net_id
		FROM (
			SELECT s.net_id, tcc.course_number
			FROM STUDENT s, TRACK_CORE_COURSE tcc
			WHERE s.track_name = tcc.track_name
			MINUS
			SELECT t.student_net_id, t.course_number
			FROM TAKE t
			WHERE t.grade IS NOT NULL
		)
	)
) cmpl, PEOPLE p
WHERE (cmpl.net_id = p.net_id) 
AND (cmpl.net_id NOT IN (
	SELECT DISTINCT student_net_id
	FROM ADVICE)
);

/**
 * 10.	Retrieve the course sections which are full (enrolled student number equals capacity).
 */
SELECT s.course_number, s.section_number, s.year, s.semester
FROM (
	SELECT t.course_number, t.section_number, t.year, t.semester, COUNT(*) AS taken
	FROM SECTION s, TAKE t
	WHERE (s.course_number = t.course_number) 
	AND (s.section_number = t.section_number) 
	AND (s.year = t.year) 
	AND (s.semester = t.semester)
	GROUP BY t.course_number, t.section_number, t.year, t.semester
) tk, SECTION s
WHERE tk.course_number = s.course_number
AND tk.section_number = s.section_number
AND tk.year = s.year
AND tk.semester = s.semester
AND tk.taken = s.capacity;



/**
 * 11. For each track of CS department, retrieve their name, number of core courses, and number of students.
 */
SELECT t.name, cn.cnum, sn.snum
FROM (
	SELECT track_name, COUNT(*) AS cnum
	FROM TRACK_CORE_COURSE
	GROUP BY track_name
) cn, (
	SELECT track_name, COUNT(*) AS snum
	FROM STUDENT
	GROUP BY track_name
) sn, TRACK t
WHERE t.name = cn.track_name
AND t.name = sn.track_name
AND t.dept_abbreviation = 'cs';

/**
 * 12. Retrieve the average salary of lecturers who instruct at least 3 course sections.
 */
SELECT AVG(salary)
FROM EMPLOYEE e
WHERE e.net_id IN (
	SELECT instructor_net_id AS net_id
	FROM SECTION
	WHERE instructor_net_id IN (SELECT net_id FROM LECTURER)
	GROUP BY instructor_net_id
	HAVING COUNT(*)>=3
);

/**
 * 13. Retrieve the name and id of professors who run exactly one lab and their lab and office are in the same building.
 */
SELECT p.last_name, p.middle_name, p.first_name, prof.prof_net_id
FROM ( 
	SELECT prof_net_id
	FROM PROFESSOR p, RUN r
	WHERE p.net_id IN (
		SELECT prof_net_id
		FROM RUN
		GROUP BY prof_net_id
		HAVING COUNT(*)=1
	)
	AND p.net_id = r.prof_net_id
	AND p.office_building_abbreviation = r.building_abbreviation
) prof, PEOPLE p
WHERE prof.prof_net_id = p.net_id;

/**
 * 14. For each department, retrieve the name of the highest paid professor and the name of lab(s) she run.
 */
SELECT p.last_name, p.middle_name, p.first_name, l.name
FROM PEOPLE p, RUN r, LAB l
WHERE p.net_id IN (
	SELECT net_id
	FROM (
		SELECT net_id, salary
		FROM EMPLOYEE
		WHERE net_id IN (SELECT net_id FROM PROFESSOR)
	)
	WHERE salary = (
		SELECT MAX(salary)
		FROM (
			SELECT net_id, salary
			FROM EMPLOYEE
			WHERE net_id IN (SELECT net_id FROM PROFESSOR)
		)
	)
)
AND p.net_id = r.prof_net_id
AND r.building_abbreviation = l.building_abbreviation
AND r.room_number = l.room_number;

/**
 * 15. Retrieve the name and email address of students with highest GPA.
 */
SELECT last_name, middle_name, first_name, email
FROM PEOPLE
WHERE net_id IN (
	SELECT student_net_id
	FROM TAKE
	GROUP BY student_net_id
	HAVING AVG(grade) = (
		SELECT MAX(avggrade)
		FROM (
			SELECT student_net_id, AVG(grade) AS avggrade
			FROM TAKE
			GROUP BY student_net_id
		)
	)
)
