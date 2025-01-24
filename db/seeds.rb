# Create Users
admin = User.create!(name: "Admin", email: "admin@example.com", role: "Admin", password: "Password@123")
user1 = User.create(name: "User 1", email: "user1@example.com", role: "User", password: "Password@123")
user2 = User.create(name: "User 2", email: "user2@example.com", role: "User", password: "Password@123")

# Create Projects
project1 = Project.create(name: "Project 1", start_date: "2025-01-01", duration_day: 5, duration_timeframe: "days" )
project2 = Project.create(name: "Project 2", start_date: "2025-02-01", duration_day: 1, duration_timeframe: "month" )

# Assign Users to Projects
Assignment.create(user: admin, project: project1, assigned_by_id: admin&.id)
Assignment.create(user: user1, project: project1, assigned_by_id: admin&.id )
Assignment.create(user: user2, project: project2, assigned_by_id: admin&.id)

# Create Tasks
task1 = Task.create!(name: "Task 1", description: "Homepage Design", start_time: "2025-01-01 10:00", end_time: "2025-01-01 11:00", duration: 1, project: project1, created_by: user1)
task2 = Task.create(name: "Task 2", description: "Backend Setup", start_time: "2025-01-02 17:00", end_time: "2025-01-02 19:00", duration: 2, project: project1, created_by: user2)

# Assigned Tasks to User
UserTask.create(user_id: user1.id, task_id: task1.id, assigned_at: DateTime.now, assigned_by_id: admin.id)
UserTask.create(user_id: user1.id, task_id: task2.id, assigned_at: DateTime.now, assigned_by_id: admin.id)