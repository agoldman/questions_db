class QuestionFollowers

  def self.ask_question(question_id, user_id)
    query = <<-SQL
      INSERT
      INTO question_followers
      ('user_id', 'question_id')
      VALUES (?, ?)
    SQL

    QuestionsDatabase.instance.execute(query, user_id, question_id)
  end

end