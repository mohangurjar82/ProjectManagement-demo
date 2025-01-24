# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

Project Setup

Clone the repo
Install dependencies: bundle install 
Set up the database: rails db:create db:migrate db:seed
Start the Rails server: rails s
API Endpoints Documentation

GET /api/projects: List active projects
POST /api/projects/:project_id/assign: Assign project to user
POST /api/tasks: Add task to an active project
