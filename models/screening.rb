require 'pg'
require 'pry'

class Screening
  attr_accessor :seats_sold, :screening_time, :film_id
  attr_reader :id

  def initialize options
    @seats_sold = 0.to_s
    @screening_time = options['screening_time'].to_s
    @film_id = options['film_id'].to_s
    @id = options['id'].to_s
  end

  def save
    sql = "
      INSERT INTO screenings (seats_sold, screening_time, film_id)
      VALUES ($1, $2, $3)
      RETURNING id;
    "
    values = [@seats_sold.to_s, @screening_time, @film_id.to_s]
    @id = SqlRunner.run(sql, values).first['id']
  end

  def film
    sql = "
      SELECT *
      FROM films
      WHERE films.id = $1
    "
    values = [@film_id]
    result = SqlRunner.run(sql, values)

    return result.first != nil ? result.map { |e| Film.new(e) } : nil
  end

  def sell_ticket
    total_sold = @seats_sold.to_i - 1
    @seats_sold = total_sold.to_s
  end

  def self.most_popular
    sql = "
      SELECT screening_id, COUNT(*) as count
      FROM tickets
      GROUP BY screening_id
      ORDER BY count
      LIMIT 1;
    "
    id = SqlRunner.run(sql).first['screening_id'].to_i
    return Screening.select_by_id(id)
  end

  def self.select_by_id id
    sql = "
      SELECT *
      FROM screenings
      WHERE id = $1;
    "
    values = [id]
    result = SqlRunner.run sql, values
    return result.first != nil ? result.map { |e| Screening.new(e) } : nil
  end


  def self.delete
    sql ="
      DELETE FROM screenings;
    "
    SqlRunner.run sql
  end

  def self.all
    sql = "
      SELECT * FROM screenings;
    "
    SqlRunner.run sql
  end

end
