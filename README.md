# RaceDay System

## Brief Description

RaceDay is a race and event management system designed to help organisers create and manage running events while allowing participants to register for events and view their race information and results.

The system uses a relational SQL Server database to store users, roles, events, venues, event categories, participant enrollments, and race results. Primary keys, foreign keys, unique constraints, default values, and validation constraints are used to maintain data integrity.

### The RaceDay system supports:

-User registration and login

-User profile management

-Event creation and management

-Venue management and event locations

-Event categories

-Participant enrollment

-Race result recording and viewing

## User Roles

### Organiser

An Organiser is responsible for creating and managing race events.

#### Organisers can:

Create new race events.

Update event information.

Manage events that they organise.

Create and manage categories for their events.

View participants enrolled in their events.

Record participant results.

Update or correct race results.

Manage event details such as the venue, date, start time, registration deadline, and status.

###Participant

A Participant is a user who registers and takes part in RaceDay events.

####Participants can:

Register for an account.

Log in to the system.

View and update their profile.

View available events.

View event categories.

Enroll in events and select a category.

View their own enrollments.

Cancel their own enrollment.

View their race results.

Participants can only manage their own profile and enrollments.
