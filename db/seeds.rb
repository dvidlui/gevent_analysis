# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

p "- Clear all jobs"
Delayed::Job.destroy_all

p "- Destroy User"
User.destroy_all

p "- Create Admin for Bunch"
user = User.where(email: "admin@test.com").first
unless user.present?
  admin = User.create(email: "admin@test.com", password: "password123",
    password_confirmation: "password123", member_type: User::MEMBER_TYPE[:admin], 
    first_name: "David", last_name: "Lui", confirmed_at: Time.now)
  admin = User.find(admin.id.to_s)
  admin.confirm!
end