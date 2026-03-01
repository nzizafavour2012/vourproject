-- =====================================================
-- Vour School Notes System - MySQL Database Schema
-- =====================================================

-- Create database
CREATE DATABASE IF NOT EXISTS vour_school_notes;
USE vour_school_notes;

-- =====================================================
-- TABLES
-- =====================================================

-- 1. Departments Table
CREATE TABLE IF NOT EXISTS departments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 2. Trades Table (belongs to a department)
CREATE TABLE IF NOT EXISTS trades (
    id INT AUTO_INCREMENT PRIMARY KEY,
    department_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (department_id) REFERENCES departments(id) ON DELETE CASCADE,
    UNIQUE KEY unique_department_trade (department_id, name)
);

-- 3. Levels Table (belongs to a trade)
CREATE TABLE IF NOT EXISTS levels (
    id INT AUTO_INCREMENT PRIMARY KEY,
    trade_id INT NOT NULL,
    name VARCHAR(50) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (trade_id) REFERENCES trades(id) ON DELETE CASCADE,
    UNIQUE KEY unique_trade_level (trade_id, name)
);

-- 4. Users Table (Teachers, Students, Admin)
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    role ENUM('admin', 'teacher', 'student') NOT NULL,
    department_id INT,
    trade_id INT,
    level_id INT,
    is_approved BOOLEAN DEFAULT FALSE,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (department_id) REFERENCES departments(id) ON DELETE SET NULL,
    FOREIGN KEY (trade_id) REFERENCES trades(id) ON DELETE SET NULL,
    FOREIGN KEY (level_id) REFERENCES levels(id) ON DELETE SET NULL
);

-- 5. Subjects Table (assigned to teachers by admin)
CREATE TABLE IF NOT EXISTS subjects (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    teacher_id INT NOT NULL,
    trade_id INT NOT NULL,
    level_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (teacher_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (trade_id) REFERENCES trades(id) ON DELETE CASCADE,
    FOREIGN KEY (level_id) REFERENCES levels(id) ON DELETE CASCADE,
    UNIQUE KEY unique_subject_assignment (teacher_id, trade_id, level_id, name)
);

-- 6. Notes Table (uploaded by teachers)
CREATE TABLE IF NOT EXISTS notes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    file_name VARCHAR(255) NOT NULL,
    file_path VARCHAR(500) NOT NULL,
    file_type VARCHAR(50),
    file_size INT,
    subject_id INT NOT NULL,
    teacher_id INT NOT NULL,
    download_count INT DEFAULT 0,
    is_published BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (subject_id) REFERENCES subjects(id) ON DELETE CASCADE,
    FOREIGN KEY (teacher_id) REFERENCES users(id) ON DELETE CASCADE
);

-- =====================================================
-- SAMPLE DATA
-- =====================================================

-- Insert Departments
INSERT INTO departments (name, description) VALUES 
('ICT and Multimedia', 'Information and Communication Technology and Multimedia'),
('Professional Accounting', 'Professional Accounting and Finance'),
('Art and Craft', 'Art, Design and Craft');

-- Insert Trades
INSERT INTO trades (department_id, name) VALUES 
-- ICT Department
(1, 'Software Development'),
(1, 'Network and Internet Technology'),
(1, 'Computer System and Architecture'),
-- Professional Accounting
(2, 'Senior 4'),
(2, 'Senior 5'),
(2, 'Senior 6'),
-- Art and Craft
(3, 'Fashion and Design');

-- Insert Levels for ICT trades
INSERT INTO levels (trade_id, name) VALUES 
(1, 'L3'), (1, 'L4'), (1, 'L5'),
(2, 'L3'), (2, 'L4'), (2, 'L5'),
(3, 'L3'), (3, 'L4'), (3, 'L5');

-- Insert Levels for Professional Accounting
INSERT INTO levels (trade_id, name) VALUES 
(4, 'Level'), (5, 'Level'), (6, 'Level');

-- Insert Levels for Art and Craft
INSERT INTO levels (trade_id, name) VALUES 
(7, 'L3'), (7, 'L4'), (7, 'L5');

-- Insert Admin User (password: admin123)
INSERT INTO users (name, email, password, phone, role, is_approved) VALUES 
('System Admin', 'admin@vour.com', '$2a$10$XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX', '1234567890', 'admin', TRUE);

-- Insert Sample Teachers (password: teacher123)
INSERT INTO users (name, email, password, phone, role, department_id, trade_id, level_id, is_approved) VALUES 
('John Smith', 'john.smith@vour.com', '$2a$10$XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX', '9876543210', 'teacher', 1, 1, 1, TRUE),
('Sarah Johnson', 'sarah.johnson@vour.com', '$2a$10$XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX', '9876543211', 'teacher', 1, 2, 4, TRUE),
('Michael Brown', 'michael.brown@vour.com', '$2a$10$XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX', '9876543212', 'teacher', 2, 4, 1, TRUE),
('Emily Davis', 'emily.davis@vour.com', '$2a$10$XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX', '9876543213', 'teacher', 3, 7, 7, TRUE);

