require 'spec_helper'

describe Cbase::Dbase do
  let(:create_table_sql) {Cbase::Companies::CREATE_TABLE}
  let(:create_index_sql) {Cbase::Companies::CREATE_INDEX}
  let(:insert_sql) {Cbase::Companies::INSERT_SQL}
  let(:get_table_name_sql) {"SELECT name FROM sqlite_master WHERE type='table' AND name='companies';"}
  let(:get_last_row_sql) {"SELECT * FROM companies WHERE ID = (SELECT MAX(ID) FROM companies);"}
  let(:attributes) {["Facebook","=HYPERLINK(\"http://www.facebook.com\")","","340 Madison Ave  New York","","=HYPERLINK(\"https://www.google.com/search?q='management+team'+facebook\")","Mark Zuckerberg","Founder and CEO, Board Of Directors","David Ebersman","CFO","Sheryl Sandberg","COO"]}
  
  describe ".setup" do
    it "creates a DB and table" do
      Cbase::Dbase.delete_db if Cbase::Dbase.exists?
      dbase = Cbase::Dbase.setup(create_table_sql, create_index_sql)
      expect(dbase.execute(get_table_name_sql).flatten).to eq(["companies"])
    end
  end

  describe "#insert" do
    it "inserts 1 row into DB" do
      Cbase::Dbase.delete_db if Cbase::Dbase.exists?
      dbase = Cbase::Dbase.setup(create_table_sql, create_index_sql)
      dbase.insert(insert_sql, attributes)
      expect(dbase.execute(get_last_row_sql).flatten).to eq(attributes.unshift(1))
    end
  end

  describe "#execute" do
    it "executes SQL code" do
      Cbase::Dbase.delete_db if Cbase::Dbase.exists?
      dbase = Cbase::Dbase.setup(create_table_sql, create_index_sql)
      expect(dbase.execute(get_table_name_sql).flatten).to eq(["companies"])
    end
  end

  describe ".exists?" do
    it "checks if the DB file exists" do
      expect(Cbase::Dbase.exists?).to eq(true)
    end
  end

  describe ".delete_db" do
    it "check if can delete DB file" do
      Cbase::Dbase.delete_db
      expect(Cbase::Dbase.exists?).to eq(false)
    end
  end
end