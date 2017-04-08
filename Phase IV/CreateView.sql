/**
 * Database Project Phase III D View Creation
 */

/**
 * 1.	Department heads: List all department names with their department head's names and salaries.
 */
CREATE VIEW Department_heads AS
SELECT d.full_name, p.last_name, p.middle_name, p.first_name, e.salary
FROM PEOPLE p, EMPLOYEE e, DEPARTMENT d
WHERE p.net_id = e.net_id AND e.net_id = d.head_prof_net_id;

/**
 * 2.	Students with prerequisites: List name of students who have any prerequisite course (no matter he/she had taken it or not).
 */
CREATE VIEW Students_with_prerequisites AS
SELECT p.last_name, p.middle_name, p.first_name
FROM STUDENT s, STUDENT_PREREQUISITE sp, PEOPLE p
WHERE s.net_id = p.net_id 
AND s.net_id = sp.student_net_id;

/**
 * 3. Current courses: List name and department of courses that have section in current semester.
 */
CREATE VIEW Current_courses AS
SELECT distinct c.name, d.full_name
FROM COURSE c, DEPARTMENT d, SECTION s
WHERE (c.course_number=s.course_number)
AND (d.abbreviation=c.dept_abbreviation) 
AND (s.year=2014) 
AND (s.semester='fall');

/**
 * 4. Student workers: List name and id of students who work as TA and/or RA, with their workloads. If a student work as both TA and RA, or if she work as TA for several course sections, show her total workload.
 */
CREATE VIEW Student_workers AS
SELECT p.last_name, p.middle_name, p.first_name, wl.net_id, wl.workload
FROM(
	SELECT net_id, SUM(workload) AS workload
	FROM(
		SELECT ra_net_id AS net_id, workload
		FROM RA_WORK_ASSIGNMENT
		UNION ALL
		SELECT ta_net_id AS net_id, workload 
		FROM SECTION_HAS_TA
	)
	GROUP BY net_id
) wl, PEOPLE p
WHERE wl.net_id = p.net_id;


