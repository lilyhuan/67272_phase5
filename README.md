67-272: Creamery Project (Spring 2020)
===

This is project created for 67-272: Application Design and Development.

This particular version is in Rails 5.2.7 because of some callback bugs in the current 6.0 version of Rails.

All models, controllers, and services have 100% test coverage.

Create and populate the database
---

The development database can be created and populated with a large number of realistic, but still fictitious, data by running the command `rake db:populate` on the command line of the main directory.  This will take a few minutes, but will give you:

1. Two admins, Alex and Mark; each has a username that is lowercase of their first name and a password of 'secret'.

2. Seven stores in the Pittsburgh area and a manager that is assigned to each.  Manager usernames are their first and last names downcases and concatenated with a '.' and all passwords are secret.

3. 100 regular employees; all have username of 'user' and some number concatenated as well as a password of 'secret'. 

4. Each employee has 1-3 assignments, and each employee's current assignment has 15-30 past shifts and 1-6 upcoming shifts.  Each past shift has one job assigned to it.