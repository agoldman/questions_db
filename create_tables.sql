CREATE TABLE users (

  id INTEGER PRIMARY KEY,

  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL,
  is_instructor INTEGER NOT NULL

);

CREATE TABLE questions (

  id INTEGER PRIMARY KEY,

  title VARCHAR(255) NOT NULL,
  body VARCHAR(255) NOT NULL,
  author_id INTEGER,
  FOREIGN KEY(author_id) REFERENCES users(id)
);

CREATE TABLE question_followers (

  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,
  FOREIGN KEY(user_id) REFERENCES users(id)
  FOREIGN KEY(question_id) REFERENCES questions(id)
);

CREATE TABLE replies (

  id INTEGER PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  body TEXT NOT NULL,
  author_id VARCHAR(255) NOT NULL,
  question_id INTEGER NOT NULL,
  parent_id INTEGER,
  FOREIGN KEY (author_id) REFERENCES users(id)
  FOREIGN KEY (parent_id) REFERENCES replies(id)
  FOREIGN KEY(question_id) REFERENCES questions(id)
);

CREATE TABLE question_actions (
  id INTEGER PRIMARY KEY,
  type CHECK(type IN ("redact", "close", "reopen")),
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

INSERT INTO users ('fname', 'lname', 'is_instructor') VALUES ("April", "Goldman", 0);
INSERT INTO users  ('fname', 'lname', 'is_instructor') VALUES ("Anthony", "Woo", 1);
INSERT INTO users  ('fname', 'lname', 'is_instructor') VALUES ("Blixa", "Goldman", 1);
INSERT INTO questions ('title', 'body', 'author_id') VALUES ('First Question', 'Here it is!', 1);
INSERT INTO questions ('title', 'body', 'author_id') VALUES ('2nd Question', 'Another Question', 1);
INSERT INTO question_followers ('user_id', 'question_id') VALUES (1, 1);
INSERt INTO question_followers ('user_id', 'question_id') VALUES (2, 1);
INSERt INTO question_followers ('user_id', 'question_id') VALUES (3, 2);
INSERT INTO question_likes("user_id", "question_id") VALUES(1,1);
INSERT INTO question_likes("user_id", "question_id") VALUES(2,1);
INSERT INTO question_likes("user_id", "question_id") VALUES(2,2);
INSERT INTO replies("title", "body", "author_id", "question_id", "parent_id") VALUES("1st", "body", 2, 1, NULL);
INSERT INTO replies("title", "body", "author_id", "question_id", "parent_id") VALUES("2nd", "2body", 2, 1, NULL);
INSERT INTO replies("title", "body", "author_id", "question_id", "parent_id") VALUES("3rd", "3body", 1, 1, 2);
INSERT INTO replies("title", "body", "author_id", "question_id", "parent_id") VALUES("4rd", "4body", 3, 1, 2);
INSERT INTO replies("title", "body", "author_id", "question_id", "parent_id") VALUES("5st", "5body", 2, 1, NULL);
INSERT INTO replies("title", "body", "author_id", "question_id", "parent_id") VALUES("6rd", "6body", 1, 1, 1);




