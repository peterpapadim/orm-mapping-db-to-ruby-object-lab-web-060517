require 'pry'

class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    student = self.new
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    student
  end

  def self.all
    query = ("SELECT * FROM students")
    rows = DB[:conn].execute(query)
    rows.map do |row|
      self.new_from_db(row)
    end
  end

  def self.find_by_name(name)
    query = ("SELECT * FROM students WHERE name = ?")
    result = DB[:conn].execute(query, name)
    self.new_from_db(result.first)
  end

  def self.count_all_students_in_grade_9
    query = ("SELECT name FROM students WHERE grade = 9")
    result = DB[:conn].execute(query)
    result.first
  end

  def self.students_below_12th_grade
    query = ("SELECT name FROM students WHERE grade < 12")
    result = DB[:conn].execute(query)
    result.first
  end

  def self.first_x_students_in_grade_10(how_many)
    query = ("SELECT name
    FROM students
    WHERE grade = 10
    ORDER BY id
    LIMIT ?")
    result = DB[:conn].execute(query, how_many)
  end

  def self.first_student_in_grade_10
    query = ("SELECT name
    FROM students
    WHERE grade = 10
    ORDER BY id
    LIMIT 1")
    result = DB[:conn].execute(query).flatten.first
    self.find_by_name(result)
  end

  def self.all_students_in_grade_x(grade)
    query = ("SELECT name
    FROM students
    WHERE grade = ?")
    result = DB[:conn].execute(query, grade)
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end
