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

  def add_companies_for(fcity, dbase)
    permalinks.each do |permalink|
      comp_hash = company_hash(permalink)
      company = company_object(comp_hash)
      company_in_city = filtered_company(company, fcity)
      if company_in_city.in_city?
        company_in_city.to_csv
        dbase.insert(INSERT_SQL, company_in_city.attributes)
      end
    end
  end

  private

  def company_hash(permalink)
    Cbase::Client.new(permalink).company_hash
  end

  def company_object(comp_hash)
    Cbase::Company.new(comp_hash)
  end 

  def filtered_company(company, fcity)
    Cbase::CompanyInCity.new(company, fcity)
  end 
end