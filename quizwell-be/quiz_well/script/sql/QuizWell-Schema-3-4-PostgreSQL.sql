-- Convert schema 'sql/QuizWell-Schema-3-PostgreSQL.sql' to 'sql/QuizWell-Schema-4-PostgreSQL.sql':;

BEGIN;

ALTER TABLE quizzes ADD COLUMN quiz_start_time timestamp;

ALTER TABLE quizzes ADD COLUMN quiz_end_time timestamp;


COMMIT;

