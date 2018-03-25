require 'pg'
require 'pry'

class Ticket
  attr_accessor :customer_id, :screening_id
  attr_reader :id

  def initialize options
    @customer_id = options['customer_id'].to_s
    @screening_id = options['screening_id'].to_s
    @id = options['id'].to_s
  end

  def save
    sql = "
      INSERT INTO tickets (customer_id, screening_id)
      VALUES ($1, $2)
      RETURNING id;
    "
    values = [@customer_id, @screening_id]
    @id = SqlRunner.run(sql, values).first['id']
  end

  def self.all
    sql = "
      SELECT * FROM tickets;
    "
    list = SqlRunner.run sql
    return list.first != nil ? list.map { |e| Ticket.new(e) } : nil
  end

  def self.delete
    sql = "
      DELETE FROM tickets;
    "
    SqlRunner.run sql
  end
end
