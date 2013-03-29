class Model

  def self.table_name
    raise NotImplementedError
  end

  def self.find(id)

   result = QuestionsDatabase.instance.execute("SELECT * FROM #{self.table_name} WHERE id = #{id}")

   self.new(result[0])
  end

end