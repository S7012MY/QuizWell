--
-- Created by SQL::Translator::Producer::PostgreSQL
-- Created on Tue Jun 18 12:18:41 2024
--
--
-- Table: questions
--
DROP TABLE questions CASCADE;
CREATE TABLE questions (
  id serial NOT NULL,
  md text NOT NULL,
  created_at timestamp DEFAULT current_timestamp NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT questions_md UNIQUE (md)
);

--
-- Table: tags
--
DROP TABLE tags CASCADE;
CREATE TABLE tags (
  id serial NOT NULL,
  name text NOT NULL,
  color text NOT NULL,
  created_at timestamp DEFAULT current_timestamp NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT tags_name UNIQUE (name)
);

--
-- Table: question_answers
--
DROP TABLE question_answers CASCADE;
CREATE TABLE question_answers (
  id serial NOT NULL,
  question_id integer NOT NULL,
  md text NOT NULL,
  is_correct boolean NOT NULL,
  created_at timestamp DEFAULT current_timestamp NOT NULL,
  PRIMARY KEY (id)
);
CREATE INDEX question_answers_idx_question_id on question_answers (question_id);

--
-- Table: quizzes
--
DROP TABLE quizzes CASCADE;
CREATE TABLE quizzes (
  id serial NOT NULL,
  uuid text NOT NULL,
  current_question integer,
  created_at timestamp DEFAULT current_timestamp NOT NULL,
  prompt text,
  start_time timestamp,
  end_time timestamp,
  PRIMARY KEY (id),
  CONSTRAINT quizzes_uuid UNIQUE (uuid)
);
CREATE INDEX quizzes_idx_current_question on quizzes (current_question);

--
-- Table: question_tags
--
DROP TABLE question_tags CASCADE;
CREATE TABLE question_tags (
  id serial NOT NULL,
  question_id integer NOT NULL,
  tag_id integer NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT question_tags_question_id_tag_id UNIQUE (question_id, tag_id)
);
CREATE INDEX question_tags_idx_question_id on question_tags (question_id);
CREATE INDEX question_tags_idx_tag_id on question_tags (tag_id);

--
-- Table: quiz_questions
--
DROP TABLE quiz_questions CASCADE;
CREATE TABLE quiz_questions (
  id serial NOT NULL,
  quiz_id integer NOT NULL,
  question_id integer NOT NULL,
  position integer NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT quiz_questions_quiz_id_question_id UNIQUE (quiz_id, question_id)
);
CREATE INDEX quiz_questions_idx_question_id on quiz_questions (question_id);
CREATE INDEX quiz_questions_idx_quiz_id on quiz_questions (quiz_id);

--
-- Table: quiz_answers
--
DROP TABLE quiz_answers CASCADE;
CREATE TABLE quiz_answers (
  id serial NOT NULL,
  quiz_id integer NOT NULL,
  question_id integer NOT NULL,
  answer_id integer NOT NULL,
  created_at timestamp DEFAULT current_timestamp NOT NULL,
  PRIMARY KEY (id)
);
CREATE INDEX quiz_answers_idx_answer_id on quiz_answers (answer_id);
CREATE INDEX quiz_answers_idx_question_id on quiz_answers (question_id);
CREATE INDEX quiz_answers_idx_quiz_id on quiz_answers (quiz_id);

--
-- Foreign Key Definitions
--

ALTER TABLE question_answers ADD CONSTRAINT question_answers_fk_question_id FOREIGN KEY (question_id)
  REFERENCES questions (id) ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

ALTER TABLE quizzes ADD CONSTRAINT quizzes_fk_current_question FOREIGN KEY (current_question)
  REFERENCES questions (id) DEFERRABLE;

ALTER TABLE question_tags ADD CONSTRAINT question_tags_fk_question_id FOREIGN KEY (question_id)
  REFERENCES questions (id) ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

ALTER TABLE question_tags ADD CONSTRAINT question_tags_fk_tag_id FOREIGN KEY (tag_id)
  REFERENCES tags (id) ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

ALTER TABLE quiz_questions ADD CONSTRAINT quiz_questions_fk_question_id FOREIGN KEY (question_id)
  REFERENCES questions (id) ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

ALTER TABLE quiz_questions ADD CONSTRAINT quiz_questions_fk_quiz_id FOREIGN KEY (quiz_id)
  REFERENCES quizzes (id) ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

ALTER TABLE quiz_answers ADD CONSTRAINT quiz_answers_fk_answer_id FOREIGN KEY (answer_id)
  REFERENCES question_answers (id) ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

ALTER TABLE quiz_answers ADD CONSTRAINT quiz_answers_fk_question_id FOREIGN KEY (question_id)
  REFERENCES questions (id) ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

ALTER TABLE quiz_answers ADD CONSTRAINT quiz_answers_fk_quiz_id FOREIGN KEY (quiz_id)
  REFERENCES quizzes (id) ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