-- Insert Sample Students (password: student123, need approval)
INSERT INTO users (name, email, password, phone, role, department_id, trade_id, level_id, is_approved) VALUES 
('Alice Wonder', 'alice.wonder@student.vour.com', '$2a$10$XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX', '5551234567', 'student', 1, 1, 2, TRUE),
('Bob Martin', 'bob.martin@student.vour.com', '$2a$10$XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX', '5551234568', 'student', 1, 2, 5, FALSE),
('Charlie Lee', 'charlie.lee@student.vour.com', '$2a$10$XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX', '5551234569', 'student', 2, 4, 1, TRUE),
('Diana Rose', 'diana.rose@student.vour.com', '$2a$10$XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX', '5551234570', 'student', 3, 7, 8, TRUE);

-- Insert Sample Subjects
INSERT INTO subjects (name, description, teacher_id, trade_id, level_id) VALUES 
('Web Development Fundamentals', 'Introduction to HTML, CSS, and JavaScript', 1, 1, 1),
('Database Management', 'SQL and database design', 1, 1, 2),
('Network Security', 'Network security principles', 2, 2, 1),
('Financial Accounting', 'Basic accounting principles', 3, 4, 1),
('Fashion Design Basics', 'Introduction to fashion design', 4, 7, 7);

-- Insert Sample Notes
INSERT INTO notes (title, description, file_name, file_path, file_type, file_size, subject_id, teacher_id) VALUES 
('HTML Basics Tutorial', 'Complete guide to HTML tags and elements', 'html_basics.pdf', '/uploads/notes/html_basics.pdf', 'application/pdf', 2048576, 1, 1),
('CSS Styling Guide', 'CSS selectors and properties', 'css_styling.pdf', '/uploads/notes/css_styling.pdf', 'application/pdf', 1536000, 1, 1),
('SQL Queries Examples', 'Common SQL queries and exercises', 'sql_queries.pdf', '/uploads/notes/sql_queries.pdf', 'application/pdf', 1024000, 2, 1),
('Network Security Notes', 'Firewall and encryption concepts', 'network_security.pdf', '/uploads/notes/network_security.pdf', 'application/pdf', 2560000, 3, 2),
('Accounting Worksheet', 'Practice problems for accounting', 'accounting_worksheet.xlsx', '/uploads/notes/accounting_worksheet.xlsx', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 512000, 4, 3);

-- =====================================================
-- VIEWS
-- =====================================================

-- View for Teachers with their department/trade/level info
CREATE OR REPLACE VIEW v_teachers AS
SELECT 
    u.id, u.name, u.email, u.phone, u.is_approved,
    d.name AS department_name,
    t.name AS trade_name,
    l.name AS level_name
FROM users u
LEFT JOIN departments d ON u.department_id = d.id
LEFT JOIN trades t ON u.trade_id = t.id
LEFT JOIN levels l ON u.level_id = l.id
WHERE u.role = 'teacher';

-- View for Students with their department/trade/level info
CREATE OR REPLACE VIEW v_students AS
SELECT 
    u.id, u.name, u.email, u.phone, u.is_approved,
    d.name AS department_name,
    t.name AS trade_name,
    l.name AS level_name
FROM users u
LEFT JOIN departments d ON u.department_id = d.id
LEFT JOIN trades t ON u.trade_id = t.id
LEFT JOIN levels l ON u.level_id = l.id
WHERE u.role = 'student';

-- View for Notes with full details
CREATE OR REPLACE VIEW v_notes AS
SELECT 
    n.id, n.title, n.description, n.file_name, n.file_path, 
    n.file_type, n.file_size, n.download_count, n.created_at,
    s.name AS subject_name,
    t.name AS teacher_name,
    t.email AS teacher_email,
    d.name AS department,
    tr.name AS trade,
    l.name AS level
FROM notes n
JOIN subjects s ON n.subject_id = s.id
JOIN users t ON n.teacher_id = t.id
JOIN trades tr ON s.trade_id = tr.id
JOIN levels l ON s.level_id = l.id
JOIN departments d ON tr.department_id = d.id;

-- View for Subjects with teacher and trade/level info
CREATE OR REPLACE VIEW v_subjects AS
SELECT 
    s.id, s.name, s.description,
    u.name AS teacher_name,
    u.email AS teacher_email,
    d.name AS department,
    t.name AS trade,
    l.name AS level
