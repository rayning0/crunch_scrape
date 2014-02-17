class Cbase::Companies
  attr_reader :permalinks

  CREATE_TABLE_SQL = "CREATE TABLE IF NOT EXISTS companies (
        id INTEGER PRIMARY KEY, 
        name TEXT NOT NULL UNIQUE,
        url TEXT,
        phone TEXT,
        address TEXT,
        email TEXT,
        mgmt_team TEXT,
        person0 TEXT, job0 TEXT,
        person1 TEXT, job1 TEXT,
        person2 TEXT, job2 TEXT);"

  INSERT_SQL = "INSERT INTO companies ( 
    name, url, phone, address, email, mgmt_team, 
    person0, job0, person1, job1, person2, job2 ) VALUES 
    ( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ? )"

  def initialize(permalinks)
    @permalinks = permalinks
  end

  def add_companies_for(city)
    if Cbase::CsvFile.exists? || Cbase::Dbase.exists?
      puts "You already have database or CSV file in /data directory. To overwrite them, delete both first, then restart this program."
      exit
    else 
      setup_csv_file
      db, dbase = setup_db
      permalinks.each do |permalink|
        comp_hash = company_hash(permalink, city)
        company = company_object(comp_hash)
        if company.in_city?
          company.to_csv
          dbase.insert(db, INSERT_SQL, company.attributes)
        end
      end
    end
  end

  def setup_csv_file
    Cbase::CsvFile.new.make_csv_header(Cbase::Company::HEADER)
  end

  def setup_db
    Cbase::Dbase.new.setup(CREATE_TABLE_SQL)
  end

  def company_hash(permalink, city)
    comp_hash = Cbase::Client.new(permalink).company_hash
    comp_hash["city"] = city
    comp_hash
  end

  def company_object(comp_hash)
    Cbase::Company.new(comp_hash)
  end  
end