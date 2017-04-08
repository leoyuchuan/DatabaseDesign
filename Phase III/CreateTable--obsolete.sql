/**
 * Database Project Phase III C Database Creation
 */

/**
 * PEOPLE(net_id ,phone_number, DOB, email, last_name, middle_name, first_name, zip_code, state, city, street)
 */
CREATE TABLE `PEOPLE`
(
	`net_id` VARCHAR(24) NOT NULL,
	`phone_number` INTEGER NOT NULL,
	`DOB` DATE NOT NULL,
	`email` VARCHAR(128),
	`last_name` VARCHAR(32)  NOT NULL,
	`middle_name` VARCHAR(32),
	`first_name` VARCHAR(32)  NOT NULL,
	`zip_code` INTEGER NOT NULL,
	`state` VARCHAR(24)  NOT NULL,
	`city` VARCHAR(24)  NOT NULL,
	`street` VARCHAR(128)  NOT NULL,
	CONSTRAINT `pk_people` PRIMARY KEY (`net_id`),
	CONSTRAINT `chk_people_phonenumber` CHECK (`phone_number`>=1000000000 AND `phone_number`<=9999999999),
	CONSTRAINT `chk_people_zipcode` CHECK (`zip_code`>=10000 AND `zip_code`<=99999)
);


/**
 * STUDENT(net_id , track_name)
 */
CREATE TABLE `STUDENT`
(
	`net_id` VARCHAR(24)  NOT NULL,
	`track_name` VARCHAR(64) NOT NULL,
	CONSTRAINT `pk_student` PRIMARY KEY (`net_id`),
	CONSTRAINT `fk_student` FOREIGN KEY (`net_id`) REFERENCES `PEOPLE`(`net_id`)
);

/**
 * EMPLOYEE (ssn, net_id, salary)
 */
CREATE TABLE `EMPLOYEE`
(
	`ssn` INTEGER NOT NULL,
	`net_id` VARCHAR(24) NOT NULL,
	`salary` DECIMAL(18,2) NOT NULL,
	CONSTRAINT `pk_employee` PRIMARY KEY (`net_id`),
	CONSTRAINT `fk_employee` FOREIGN KEY (`net_id`) REFERENCES `PEOPLE`(`net_id`)
);

/**
 * RA(net_id)
 */
CREATE TABLE `RA`
(
	`net_id` VARCHAR(24) NOT NULL,
	CONSTRAINT `pk_ra` PRIMARY KEY (`net_id`),
	CONSTRAINT `fk_ra_1` FOREIGN KEY (`net_id`) REFERENCES `STUDENT` (`net_id`),
	CONSTRAINT `fk_ra_2` FOREIGN KEY (`net_id`) REFERENCES `EMPLOYEE` (`net_id`)
);

/**
 * ROOM(room_number, building_abbreviation)
 */
CREATE TABLE `ROOM`
(
	`room_number` INTEGER NOT NULL,
	`building_abbreviation` VARCHAR(10),
	CONSTRAINT `pk_room` PRIMARY KEY (`room_number`, `building_abbreviation`),
	CONSTRAINT `chk_room_roomnumber` CHECK (`room_number`>=1000 AND `room_number`<=9999),
	CONSTRAINT `fk_room` FOREIGN KEY (`building_abbreviation`) REFERENCES `BUILDING`(`abbreviation`)
);

/**
 * LAB (room_number, building_abbreviation, name)
 */
CREATE TABLE `LAB`
(
	`room_number` INTEGER NOT NULL,
	`building_abbreviation` VARCHAR(10) NOT NULL,
	`name` VARCHAR(64) NOT NULL,
	CONSTRAINT `pk_lab` PRIMARY KEY (`room_number`, `building_abbreviation`),
	CONSTRAINT `chk_lab_roomnumber` CHECK (`room_number`>=1000 AND `room_number`<=9999),
	CONSTRAINT `fk_lab` FOREIGN KEY (`room_number`,`building_abbreviation`) REFERENCES `ROOM` (`room_number`,`building_abbreviation`)
);

/**
 * CLASSROOM (building_abbreviation, room_number, capacity, computer_password)
 */
