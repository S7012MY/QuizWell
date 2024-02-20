-- Convert schema 'sql/QuizWell-Schema-1-PostgreSQL.sql' to 'sql/QuizWell-Schema-2-PostgreSQL.sql':;

BEGIN;

ALTER TABLE question_answers DROP CONSTRAINT question_answers_fk_answer_id;

DROP INDEX question_answers_idx_answer_id;

ALTER TABLE question_answers DROP COLUMN answer_id;

ALTER TABLE quiz_answers DROP CONSTRAINT quiz_answers_fk_answer_id;

ALTER TABLE quiz_answers ADD CONSTRAINT quiz_answers_fk_answer_id FOREIGN KEY (answer_id)
  REFERENCES question_answers (id) ON DELETE cascade ON UPDATE cascade DEFERRABLE;


COMMIT;

