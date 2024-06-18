-- Convert schema 'sql/QuizWell-Schema-3-PostgreSQL.sql' to 'sql/QuizWell-Schema-4-PostgreSQL.sql':;

BEGIN;

ALTER TABLE quizzes ADD COLUMN start_time timestamp;

ALTER TABLE quizzes ADD COLUMN end_time timestamp;


COMMIT;