CREATE TABLE `CLASSROOM`
(
	`building_abbreviation` VARCHAR(10) NOT NULL,
	`room_number` INTEGER NOT NULL,
	`capacity` INTEGER NOT NULL ,
	`computer_password` VARCHAR(64),
	CONSTRAINT `pk_classroom` PRIMARY KEY (`building_abbreviation`, `room_number`),
	CONSTRAINT `chk_classroom_roomnumber` CHECK (`room_number`>=1000 AND `room_number`<=9999),
	CONSTRAINT `fk_classroom` FOREIGN KEY (`building_abbreviation`,`room_number`) REFERENCES `ROOM`(`room_number`,`building_abbreviation`)
);

/**
 * OFFICE(room_number, building_abbreviation)
 */
CREATE TABLE `OFFICE`
(
	`room_number` INTEGER NOT NULL,
	`building_abbreviation` VARCHAR(10) NOT NULL,
	CONSTRAINT `pk_office` PRIMARY KEY (`room_number`, `building_abbreviation`),
	CONSTRAINT `chk_office_roomnumber` CHECK(`room_number`>=1000 AND `room_number`<=9999),
	CONSTRAINT `fk_office` FOREIGN KEY (`room_number`,`building_abbreviation`) REFERENCES `ROOM`(`room_number`,`building_abbreviation`)
);

/**
 * TA(net_id , office_roomnumber , office_building_abbreviation, office_hour)
 */
CREATE TABLE `TA`
(
	`net_id` VARCHAR(24) NOT NULL,
	`office_roomnumber` INTEGER NOT NULL,
	`office_building_abbreviation` VARCHAR(10) NOT NULL,
	`office_hour` DECIMAL(5,2) NOT NULL,
	CONSTRAINT `pk_ta` PRIMARY KEY (`net_id`),
	CONSTRAINT `chk_ta_office_number` CHECK (`office_number`>=1000 AND `office_number`<=9999),
	CONSTRAINT `fk_ta_1` FOREIGN KEY (`net_id`) REFERENCES `STUDENT` (`net_id`),
	CONSTRAINT `fk_ta_2` FOREIGN KEY (`net_id`) REFERENCES `EMPLOYEE` (`net_id`),
	CONSTRAINT `fk_ta_3` FOREIGN KEY (`office_roomnumber`,`office_building_abbreviation`) REFERENCES `OFFICE` (`room_number`,`building_abbreviation`)
);

/**
 * PROFESSOR(net_id , rank, office_roomnumber, office_building_abbreviation , office_hour)
 */
CREATE TABLE `PROFESSOR`
(
	`net_id` VARCHAR(24) NOT NULL,
	`rank` VARCHAR(10) NOT NULL,
	`office_roomnumber` INTEGER NOT NULL,
	`office_building_abbreviation` VARCHAR(10)  NOT NULL,
	`office_hour` DECIMAL(5,2) NOT NULL,
	CONSTRAINT `pk_professor` PRIMARY KEY (`net_id`),
	CONSTRAINT `chk_professor_orn` CHECK (`office_roomnumber`>=1000 AND `office_roomnumber`<=9999),
	CONSTRAINT `chk_professor_rank` CHECK (`rank` IN ('assistant','associate','full')),
	CONSTRAINT `fk_professor_1` FOREIGN KEY (`office_roomnumber`,`office_building_abbreviation`) REFERENCES `OFFICE`(`room_number`,`building_abbreviation`),
	CONSTRAINT `fk_professor_2` FOREIGN KEY (`net_id`) REFERENCES `EMPLOYEE`(`net_id`)
);

/**
 * ADVICE (prof_net_id, student_net_id)
 */
CREATE TABLE `ADVICE`
(
	`prof_net_id` VARCHAR(24) NOT NULL,
	`student_net_id` VARCHAR(24) NOT NULL,
	CONSTRAINT `pk_advice` PRIMARY KEY (`prof_net_id`, `student_net_id`),
	CONSTRAINT `fk_advice_1` FOREIGN KEY (`prof_net_id`) REFERENCES `PROFESSOR`(`net_id`),
	CONSTRAINT `fk_advice_2` FOREIGN KEY (`student_net_id`) REFERENCES `STUDENT`(`net_id`)
);

/**
 * LECTURER (net_id, office_roomnumber, office_building_abbreviation, office_hour)
 */
