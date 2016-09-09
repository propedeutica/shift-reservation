# Shift reservation
[![Dependency Status](https://gemnasium.com/badges/github.com/propedeutica/shift-reservation.svg)](https://gemnasium.com/github.com/propedeutica/shift-reservation)
[![Build Status](https://travis-ci.org/propedeutica/shift-reservation.svg?branch=master)](https://travis-ci.org/propedeutica/shift-reservation)
[![Chat](https://badges.gitter.im/propedeutica/shift-reservation.png)](https://gitter.im/propedeutica/shift-reservation)
[![Coverage Status](https://coveralls.io/repos/github/propedeutica/shift-reservation/badge.svg?branch=master)](https://coveralls.io/github/propedeutica/shift-reservation?branch=master)

## Introduction
This application tries to make it possible to reserve places in a school where the users are not capable of doing on their own (because they are under age). Parents can sign up with their own data and then add their offspring. Once that is done they can ask for a particular shift where they want their offspring to be assigned.

It is also a technology example for the following:
- Rails 5
- Haml
- Patternfly
- RSPEC
- Rubocop

## TODO
There is a [**TODO**](TODO.md) file describing what is still missing

## Configuration
This application has been created to be deployed in OpenShift online v 3.
You need:
- An OpenShift online account
- A Rails cartridge (5.0.0.1)
- A PostgreSQL cartridge (9.5, but anyone should work)
 I recommend to set up the application as an elastic one so the database is in a different place
- Environment variables (rhc env set):
  - GMAIL_DOMAIN
  - GMAIL_PASSWORD
  - GMAIL_USERNAME

If you are using gmail, you should use two-factor authentication to avoid the account to be considered as an spam account

## Description
Shift reservation is a simple program to make it possible distributed assignment of shifts to students that can not do it by themselves, and need their parents to do it in their behalf.
There are different rooms that hold classes in parallel, and each of those rooms have a group of shift. A new student needs to be assigned to one of the shifts for the full course. Rooms have a capacity, but some of the shifts can have some places reserved (prebooked) for different reasons, and the parent is free to choose any shift that has some free space left.

This does not take into account that the parents can need

### Users
Users are identified as parents. They can add and delete offspring and assigning them to a shift. Only one parent is in the system, and there is no option for two parents (although it could be added). They can sign up and add children into the system, and they can assign those children to shifts that have some space available. They can also delete those children from the system.
The amount of information requested is the minimum possible.

### Offsprings
Offsprings are related to parents and they are the subject that is assigned to a shift. An offspring is assigned to a single shift for the year.

### Room and shift
There are different rooms that can be assigned. Each one has different shifts that corresponds to a group of students and a teacher.

An offspring can only be assigned to a shift in a single room. Trying to add another will result in the first one being deleted.

## Getting started
### Prerequisites
- [**Git**] (https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
- [**Ruby 2.2.2 or newer and Rails 5**] (http://guides.rubyonrails.org/getting_started.html#installing-rails)
- [**Bower**] (https://bower.io/#install-bower)

### Get the Rails environment up and running
- [**Clone (or fork if you want contribute) this repository in your local machine**] (https://github.com/propedeutica/shift-reservation)
    $ bin/setup            # Installs dependencies, config, prepares database, etc
    $ bower install        # Installs bower components
    $ rails s              # Application starting in development
- Using your favorite browser, go to [http://localhost:3000] (http://localhost:3000)
