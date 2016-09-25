# frozen_string_literal: true
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

#
# Shifts for Nuestra Senora del Rocio
#
r = FactoryGirl.create(:room, name: "Nuestra Señora del Rocío", capacity: 22)
FactoryGirl.create(:shift, start_time: "17:15", end_time: "18:00", day_of_week: 4, sites_reserved: 0, room: r)

#
# Shifts for Nuestra Senora de Guadalupe
#
r = FactoryGirl.create(:room, name: "Nuestra Señora de Guadalupe", capacity: 22)
FactoryGirl.create(:shift, start_time: "17:15", end_time: "18:00", day_of_week: 3, sites_reserved: 0, room: r)
FactoryGirl.create(:shift, start_time: "17:15", end_time: "18:00", day_of_week: 4, sites_reserved: 0, room: r)
FactoryGirl.create(:shift, start_time: "18:15", end_time: "19:00", day_of_week: 2, sites_reserved: 0, room: r)
FactoryGirl.create(:shift, start_time: "18:15", end_time: "19:00", day_of_week: 3, sites_reserved: 0, room: r)

#
# Shifts for Nuestra Senora del Pilar
#
r = FactoryGirl.create(:room, name: "Nuestra Señora del Pilar", capacity: 22)
FactoryGirl.create(:shift, start_time: "18:15", end_time: "19:00", day_of_week: 2, sites_reserved: 0, room: r)
FactoryGirl.create(:shift, start_time: "18:15", end_time: "19:00", day_of_week: 4, sites_reserved: 0, room: r)

#
# Shifts for Nuestra Senora de Monserrat
#
r = FactoryGirl.create(:room, name: "Nuestra Señora de Monserrat", capacity: 22)
# Monday
FactoryGirl.create(:shift, start_time: "17:15", end_time: "18:00", day_of_week: 0, sites_reserved: 0, room: r)
FactoryGirl.create(:shift, start_time: "18:15", end_time: "19:00", day_of_week: 0, sites_reserved: 0, room: r)
# Wednesday
FactoryGirl.create(:shift, start_time: "17:15", end_time: "18:00", day_of_week: 1, sites_reserved: 0, room: r)
FactoryGirl.create(:shift, start_time: "18:15", end_time: "19:00", day_of_week: 2, sites_reserved: 0, room: r)
# Thursday
FactoryGirl.create(:shift, start_time: "18:15", end_time: "19:00", day_of_week: 3, sites_reserved: 0, room: r)
# Friday
FactoryGirl.create(:shift, start_time: "17:15", end_time: "18:00", day_of_week: 4, sites_reserved: 0, room: r)
FactoryGirl.create(:shift, start_time: "18:15", end_time: "19:00", day_of_week: 4, sites_reserved: 0, room: r)

#
# Shifts for Nuestra Senora de Covadonga
#
r = FactoryGirl.create(:room, name: "Nuestra Señora de Covadonga", capacity: 22)
FactoryGirl.create(:shift, start_time: "17:15", end_time: "18:00", day_of_week: 1, sites_reserved: 0, room: r)
FactoryGirl.create(:shift, start_time: "17:15", end_time: "18:00", day_of_week: 4, sites_reserved: 0, room: r)
FactoryGirl.create(:shift, start_time: "18:15", end_time: "19:00", day_of_week: 0, sites_reserved: 0, room: r)
FactoryGirl.create(:shift, start_time: "18:15", end_time: "19:00", day_of_week: 1, sites_reserved: 0, room: r)

#
# Users
#

100.times do
  FactoryGirl.create(:user)
end
