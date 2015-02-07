# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
AppSetting.where(name: 'last_league_fetch').first_or_create(value: 1.hour.ago)
AppSetting.where(name: 'seconds_to_fetch_matches').first_or_create(value: 300)
