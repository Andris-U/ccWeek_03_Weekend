require 'pg'
require 'pry'

class Film
  attr_accessor :title, :price
  attr_reader :id

  def initialize options
    @title = options['title']
    @price = options['price'].to_s
    @id = options['id'].to_s
  end

  def save
    sql = "
      INSERT INTO films (title, price)
      VALUES ($1, $2)
      RETURNING id;
    "
    values = [@title, @price]
    @id = SqlRunner.run(sql, values).first['id']
  end

  def customers
    sql = "
      SELECT customers.*
      FROM customers
      INNER JOIN tickets
      ON customers.id = tickets.customer_id
      INNER JOIN screenings
      ON tickets.screening_id = screenings.id
      INNER JOIN films
      ON screenings.film_id = films.id
      WHERE films.id = $1;
    "
    values = [@id]
    list = SqlRunner.run sql, values
    return list.first != nil ? list.map { |e| Customer.new(e) } : nil
  end

  def self.all
    sql = "
      SELECT * FROM films;
    "
    list = SqlRunner.run sql
    return list.first != nil ? list.map { |e| Film.new(e) } : nil
  end

  def self.delete
    sql = "
      DELETE FROM films;
    "
    SqlRunner.run sql
  end
end
