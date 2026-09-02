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

### Participant

A Participant is a user who registers and takes part in RaceDay events.

#### Participants can:

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

## Database Entities

### The RaceDay database contains seven main entities:

Entity/Description

*Roles-Stores the system roles, including Organiser and Participant.

*Users-Stores user account and profile information and links each user to a role.

*Events-Stores race event information, including its organiser, venue, date, time, and status.

*Categories-Stores the race categories available for each event.

*Enrollments-Records participants who enroll in events and the category they select.

*Results-Stores race results for enrolled participants.

*Venues-Stores the locations where race events take place.

## Database Relationships

### The database contains the following relationships:

Roles → Users: One role can have many users.

Users → Events: One organiser can organise many events.

Venues → Events: One venue can host many events.

Events → Categories: One event can contain many categories.

Users → Enrollments: One participant can create many enrollments.

Events → Enrollments: One event can have many enrollments.

Categories → Enrollments: One category can have many enrollments.

Enrollments → Results: One enrollment can have zero or one result.

The Enrollments entity links participants to events and records the category selected by the participant.

## Sample Data

### The SQL database script contains realistic sample data including:

-2 Organisers

-2 Participants

-3 Events

-3 Venues

-Multiple categories for each event

-Sample enrollments

-Sample race results

##Technology

Database: Microsoft SQL Server

Database Management Tool: SQL Server Management Studio (SSMS)

Database Name: RaceDay
