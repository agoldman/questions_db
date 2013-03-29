class Question

  def self.find_question(title)

    query = <<-SQL
      SELECT *
      FROM questions
      WHERE title LIKE (?)
    SQL
    result = QuestionsDatabase.instance.execute(query, title)
    Question.new(result[0])
  end

  attr_reader :id

  def initialize(data)
    @id, @title, @body, @author_id = data["id"], data["title"], data["body"], data["author_id"]
  end

  def self.most_followed(n)
    query = <<-SQL
      SELECT title, COUNT(*) count
      FROM question_followers JOIN questions ON questions.id = question_followers.question_id
      GROUP BY title
      ORDER BY count DESC
      LIMIT ?
    SQL

    qid_array = []
    result = QuestionsDatabase.instance.execute(query, n)
    result.each { |hash| qid_array << hash["title"] }
    qid_array
  end

  def self.most_liked(n)
    query = <<-SQL
      SELECT title, COUNT(*) count
      FROM question_likes JOIN questions ON questions.id = question_likes.question_id
      GROUP BY title
      ORDER BY count DESC
      LIMIT ?
    SQL

    qid_array = []
    result = QuestionsDatabase.instance.execute(query, n)
    result.each { |hash| qid_array << hash["title"] }
    qid_array
  end

  def who_asked
    @author_id
  end

  def total_replies
    query = <<-SQL
      SELECT COUNT(id)
      FROM question_replies
      WHERE question_id = ?
    SQL

    QuestionsDatabase.instance.execute(query, id)
  end

  def num_likes
    query = <<-SQL
      SELECT COUNT(*)
      FROM question_likes
      WHERE question_id = ?
    SQL

    QuestionsDatabase.instance.execute(query, id)
  end

  def followers
    query = <<-SQL
      SELECT fname, lname
      FROM questions q JOIN question_followers qf ON q.id = qf.question_id
      JOIN users ON users.id = qf.user_id
      WHERE q.id = ?
    SQL

    result = QuestionsDatabase.instance.execute(query, @id)
    qid_array = []
    result.each { |hash| qid_array << "#{hash["fname"]}  #{hash["lname"]}"
    qid_array
  end
end



