DROP DATABASE IF EXISTS telehealth_access_db;

CREATE DATABASE telehealth_access_db;

USE telehealth_access_db;

CREATE TABLE roles (
    role_id INT AUTO_INCREMENT PRIMARY KEY,
    role_name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT
);

CREATE TABLE permissions (
    permission_id INT AUTO_INCREMENT PRIMARY KEY,
    permission_name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT
);

CREATE TABLE role_permissions (
    role_permission_id INT AUTO_INCREMENT PRIMARY KEY,
    role_id INT NOT NULL,
    permission_id INT NOT NULL,
    FOREIGN KEY (role_id) REFERENCES roles(role_id),
    FOREIGN KEY (permission_id) REFERENCES permissions(permission_id)
);

CREATE TABLE languages (
    language_id INT AUTO_INCREMENT PRIMARY KEY,
    language_name VARCHAR(100) NOT NULL,
    language_code VARCHAR(10) NOT NULL UNIQUE,
    is_active BOOLEAN DEFAULT TRUE
);

CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    phone_number VARCHAR(30),
    role_id INT NOT NULL,
    preferred_language_id INT,
    account_status ENUM('Active', 'Inactive', 'Suspended', 'Pending') DEFAULT 'Pending',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (role_id) REFERENCES roles(role_id),
    FOREIGN KEY (preferred_language_id) REFERENCES languages(language_id)
);

CREATE TABLE patients (
    patient_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL UNIQUE,
    first_name VARCHAR(150),
    last_name VARCHAR(150),
    date_of_birth DATE,
    gender ENUM('Male', 'Female', 'Other', 'Prefer_Not_To_Say'),
    address TEXT,
    emergency_contact_name VARCHAR(150),
    emergency_contact_phone VARCHAR(30),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE doctors (
    doctor_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL UNIQUE,
    first_name VARCHAR(150),
    last_name VARCHAR(150),
    professional_license_no VARCHAR(100) NOT NULL UNIQUE,
    speciality VARCHAR(150),
    qualification VARCHAR(150),
    years_of_experience INT,
    consultation_fee DECIMAL(10,2),
    availability_status ENUM('Available', 'Unavailable', 'Busy') DEFAULT 'Available',
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE doctor_availability (
    availability_id INT AUTO_INCREMENT PRIMARY KEY,
    doctor_id INT NOT NULL,
    available_date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    is_booked BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id)
);

CREATE TABLE appointments (
    appointment_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    availability_id INT,
    appointment_date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    appointment_status ENUM('Booked', 'Rescheduled', 'Cancelled', 'Completed', 'No_Show') DEFAULT 'Booked',
    reason_for_visit TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id),
    FOREIGN KEY (availability_id) REFERENCES doctor_availability(availability_id)
);

CREATE TABLE appointment_status_history (
    history_id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT NOT NULL,
    old_status VARCHAR(50),
    new_status VARCHAR(50) NOT NULL,
    changed_by_user_id INT,
    changed_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    reason TEXT,
    FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id),
    FOREIGN KEY (changed_by_user_id) REFERENCES users(user_id)
);

CREATE TABLE consultations (
    consultation_id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT NOT NULL,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    consultation_mode ENUM('Video', 'Audio', 'Chat', 'Low_Bandwidth') DEFAULT 'Video',
    session_status ENUM('Scheduled', 'In_Progress', 'Completed', 'Cancelled', 'Failed') DEFAULT 'Scheduled',
    video_provider VARCHAR(100),
    session_link VARCHAR(255),
    started_at DATETIME,
    ended_at DATETIME,
    FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id),
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id)
);

CREATE TABLE consultation_messages (
    message_id INT AUTO_INCREMENT PRIMARY KEY,
    consultation_id INT NOT NULL,
    sender_user_id INT NOT NULL,
    message_text TEXT NOT NULL,
    sent_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (consultation_id) REFERENCES consultations(consultation_id),
    FOREIGN KEY (sender_user_id) REFERENCES users(user_id)
);

CREATE TABLE low_bandwidth_logs (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    consultation_id INT NOT NULL,
    user_id INT NOT NULL,
    network_status ENUM('Stable', 'Unstable', 'Poor', 'Disconnected') NOT NULL,
    action_taken VARCHAR(150),
    logged_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (consultation_id) REFERENCES consultations(consultation_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE medical_records (
    record_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    consultation_id INT,
    diagnosis TEXT NOT NULL,
    symptoms TEXT,
    treatment_plan TEXT,
    doctor_notes TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id),
    FOREIGN KEY (consultation_id) REFERENCES consultations(consultation_id)
);

CREATE TABLE medical_documents (
    document_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    uploaded_by_user_id INT NOT NULL,
    document_name VARCHAR(150) NOT NULL,
    document_type VARCHAR(50),
    file_path VARCHAR(255) NOT NULL,
    uploaded_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (uploaded_by_user_id) REFERENCES users(user_id)
);

CREATE TABLE metric_types (
    metric_type_id INT AUTO_INCREMENT PRIMARY KEY,
    metric_name VARCHAR(100) NOT NULL UNIQUE,
    unit VARCHAR(50),
    normal_range VARCHAR(100)
);

CREATE TABLE patient_metrics (
    metric_id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT,
    metric_type_id INT NOT NULL,
    metric_value DECIMAL(10,2) NOT NULL,
    recorded_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    notes TEXT,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id),
    FOREIGN KEY (metric_type_id) REFERENCES metric_types(metric_type_id)
);

