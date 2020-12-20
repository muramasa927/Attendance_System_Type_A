# coding: utf-8

User.create!(
            name: "Admin User",
            email: "admin@email.com",
            password: "password",
            password_confirmation: "password",
            employee_number: "a0001",
            uid: 1,
            admin: true
          )
            
2.times do |n|
  name = Faker::Name.name
  email = "superior-#{n+1}@email.com"
  password = "password"
  User.create!(
                name: name,
                email: email,
                password: "password",
                password_confirmation: "password",
                employee_number: "s000#{n+1}",
                uid: n+2,
                superior: true,
                designated_work_start_time: "9:00:00",
                designated_work_end_time: "18:00:00"
              )
end

3.times do |x|
  name = Faker::Name.name
  email = "sample-#{x+1}@email.com"
  User.create!(
                name: name,
                email: email,
                password: "password",
                password_confirmation: "password",
                employee_number: "u000#{x+1}",
                uid: x+3,
                designated_work_start_time: "9:00:00",
                designated_work_end_time: "18:00:00"
              )
end