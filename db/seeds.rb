# coding: utf-8

User.create!(name: "Admin User",
            email: "admin@email.com",
            password: "password",
            password_confirmation: "password",
            admin: true)
            
2.times do |n|
  name = Faker::Name.name
  email = "superior-#{n+1}@email.com"
  password = "password"
  User.create!(
                name: name,
                email: email,
                password: "password",
                password_confirmation: "password",
                superior: true
              )
end

3.times do |x|
  name = Faker::Name.name
  email = "sample-#{x+1}@email.com"
  User.create!(
                name: name,
                email: email,
                password: "password",
                password_confirmation: "password"
              )
end