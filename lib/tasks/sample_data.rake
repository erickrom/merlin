namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    99.times do |n|
      first_name  = "User-#{n}"
      last_name  = "Example-#{n}"
      email = "user-#{n}@example.com"
      password  = "password"
      User.create!(first_name: first_name,
                   last_name: last_name,
                   email: email,
                   password: password,
                   password_confirmation: password)
    end
  end
end
