CREATE DATABASE ONLINEPLATFORM;
\c ONLINEPLATFORM

CREATE TYPE user_role AS ENUM ('student', 'teacher', 'admin');
CREATE TYPE profile_avatar_type AS ENUM ('image', 'video', 'gif');

DROP TABLE users CASCADE;
CREATE TABLE IF NOT EXISTS users (
    ID BIGSERIAL PRIMARY KEY,
    FULLNAME VARCHAR(64) DEFAULT 'student',
    TELEGRAM_USER_ID VARCHAR NOT NULL UNIQUE,
    CONTACT VARCHAR(32) NOT NULL UNIQUE,
    ROLE user_role DEFAULT 'student', 
    SIGNED_TIME TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP 
);

DROP TABLE courses CASCADE;
CREATE TABLE IF NOT EXISTS courses (
    ID BIGSERIAL PRIMARY KEY,
    USER_ID BIGINT NOT NULL REFERENCES users(id),
    GOOGLE_DRIVE_THUMBNAIL_ID VARCHAR(256) NOT NULL,
    TITLE VARCHAR(128) NOT NULL,
    DESCRIPTION VARCHAR,
    PRICE FLOAT
);

DROP TABLE course_themes CASCADE;
CREATE TABLE IF NOT EXISTS course_themes (
    ID BIGSERIAL PRIMARY KEY,
    COURSE_ID BIGINT NOT NULL REFERENCES courses(id),
    TITLE VARCHAR(128) NOT NULL
);

DROP TABLE course_videos CASCADE;
CREATE TABLE IF NOT EXISTS course_videos (
    ID BIGSERIAL PRIMARY KEY,
    GOOGLE_DRIVE_VIDEO_ID VARCHAR,
    THEME_ID BIGINT NOT NULL REFERENCES course_themes(id),
    POSITION INT,
    TITLE VARCHAR(128) NOT NULL,
    DESCRIPTION VARCHAR,
    UPLOADED_AT TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

DROP TABLE otp CASCADE;
CREATE TABLE IF NOT EXISTS otp (
    ID BIGSERIAL PRIMARY KEY,
    telegram_user_id VARCHAR,
    code INT NOT NULL,
    sended_time TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

DROP TABLE user_profile_avatar CASCADE;
CREATE TABLE IF NOT EXISTS user_profile_avatar (
    ID BIGSERIAL PRIMARY KEY,
    USER_ID BIGINT NOT NULL REFERENCES users(ID),
    TYPE profile_avatar_type DEFAULT 'image',
    GOOGLE_DRIVE_PICTURE_ID VARCHAR(256),
    UPLOADED_TIME TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

DROP TABLE users_queue CASCADE;
CREATE TABLE IF NOT EXISTS users_queue (
    ID BIGSERIAL PRIMARY KEY,
    FULLNAME VARCHAR(64),
    TELEGRAM_USER_ID VARCHAR NOT NULL UNIQUE,
    CONTACT VARCHAR(32) NOT NULL UNIQUE,
    ROLE user_role DEFAULT 'student'
);

DROP TABLE faq CASCADE;
CREATE TABLE IF NOT EXISTS faq (
    ID BIGSERIAL PRIMARY KEY,
    question VARCHAR(1024) NOT NULL,
    answer VARCHAR(1024) NOT NULL
);

DROP TABLE user_activities CASCADE;
CREATE TABLE IF NOT EXISTS user_activities (
    ID BIGSERIAL PRIMARY KEY,
    USER_ID BIGINT REFERENCES users(ID),
    IP VARCHAR(64) NOT NULL,
    SOCKET_ID VARCHAR(64) NOT NULL,
    USER_AGENT VARCHAR(1024),
    CONNECTED_TIMESTAMP TIMESTAMPTZ DEFAULT NOW(),
    DISCONNECTED_TIMESTAMP TIMESTAMPTZ
);

INSERT INTO faq (question, answer) VALUES
    ('Kurs bepulmi?', 'Narxlarni har bir kursning sahifasida ko’rishingiz mumkin.'),
    ('Kurs noldan boshlab o''rgatiladimi?', 'Kurslarda o’qish uchun IT va dasturchilik bilim-tajribasi talab qilinmaydi, faqat kompyuter savodxonligi kerak xolos. Har bir kursda dasturchilik asoslari ham o’rgatiladi.'),
    ('Darslar uchun qancha vaqt ajratish kerak?', 'Har bir dars 1 kun mobaynida o’rganish uchun mo’ljallangan.');