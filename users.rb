require 'singleton'
require 'sqlite3'
load './questions.rb'
load 'question.rb'
load 'question_replies.rb'
load 'question_followers.rb'

class User

  attr_accessor :fname, :lname, :is_instructor
  def self.find_user(fname, lname)
    query = <<-SQL
      SELECT *
      FROM users
      WHERE fname = ? AND lname = ?
    SQL
    result = QuestionsDatabase.instance.execute(query, fname, lname)
    User.new(result[0])
  end

  def initialize(data)
    @user_id, @fname, @lname, @is_instructor = data["id"], data["fname"], data["lname"], data["is_instructor"]
  end

  def ask_question(title, body)
    Question.ask_question(title, body, @user_id, "#{@fname} #{@lname}")
  end

  def post_reply(title, body, id)
    q = Question.find_by_id(id)
    q.post_reply(title, body, "#{@fname} #{@lname}")
  end

  def like_question(title)
    question_id = Question.find_question(title).id
    QuestionLikes.like_question(question_id, @user_id)
  end

  def save

    if @user_id.nil?

      query = <<-SQL
        INSERT
        INTO users ('fname', 'lname', 'is_instructor')
        VALUES (?, ?, ?)
      SQL

      user = Users.instance.execute(query, @fname, @lname, @is_instructor)
      @user_id = user[0]["id"]

    else

      query = <<-SQL
        UPDATE users
        SET fname=?, lname=?, is_instructor=?
        WHERE id = ?
      SQL

      QuestionsDatabase.instance.execute(query, @fname, @lname, @is_instructor, @user_id)
    end

  end

  def asked_questions
    query = <<-SQL
      SELECT title
      FROM questions
      WHERE author = ?
    SQL

    all = QuestionsDatabase.instance.execute(query, "#{@fname} #{@lname}")
    all[0]
  end

  def avg_karma
    query = <<-SQL
      SELECT AVG(count) avgkarma from
        (SELECT q.title, COUNT(*) count
        FROM questions q JOIN question_likes ql on ql.question_id = q.id
        JOIN users u ON u.id = ql.user_id
        WHERE q.author_id = ?
        GROUP BY q.id)
    SQL

    QuestionsDatabase.instance.execute(query, @user_id)
  end

  def questions
    query = <<-SQL
      SELECT title from questions
      where author_id = ?
    SQL
    QuestionsDatabase.instance.execute(query, @user_id)
  end

  def replies
    query = <<-SQL
      SELECT title from replies
      where author_id = ?
    SQL
    QuestionsDatabase.instance.execute(query, @user_id)
  end

  def most_karma
    query = <<-SQL
      SELECT Max(count)
      FROM
        (SELECT COUNT(*) count
        FROM questions q JOIN users u ON q.author_id = u.id
        JOIN question_likes ql ON ql.question_id = q.id
        WHERE q.author_id = ?
        GROUP BY q.id)
    SQL

    QuestionsDatabase.instance.execute(query, @user_id)
  end

end
# def add_users(author, is_instructor)
#
#   query = <<-SQL
#     INSERT
#     INTO users ('author', 'is_instructor')
#     VALUES (?, ?)
#   SQL
#
#   Users.instance.execute(query, author, is_instructor)
# end