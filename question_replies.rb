class Replies

  def self.find_by_id(id)
    query = <<-SQL
      SELECT *
      FROM replies
      WHERE id = ?
    SQL

    result = QuestionsDatabase.instance.execute(query, id)
    Replies.new(result[0])
  end

  attr_reader :id, :question_id

  def initialize(data)
    @question_id, @id = data["question_id"], data["id"]
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

end

