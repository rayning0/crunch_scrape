class Cbase::Dbase

  DBNAME = "data/companies.db"

  def initialize(db)
    @db = db
  end

  def self.setup(create_table_sql, create_index_sql)
    db = SQLite3::Database.new(DBNAME) 
    db.execute(create_table_sql)
    db.execute(create_index_sql) 
    new(db)
  end

  def insert(insert_sql, attributes)
    @db.execute(insert_sql, attributes)
  end

  def execute(sql)
    @db.execute(sql)
  end

  def self.exists?
    File.exist?(DBNAME)
  end

  def self.delete_db
    File.delete(DBNAME)
  end
end