CREATE TABLE `LECTURER`
(
	`net_id` VARCHAR(24) NOT NULL,
	`office_roomnumber` INTEGER NOT NULL,
	`office_building_abbreviation` VARCHAR(10) NOT NULL,
	`office_hour` DECIMAL(5,2) NOT NULL,
	CONSTRAINT `pk_lecturer` PRIMARY KEY (`net_id`),
	CONSTRAINT `chk_lecturer_orn` CHECK (`office_roomnumber`>=1000 AND `office_roomnumber`<=9999),
	CONSTRAINT `fk_lecturer` FOREIGN KEY (`office_roomnumber`,`office_building_abbreviation`) REFERENCES `OFFICE`(`office_roomnumber`,`office_building_abbreviation`)
);

/**
 * INSTRUCTOR (net_id)
 */
CREATE TABLE `INSTRUCTOR`
(
	`net_id` INTEGER NOT NULL,
	CONSTRAINT `pk_instructor` PRIMARY KEY (`net_id`),
	CONSTRAINT `fk_instructor` CHECK (`net_id` IN (SELECT `net_id` FROM `LECTURER` UNION SELECT `net_id` FROM `PROFESSOR`))
);

/**
 * DEPARTMENT (abbreviation, website_address, full_name, head_prof_net_id)
 */
CREATE TABLE `DEPARTMENT`
(
	`abbreviation` VARCHAR(10) NOT NULL,
	`website_address` VARCHAR(255),
	`full_name` VARCHAR(128) NOT NULL,
	`head_prof_net_id` VARCHAR(24) NOT NULL,
	CONSTRAINT `pk_department` PRIMARY KEY (`abbreviation`),
	CONSTRAINT `fk_department` FOREIGN KEY (`head_prof_net_id`) REFERENCES `PROFESSOR`(`net_id`)
);

/**
 * HIRE (dept_abbreviation, net_id)
 */
CREATE TABLE `HIRE`
(
	`dept_abbreviation` VARCHAR(10) NOT NULL,
	`net_id` VARCHAR(24) NOT NULL,
	CONSTRAINT `pk_hire` PRIMARY KEY (`dept_abbreviation`, `net_id`),
	CONSTRAINT `fk_hire_1` FOREIGN KEY (`dept_abbreviation`) REFERENCES `DEPARTMENT`(`abbreviation`),
	CONSTRAINT `fk_hire_2` FOREIGN KEY (`net_id`) REFERENCES `EMPLOYEE`(`net_id`)
);

/**
 * TRACK (name, dept_abbreviation)
 */
CREATE TABLE `TRACK`
(
	`name` VARCHAR(64) NOT NULL,
	`dept_abbreviation` VARCHAR(10) NOT NULL,
	CONSTRAINT `pk_track` PRIMARY KEY (`name`),
	CONSTRAINT `fk_track` FOREIGN KEY (`dept_abbreviation`) REFERENCES `DEPARTMENT`(`abbreviation`)
);

/**
 * COURSE (course_number, name, credit_hour, dept_abbreviation)
 */
CREATE TABLE `COURSE`
(
	`course_number` INTEGER NOT NULL,
	`name` VARCHAR(64) NOT NULL,
	`credit_hour` INTEGER NOT NULL,
	`dept_abbreviation` VARCHAR(10) NOT NULL,
	CONSTRAINT `pk_course` PRIMARY KEY (`course_number`),
	CONSTRAINT `chk_course_credithour` CHECK (`credit_hour`>=1 AND `credit_hour`<=6),
	CONSTRAINT `fk_course` FOREIGN KEY (`dept_abbreviation`) REFERENCES `DEPARTMENT`(`abbreviation`)
);

/**
 * STUDENT_PREREQUISITE (student_net_id, course_number)
 */
CREATE TABLE `STUDENT_PREREQUISITE`
(
	`student_net_id` VARCHAR(24) NOT NULL,
	`course_number` INTEGER NOT NULL,
	CONSTRAINT `pk_sp` PRIMARY KEY (`student_net_id`, `course_number`),
	CONSTRAINT `chk_sp_coursenumber` CHECK (`course_number`>=1000 AND `course_number`<=9999),
	CONSTRAINT `fk_sp_1` FOREIGN KEY (`student_net_id`) REFERENCES `STUDENT`(`net_id`),
	CONSTRAINT `fk_sp_2` FOREIGN KEY (`course_number`) REFERENCES `COURSE`(`course_number`)
);

