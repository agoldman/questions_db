class Replies
  attr_reader :id, :question_id
  def initialize(db)
    db = db[0]
    @question_id, @id = db["question_id"], db["id"]
  end

  def post_reply(question_id, title, body, author, id)
    query = <<-SQL
      INSERT
      INTO replies
      ('title', 'body', 'author', 'question_id', 'id')
      VALUES (?, ?, ?, ?)
    SQL
    QuestionsDatabase.instance.execute(query, title, body, author, question_id, id)
  end

  def replies
    query = <<-SQL
      SELECT title
      FROM replies
      WHERE parent_id = ?
    SQL

    QuestionsDatabase.instance.execute(query, @id)
  end

  def self.most_replies
    query = <<-SQL
      SELECT a.title, COUNT(*) count
      FROM replies a JOIN replies b ON a.id = b.parent_id
      GROUP BY a.id
      ORDER BY count DESC
      LIMIT 1
    SQL

    QuestionsDatabase.instance.execute(query)
  end

  def self.post_reply(question_id, title, body, author)
    query = <<-SQL
      INSERT
      INTO replies
      ('title', 'body', 'author', 'question_id')
      VALUES (?, ?, ?, ?)
    SQL
    QuestionsDatabase.instance.execute(query, title, body, author, question_id)
  end

  def self.find_by_id(id)
    query = <<-SQL
      SELECT *
      FROM replies
      WHERE id = ?
    SQL

    result = QuestionsDatabase.instance.execute(query, id)
    Replies.new(result)

  end

end

