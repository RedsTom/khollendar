-- Création des séquences
CREATE SEQUENCE IF NOT EXISTS user_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE IF NOT EXISTS kholle_session_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE IF NOT EXISTS kholle_slot_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE IF NOT EXISTS user_preference_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE IF NOT EXISTS kholle_assignment_seq START WITH 1 INCREMENT BY 1;

-- Table des utilisateurs
CREATE TABLE users (
    id BIGINT PRIMARY KEY,
    username VARCHAR(255) NOT NULL UNIQUE,
    secret_code VARCHAR(255),
    code_initialized BOOLEAN NOT NULL DEFAULT FALSE
);

-- Table des sessions de khôlles
CREATE TABLE kholle_sessions (
    id BIGINT PRIMARY KEY,
    subject VARCHAR(255) NOT NULL,
    status VARCHAR(50) NOT NULL DEFAULT 'REGISTRATIONS_OPEN'
);

-- Table des créneaux de khôlles
CREATE TABLE kholle_slot (
    id BIGINT PRIMARY KEY,
    date_time TIMESTAMP,
    session_id BIGINT NOT NULL,
    CONSTRAINT fk_kholle_slot_session FOREIGN KEY (session_id) REFERENCES kholle_sessions(id) ON DELETE CASCADE
);

-- Table des préférences utilisateur
CREATE TABLE user_preferences (
    id BIGINT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    session_id BIGINT NOT NULL,
    slot_id BIGINT NOT NULL,
    preference_rank INTEGER NOT NULL,
    is_unavailable BOOLEAN NOT NULL DEFAULT FALSE,
    CONSTRAINT fk_user_preference_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_user_preference_session FOREIGN KEY (session_id) REFERENCES kholle_sessions(id) ON DELETE CASCADE,
    CONSTRAINT fk_user_preference_slot FOREIGN KEY (slot_id) REFERENCES kholle_slot(id) ON DELETE CASCADE
);

-- Table des affectations
CREATE TABLE kholle_assignments (
    id BIGINT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    session_id BIGINT NOT NULL,
    slot_id BIGINT NOT NULL,
    assigned_at TIMESTAMP NOT NULL,
    obtained_preference_rank INTEGER,
    CONSTRAINT fk_kholle_assignment_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_kholle_assignment_session FOREIGN KEY (session_id) REFERENCES kholle_sessions(id) ON DELETE CASCADE,
    CONSTRAINT fk_kholle_assignment_slot FOREIGN KEY (slot_id) REFERENCES kholle_slot(id) ON DELETE CASCADE
);

-- Index pour améliorer les performances
CREATE INDEX idx_kholle_slot_session ON kholle_slot(session_id);
CREATE INDEX idx_kholle_slot_datetime ON kholle_slot(date_time);
CREATE INDEX idx_user_preference_user ON user_preferences(user_id);
CREATE INDEX idx_user_preference_session ON user_preferences(session_id);
CREATE INDEX idx_user_preference_slot ON user_preferences(slot_id);
CREATE INDEX idx_kholle_assignment_user ON kholle_assignments(user_id);
CREATE INDEX idx_kholle_assignment_session ON kholle_assignments(session_id);
CREATE INDEX idx_kholle_assignment_slot ON kholle_assignments(slot_id);
CREATE INDEX idx_kholle_sessions_status ON kholle_sessions(status);

