class Cbase::Companies
  attr_reader :permalinks

  CREATE_TABLE = "CREATE TABLE IF NOT EXISTS companies (
        id INTEGER PRIMARY KEY, 
        name TEXT NOT NULL UNIQUE,
        url TEXT, phone TEXT, address TEXT,
        email TEXT, mgmt_team TEXT,
        person0 TEXT, job0 TEXT,
        person1 TEXT, job1 TEXT,
        person2 TEXT, job2 TEXT);"

  CREATE_INDEX = "CREATE UNIQUE INDEX name_index 
        on companies (name);"

  INSERT_SQL = "INSERT INTO companies ( 
    name, url, phone, address, email, mgmt_team, 
    person0, job0, person1, job1, person2, job2 ) VALUES 
    ( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ? )"

  def initialize(permalinks)
    @permalinks = permalinks
  end

  def add_companies_for(city, dbase)
    permalinks.each do |permalink|
      comp_hash = company_hash(permalink, city)
      company = company_object(comp_hash)
      if company.in_city?
        company.to_csv
        dbase.insert(INSERT_SQL, company.attributes)
      end
    end
  end

  private

  def company_hash(permalink, city)
    comp_hash = Cbase::Client.new(permalink).company_hash
    comp_hash["filter_city"] = city
    comp_hash
  end

  def company_object(comp_hash)
    Cbase::Company.new(comp_hash)
  end  
end