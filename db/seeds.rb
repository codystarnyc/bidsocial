# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#Charity.create(name: "NorCal Autism Research Foundation",
#                email: "auction@charity.com")

t = Time.now
Auction.create(name: "Bid Social",
               charity_id: 1, start: t,
                    finish: (t + 86400))

                   

70.times do |n|
 name = Faker::Commerce.product_name
 description = "You know you want it!"
 Item.create!(name: name,
              description: description,
              auction_id: 1,
              user_id: 1,
              value: n + 1 * 10,
              starting_bid: 20,
              bid_increment: 10)
end
 



# (1..10).each do |number|
#   Item.create(auction_id: 1,
#                  user_id: 1,
#                     name: "piano " + number.to_s,
#              description: "old and out of tune",
#                    value: number * 10000)
#   Bid.create(    item_id: number,
#                  user_id: 1,
#                   amount: number * 20)
# end
 