/**
 * TRACK_CORE_COURSE (track_name, course_number)
 */
CREATE TABLE `TRACK_CORE_COURSE`
(
	`track_name` VARCHAR(64) NOT NULL,
	`course_number` INTEGER NOT NULL,
	CONSTRAINT `pk_tcc` PRIMARY KEY (`track_name`, `course_number`),
	CONSTRAINT `chk_tcc_coursenumber` CHECK (`course_number`>=1000 AND `course_number`<=9999),
	CONSTRAINT `fk_tcc_1` FOREIGN KEY (`track_name`) REFERENCES `TRACK`(`name`),
	CONSTRAINT `fk_tcc_2` FOREIGN KEY (`course_number`) REFERENCES `COURSE`(`course_number`)
);

/**
 * SECTION(course number ,  section_number , year , semester , class_time , capacity, instructor_net_id, building_abbreviation , room_number)
 */
CREATE TABLE `SECTION`
(
	`course_number` INTEGER NOT NULL,
	`section_number` INTEGER NOT NULL,
	`year` INTEGER NOT NULL,
	`semester` VARCHAR(10) NOT NULL,
	`class_time` DECIMAL(5,2) NOT NULL,
	`capacity` INTEGER NOT NULL,
	`instructor_net_id` VARCHAR(24),
	`building_abbreviation` VARCHAR(10),
	`room_number` INTEGER NOT NULL,
	CONSTRAINT `pk_section` PRIMARY KEY (`course_number`, `section_number`, `year`, `semester`),
	CONSTRAINT `chk_section_coursenumber` CHECK(`course_number`>=1000 AND `course_number`<=9999),
	CONSTRAINT `chk_section_year` CHECK (`year`>=1000 AND `year`<=9999),
	CONSTRAINT `chk_section_roomnumber` CHECK (`room_number`>=1000 AND `room_number`<=9999),
	CONSTRAINT `fk_section_1` FOREIGN KEY (`course_number`) REFERENCES `COURSE`(`course_number`),
	CONSTRAINT `fk_section_2` FOREIGN KEY (`instructor_net_id`) REFERENCES `INSTRUCTOR`(`net_id`),
	CONSTRAINT `fk_section_3` FOREIGN KEY (`building_abbreviation`,`room_number`) REFERENCES `CLASSROOM`(`building_abbreviation`,`room_number`)
);

/**
 * SECTION_HAS_TA (ta_net_id, course_number, section_number, year, semester, workload)
 */
CREATE TABLE `SECTION_HAS_TA`
(
	`ta_net_id` VARCHAR(24) NOT NULL,
	`course_number` INTEGER NOT NULL,
	`section_number` INTEGER NOT NULL,
	`year` INTEGER NOT NULL,
	`semester` VARCHAR(10) NOT NULL,
	`workload` DECIMAL(5,2) NOT NULL,
	CONSTRAINT `pk_sht` PRIMARY KEY (`ta_net_id`,`course_number`, `section_number`, `year`, `semester`),
	CONSTRAINT `chk_sht_coursenumber` CHECK (`course_number`>=1000 AND `course_number`<=9999),
	CONSTRAINT `chk_sht_sectionnumber` CHECK (`section_number`>=0 AND `section_number`<=999),
	CONSTRAINT `ch_sht_year` CHECK (`year`>=1000 AND `year`<=9999),
	CONSTRAINT `fk_sht_1` FOREIGN KEY (`ta_net_id`) REFERENCES `TA` (`net_id`),
	CONSTRAINT `fk_sht_2` FOREIGN KEY (`course_number`,`section_number`,`year`,`semester`) REFERENCES `SECTION`(`course_number`,`section_number`,`year`,`semester`)
);

/**
 * BUILDING (abbreviation, full_name, dept_abbreviation)
 */
CREATE TABLE `BUILDING`
(
	`abbreviation` VARCHAR(10) NOT NULL,
	`full_name` VARCHAR(32) NOT NULL,
	`dept_abbreviation` VARCHAR(10) NOT NULL,
	CONSTRAINT `pk_building` PRIMARY KEY (`abbreviation`),
	CONSTRAINT `fk_building` FOREIGN KEY (`dept_abbreviation`) REFERENCES `DEPARTMENT`(`abbreviation`)
);

