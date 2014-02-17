class Cbase::Dbase

  DBNAME = "data/companies.db"

  def setup(create_table_sql)
    db = SQLite3::Database.new(DBNAME) 
    db.execute(create_table_sql) 
    return db, self
  end

  def insert(db, insert_sql, attributes)
    db.execute(insert_sql, attributes)
  end

  def self.exists?
    File.exist?(DBNAME)
  end
end