FROM subjects s
JOIN users u ON s.teacher_id = u.id
JOIN trades t ON s.trade_id = t.id
JOIN levels l ON s.level_id = l.id
JOIN departments d ON t.department_id = d.id;

-- =====================================================
-- STORED PROCEDURES
-- =====================================================

-- Procedure to get notes by student filters
DELIMITER $$
CREATE PROCEDURE sp_get_notes_by_student(
    IN p_department_id INT,
    IN p_trade_id INT,
    IN p_level_id INT
)
BEGIN
    SELECT * FROM v_notes 
    WHERE department_id = p_department_id 
    AND trade_id = p_trade_id 
    AND level_id = p_level_id
    AND is_published = TRUE
    ORDER BY created_at DESC;
END $$
DELIMITER ;

-- Procedure to get teacher's subjects
DELIMITER $$
CREATE PROCEDURE sp_get_teacher_subjects(
    IN p_teacher_id INT
)
BEGIN
    SELECT * FROM v_subjects 
    WHERE teacher_id = p_teacher_id
    ORDER BY department, trade, level;
END $$
DELIMITER ;

-- Procedure to register new student
DELIMITER $$
CREATE PROCEDURE sp_register_student(
    IN p_name VARCHAR(100),
    IN p_email VARCHAR(100),
    IN p_password VARCHAR(255),
    IN p_phone VARCHAR(20),
    IN p_department_id INT,
    IN p_trade_id INT,
    IN p_level_id INT
)
BEGIN
    INSERT INTO users (name, email, password, phone, role, department_id, trade_id, level_id, is_approved)
    VALUES (p_name, p_email, p_password, p_phone, 'student', p_department_id, p_trade_id, p_level_id, FALSE);
    SELECT LAST_INSERT_ID() AS user_id;
END $$
DELIMITER ;

-- Procedure to register new teacher
DELIMITER $$
CREATE PROCEDURE sp_register_teacher(
    IN p_name VARCHAR(100),
    IN p_email VARCHAR(100),
    IN p_password VARCHAR(255),
    IN p_phone VARCHAR(20),
    IN p_department_id INT,
    IN p_trade_id INT,
    IN p_level_id INT
)
BEGIN
    INSERT INTO users (name, email, password, phone, role, department_id, trade_id, level_id, is_approved)
    VALUES (p_name, p_email, p_password, p_phone, 'teacher', p_department_id, p_trade_id, p_level_id, TRUE);
    SELECT LAST_INSERT_ID() AS user_id;
END $$
DELIMITER ;

-- Procedure to upload note
DELIMITER $$
CREATE PROCEDURE sp_upload_note(
    IN p_title VARCHAR(200),
    IN p_description TEXT,
    IN p_file_name VARCHAR(255),
    IN p_file_path VARCHAR(500),
    IN p_file_type VARCHAR(50),
    IN p_file_size INT,
    IN p_subject_id INT,
    IN p_teacher_id INT
)
BEGIN
    INSERT INTO notes (title, description, file_name, file_path, file_type, file_size, subject_id, teacher_id)
    VALUES (p_title, p_description, p_file_name, p_file_path, p_file_type, p_file_size, p_subject_id, p_teacher_id);
    SELECT LAST_INSERT_ID() AS note_id;
END $$
DELIMITER ;

-- Procedure to approve student
DELIMITER $$
CREATE PROCEDURE sp_approve_student(
    IN p_user_id INT
)
BEGIN
    UPDATE users SET is_approved = TRUE WHERE id = p_user_id AND role = 'student';
END $$
DELIMITER ;

-- =====================================================
-- RELATIONSHIP SUMMARY
-- =====================================================

/*
DATABASE RELATIONSHIPS:

1. departments (1) ----< (N) trades
   - One department can have multiple trades
   
2. trades (1) ----< (N) levels
   - One trade can have multiple levels

3. departments (1) ----< (N) users
   - One department can have multiple users (teachers/students)

4. trades (1) ----< (N) users
   - One trade can have multiple users

5. levels (1) ----< (N) users
   - One level can have multiple users

6. users (1) ----< (N) subjects
   - One teacher can have multiple subjects assigned

7. trades (1) ----< (N) subjects
   - One trade can have multiple subjects

8. levels (1) ----< (N) subjects
   - One level can have multiple subjects

9. subjects (1) ----< (N) notes
   - One subject can have multiple notes

10. users (1) ----< (N) notes
    - One teacher can upload multiple notes

ER DIAGRAM SUMMARY:
====================
departments
    |
    └── trades
            |
            └── levels
            |
            ├── users (teacher/student)
            |       |
            |       └── subjects ─── notes
            |
            └── (also direct to subjects)
*/