/**
 * COURSE_TEXTBOOK (course_number, textbook)
 */
CREATE TABLE `COURSE_TEXTBOOK`
(
	`course_number` INTEGER NOT NULL,
	`textbook` VARCHAR(64) NOT NULL,
	CONSTRAINT `pk_ct` PRIMARY KEY (`course_number`, `textbook`),
	CONSTRAINT `chk_ct_coursenumber` CHECK (`course_number`>=1000 AND `course_number`<=9999),
	CONSTRAINT `fk_ct` FOREIGN KEY (`course_number`) REFERENCES `COURSE`(`course_number`)
);

/**
 * RA_WORK_ASSIGNMENT(workload , prof_net_id , ra_net_id , room_number , building_abbreviation) 
 */
CREATE TABLE `RA_WORK_ASSIGNMENT`
(
	`workload` DECIMAL(5,2) NOT NULL,
	`prof_net_id` VARCHAR(24) NOT NULL,
	`ra_net_id` VARCHAR(24) NOT NULL,
	`room_number` INTEGER NOT NULL,
	`building_abbreviation` VARCHAR(10) NOT NULL,
	CONSTRAINT `pk_raw` PRIMARY KEY (`prof_net_id`, `room_number`, `building_abbreviation`),
	CONSTRAINT `chk_raw_roomnumber` CHECK (`room_number`>=1000 AND `room_number`<=9999),
	CONSTRAINT `fk_raw_1` FOREIGN KEY (`prof_net_id`) REFERENCES `PROFESSOR`(`net_id`),
	CONSTRAINT `fk_raw_2` FOREIGN KEY (`ra_net_id`) REFERENCES `RA`(`net_id`),
	CONSTRAINT `fk_raw_3` FOREIGN KEY (`room_number`,`building_abbreviation`) REFERENCES `LAB`(`room_number`,`building_abbreviation`)
);

/**
 * RUN (prof_net_id, building_abbreviation, room_number)
 */
CREATE TABLE `RUN`
(
	`prof_net_id` VARCHAR(24) NOT NULL,
	`building_abbreviation` VARCHAR(10) NOT NULL,
	`room_number` INTEGER NOT NULL,
	CONSTRAINT `pk_run` PRIMARY KEY (`prof_net_id`, `building_abbreviation`, `room_number`),
	CONSTRAINT `chk_run_roomnumber` CHECK (`room_number`>=1000 AND `room_number`<=9999),
	CONSTRAINT `fk_run` FOREIGN KEY (`prof_net_id`) REFERENCES `RUN`(`prof_net_id`),
	CONSTRAINT `fk_run` FOREIGN KEY (`building_abbreviation`,`room_number`) REFERENCES `LAB`(`building_abbreviation`,`room_number`)
);

/**
 * TAKE(student_net_id, course_number, section_number, year, semester, grade)
 */
CREATE TABLE `TAKE`
(
	`student_net_id` VARCHAR(24) NOT NULL,
	`course_number` INTEGER NOT NULL,
	`section_number` INTEGER NOT NULL,
	`year` INTEGER NOT NULL,
	`semester` VARCHAR(10) NOT NULL,
	`grade` DECIMAL(3,2),
	CONSTRAINT `pk_take` PRIMARY KEY (`student_net_id`, `course_number`, `section_number`, `year`, `semester`),
	CONSTRAINT `chk_take_coursenumber` CHECK (`course_number`>=1000 AND `course_number`<=9999),
	CONSTRAINT `chk_take_sectionnumber` CHECK (`section_number`>=0 AND `section_number`<=999),
	CONSTRAINT `chk_take_year` CHECK (`year`>=1000 AND `year`<9999),
	CONSTRAINT `chk_take_grade` CHECK (`grade`>=0.00 AND `grade`<=4.00),
	CONSTRAINT `fk_take_1` FOREIGN KEY (`student_net_id`) REFERENCES `STUDENT`(`net_id`),
	CONSTRAINT `fk_take_2` FOREIGN KEY (`course_number`,`section_number`,`year`,`semester`) REFERENCES `SECTION`(`course_number`,`section_number`,`year`,`semester`)
);

