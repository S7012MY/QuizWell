-- Convert schema 'sql/QuizWell-Schema-2-PostgreSQL.sql' to 'sql/QuizWell-Schema-3-PostgreSQL.sql':;

BEGIN;

ALTER TABLE quizzes ADD COLUMN prompt text;


COMMIT;

