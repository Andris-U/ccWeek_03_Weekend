require 'pg'
require 'pry'
require_relative '../models/customer'
require_relative '../models/film'
require_relative '../models/ticket'
require_relative '../models/screening'

customer1 = Customer.new({
  'name' => 'John',
  'funds' => 25
  })
customer2 = Customer.new({
  'name' => 'James',
  'funds' => 40
  })
film1 = Film.new({
  'title' => 'Blade Runner',
  'price' => 5
  })

Ticket.delete
Customer.delete
Film.delete
Screening.delete

customer1.save
customer2.save
film1.save

screening1 = Screening.new({
  'screening_time' => '20:00',
  'film_id' => film1.id
  })

screening1.save

ticket1 = Ticket.new({
  'customer_id' => customer1.id,
  'screening_id' => screening1.id
  })

ticket1.save

p Customer.all
p Film.all
p Ticket.all

p customer1.films
p film1.customers
customer2.buy_ticket(screening1)
p customer2.films
p customer2.funds
 p Screening.most_popular
