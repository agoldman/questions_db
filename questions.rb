require 'singleton'
require 'sqlite3'

class QuestionsDatabase< SQLite3::Database
  include Singleton
  def initialize

    super("questions.db")

    # otherwise each row is returned as an array of values; we want a hash
    # indexed by column name.
    self.results_as_hash = true

    # otherwise all the data is returned as strings and not parsed into the
    # appropriate type.
    self.type_translation = true
  end
end