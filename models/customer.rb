require('pg')
require('pry')
require_relative('../sql_runner')

class Customer
  attr_accessor :name, :funds
  attr_reader :id

  def initialize options
      @name = options['name']
      @funds = options['funds'].to_s
      @id = options['id'].to_s
  end

  def save
    sql = "
      INSERT INTO customers (name, funds)
      VALUES ($1, $2)
      RETURNING id;
    "
    values = [@name, @funds]
    @id = SqlRunner.run(sql, values).first['id']
  end

  def update
    sql = "
      UPDATE customers
      SET (name, funds)
      = ($1, $2)
      WHERE id = $3;
    "
    values = [@name, @funds, @id]
    SqlRunner.run sql, values
  end

  def films
    sql = "
      SELECT films.*
      FROM films
      INNER JOIN screenings
      ON films.id = screenings.film_id
      INNER JOIN tickets
      ON tickets.screening_id = screenings.id
      WHERE tickets.customer_id = $1
    "
    values = [@id]
    list = SqlRunner.run(sql, values)
    return list.map { |e| Film.new(e) }
  end

  def buy_ticket screening
      film = screening.film
      price = film.first.price.to_i
      return "No available seats" if screening.seats_sold.to_i >= 20

      ticket = Ticket.new({ 'customer_id' => @id,
        'screening_id' => screening.id })
      ticket.save

      new_funds = @funds.to_i - price.to_i
      @funds = new_funds.to_s
      update

      seat_update = screening.seats_sold.to_i + 1
      screening.seats_sold = seat_update.to_s
      screening.save
  end

  def funds
    sql = "
      SELECT funds
      FROM customers
      WHERE id = $1;
    "
    values = [@id]
    return SqlRunner.run(sql, values).first['funds']
  end

  def self.all
    sql = "
      SELECT * FROM customers;
    "
    list = SqlRunner.run sql
    return list.first != nil ? list.map { |e| Customer.new(e) } : nil
  end

  def self.delete
    sql = "
      DELETE FROM customers;
    "
    SqlRunner.run sql
  end
end
