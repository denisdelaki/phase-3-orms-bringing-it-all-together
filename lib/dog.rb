class Dog
#creates the dogs table in the database
def self.create_table 
sql= <<-SQL 
CREATE TABLE IF NOT EXISTS dogs (
    id INTEGER PRIMARY KEY,
    name TEXT,
    breed TEXT
)
SQL
#connect it to the database
DB[:conn].execute(sql)
end
#delete the table 
def self.drop_table
    sql = <<-SQL
    DROP TABLE IF EXISTS dogs
  SQL

  DB[:conn].execute(sql)
end
def self.new_from_db(row)
    self.new(id: row[0], name: row[1], breed: row[2])

end 
def self.find_by_name(name)
sql= <<-SQL
    SELECT *
    FROM dogs
    WHERE name=?
    LIMIT 1
SQL

end
#all
def self.all
sql= <<-SQL
SELECT *
FROM dogs
SQL
DB[:conn].execute(sql).map do |row|
    self.new_from_db(row)
end.first
end
end 
##given an instance of a dog, simply calling save will insert a new record into the database and return the instance.
def save
sql =<<-SQL 

INSERT INTO dogs (name, breed)
VALUES (?,?)
SQL
#insert the database with new dog
DB[:conn].execute(sql, self.name, self.breed)
#get the dog from the database by id
self.id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
#the ruby instance
self
end 

end
