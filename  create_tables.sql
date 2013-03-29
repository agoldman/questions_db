CREATE TABLE users (
  -- SQLite3 will automatically populate an integer primary key
  -- (unless it is specifically provided). The conventional primary
  -- key name is 'id'.
  id INTEGER PRIMARY KEY,
  -- NOT NULL specifies that the column must be provided. This is a
  -- useful check of the integrity of the data.
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL,
  is_instructor INTEGER NOT NULL
  #FOREIGN KEY(department_id) REFERENCES departments(id)
);

CREATE TABLE questions (

  id INTEGER PRIMARY KEY,
  -- NOT NULL specifies that the column must be provided. This is a
  -- useful check of the integrity of the data.
  title VARCHAR(255) NOT NULL,
  body VARCHAR(255) NOT NULL, #bigger?
  author VARCHAR(255) NOT NULL
  #FOREIGN KEY(department_id) REFERENCES departments(id)
);

CREATE TABLE question_followers (

  id INTEGER PRIMARY KEY,
  user_id INTEGER,
  question_id INTEGER,
  FOREIGN KEY(user_id) REFERENCES users(id)
  FOREIGN KEY(question_id) REFERENCES questions(id)
);

CREATE TABLE question_replies (

  id INTEGER PRIMARY KEY,
  question_id INTEGER,
  parent_id INTEGER,
  FOREIGN KEY(question_id) REFERENCES questions(id),
  FOREIGN KEY(parent_id) REFERENCES question_replies(id)
);

CREATE TABLE question_actions (

  id INTEGER PRIMARY KEY,
  type CHECK(type IN ("redact", "close", "reopen"))
  question_id INTEGER,
  FOREIGN KEY(question_id) REFERENCES questions(id)
);

CREATE TABLE question_likes (

  id INTEGER PRIMARY KEY,
  user_id INTEGER,
  question_id INTEGER,
  FOREIGN KEY(user_id) REFERENCES users(id)
  FOREIGN KEY(question_id) REFERENCES questions(id)
);