CREATE TABLE notifications (
    notification_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    notification_type VARCHAR(100),
    title VARCHAR(150) NOT NULL,
    message TEXT NOT NULL,
    delivery_channel ENUM('Email', 'SMS', 'In_App', 'WhatsApp') DEFAULT 'In_App',
    status ENUM('Pending', 'Sent', 'Failed', 'Read') DEFAULT 'Pending',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    sent_at DATETIME,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE analytics_events (
    event_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    event_type VARCHAR(100) NOT NULL,
    event_description TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE dashboard_metrics (
    dashboard_metric_id INT AUTO_INCREMENT PRIMARY KEY,
    metric_name VARCHAR(150) NOT NULL,
    metric_value DECIMAL(15,2) NOT NULL,
    calculated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE audit_logs (
    audit_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    action_performed VARCHAR(150) NOT NULL,
    table_affected VARCHAR(100),
    record_id INT,
    ip_address VARCHAR(50),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE login_attempts (
    login_attempt_id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(150) NOT NULL,
    status ENUM('Success', 'Failed', 'Locked') NOT NULL,
    ip_address VARCHAR(50),
    attempted_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE system_integrations (
    integration_id INT AUTO_INCREMENT PRIMARY KEY,
    integration_name VARCHAR(150) NOT NULL,
    provider_name VARCHAR(150),
    integration_type VARCHAR(100),
    api_status ENUM('Active', 'Inactive', 'Failed', 'Pending') DEFAULT 'Pending',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE training_materials (
    training_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(150) NOT NULL,
    description TEXT,
    material_type ENUM('Video', 'PDF', 'Guide', 'FAQ') NOT NULL,
    file_url VARCHAR(255),
    target_role_id INT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (target_role_id) REFERENCES roles(role_id)
);

CREATE TABLE support_tickets (
    ticket_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    subject VARCHAR(150) NOT NULL,
    description TEXT NOT NULL,
    ticket_status ENUM('Open', 'In_Progress', 'Resolved', 'Closed') DEFAULT 'Open',
    priority ENUM('Low', 'Medium', 'High', 'Urgent') DEFAULT 'Medium',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    resolved_at DATETIME,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE system_error_logs (
    error_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    error_message TEXT NOT NULL,
    error_location VARCHAR(150),
    severity ENUM('Low', 'Medium', 'High', 'Critical') DEFAULT 'Medium',
    occurred_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE system_health_logs (
    health_log_id INT AUTO_INCREMENT PRIMARY KEY,
    server_status ENUM('Healthy', 'Warning', 'Down') DEFAULT 'Healthy',
    database_status ENUM('Healthy', 'Warning', 'Down') DEFAULT 'Healthy',
    response_time_ms INT,
    checked_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE backup_logs (
    backup_id INT AUTO_INCREMENT PRIMARY KEY,
    backup_type ENUM('Full', 'Incremental', 'Manual') NOT NULL,
    backup_status ENUM('Successful', 'Failed', 'In_Progress') DEFAULT 'In_Progress',
    backup_location VARCHAR(255),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO roles (role_name, description)
VALUES
('Patient', 'User who books appointments and receives consultations'),
('Doctor', 'Healthcare professional who provides consultations'),
('Admin', 'System administrator who manages the platform'),
('Stakeholder', 'User who views reports and dashboards'),
('Support Staff', 'User who handles training and support requests');

INSERT INTO languages (language_name, language_code, is_active)
VALUES
('English', 'en', TRUE),
('French', 'fr', TRUE),
('Hindi', 'hi', TRUE),
('Yoruba', 'yo', TRUE),
('Igbo', 'ig', TRUE),
('Hausa', 'ha', TRUE);

INSERT INTO metric_types (metric_name, unit, normal_range)
VALUES
('Blood Pressure', 'mmHg', '90/60 - 120/80'),
('Temperature', 'Celsius', '36.1 - 37.2'),
('Heart Rate', 'bpm', '60 - 100'),
('Blood Sugar', 'mmol/L', '4.0 - 7.8'),
('Weight', 'kg', 'Depends on patient'),
('Oxygen Saturation', '%', '95 - 100');

INSERT INTO permissions (permission_name, description)
VALUES
('REGISTER_USER', 'Allows user registration'),
('LOGIN_USER', 'Allows user login'),
('BOOK_APPOINTMENT', 'Allows patients to book appointments'),
('MANAGE_APPOINTMENT', 'Allows doctors or admins to manage appointments'),
('START_CONSULTATION', 'Allows users to start consultation sessions'),
('UPDATE_MEDICAL_RECORD', 'Allows doctors to update patient medical records'),
('VIEW_DASHBOARD', 'Allows authorised users to view dashboards'),
('MANAGE_USERS', 'Allows admins to manage users'),
('VIEW_AUDIT_LOGS', 'Allows admins to view audit logs');

INSERT INTO users 
(first_name, last_name, email, password_hash, phone_number, role_id, preferred_language_id, account_status)
VALUES
('Amina', 'Okafor', 'amina@email.com', 'hashed_pw', '+2348011111111', 1, 1, 'Active'),
('John', 'Mensah', 'john@email.com', 'hashed_pw', '+233201111111', 1, 1, 'Active'),
('Fatima', 'Yusuf', 'fatima@email.com', 'hashed_pw', '+2348022222222', 1, 6, 'Active'),
('David', 'Kimani', 'david@email.com', 'hashed_pw', '+254701111111', 1, 1, 'Active'),
('Grace', 'Santos', 'grace@email.com', 'hashed_pw', '+639171111111', 1, 1, 'Active'),

('Samuel', 'Adewale', 'adewale@hospital.com', 'hashed_pw', '+2348033333333', 2, 1, 'Active'),
('Esther', 'Njeri', 'njeri@hospital.com', 'hashed_pw', '+254702222222', 2, 1, 'Active'),
('Carlos', 'Ramirez', 'ramirez@hospital.com', 'hashed_pw', '+639172222222', 2, 1, 'Active');

INSERT INTO patients 
(user_id, first_name, last_name, date_of_birth, gender, address, emergency_contact_name, emergency_contact_phone)
VALUES
(1, 'Amina', 'Okafor', '1995-04-12', 'Female', 'Abuja, Nigeria', 'Chinedu Okafor', '+2348011111111'),
(2, 'John', 'Mensah', '1988-09-20', 'Male', 'Accra, Ghana', 'Linda Mensah', '+233201111111'),
(3, 'Fatima', 'Yusuf', '1992-01-15', 'Female', 'Kano, Nigeria', 'Ali Yusuf', '+2348022222222'),
(4, 'David', 'Kimani', '1985-07-08', 'Male', 'Nairobi, Kenya', 'Mary Kimani', '+254701111111'),
(5, 'Grace', 'Santos', '1998-03-25', 'Female', 'Manila, Philippines', 'Jose Santos', '+639171111111');

INSERT INTO doctors 
(user_id, first_name, last_name, professional_license_no, speciality, qualification, years_of_experience, consultation_fee, availability_status)
VALUES
(6, 'Samuel', 'Adewale', 'LIC-NG-1001', 'General Medicine', 'MBBS', 10, 50.00, 'Available'),
(7, 'Esther', 'Njeri', 'LIC-KE-2002', 'Cardiology', 'MBChB', 8, 80.00, 'Available'),
(8, 'Carlos', 'Ramirez', 'LIC-PH-3003', 'Dermatology', 'MD', 12, 70.00, 'Available');

INSERT INTO doctor_availability 
(doctor_id, available_date, start_time, end_time, is_booked)
VALUES
(1, '2026-05-15', '09:00:00', '09:30:00', TRUE),
(2, '2026-05-15', '10:00:00', '10:45:00', TRUE),
(1, '2026-05-16', '11:00:00', '11:30:00', TRUE),
(2, '2026-05-16', '14:00:00', '14:45:00', TRUE),
(3, '2026-05-17', '16:00:00', '16:30:00', TRUE);

INSERT INTO appointments 
(patient_id, doctor_id, availability_id, appointment_date, start_time, end_time, appointment_status, reason_for_visit)
VALUES
(1, 1, 1, '2026-05-15', '09:00:00', '09:30:00', 'Rescheduled', 'Patient experiencing fever, headache and weakness for 3 days.'),
(2, 2, 2, '2026-05-15', '10:00:00', '10:45:00', 'Booked', 'Patient reports chest discomfort and irregular heartbeat.'),
(3, 1, 3, '2026-05-16', '11:00:00', '11:30:00', 'Cancelled', 'Follow-up consultation after malaria treatment.'),
(4, 2, 4, '2026-05-16', '14:00:00', '14:45:00', 'Booked', 'Routine blood pressure monitoring and medication review.'),
(5, 3, 5, '2026-05-17', '16:00:00', '16:30:00', 'Booked', 'Patient complains of skin rash and allergic reaction.');