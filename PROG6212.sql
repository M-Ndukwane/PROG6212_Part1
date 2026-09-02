
BEGIN
CREATE DATABASE RaceDay;
END;
USE RaceDay;

-- ============================================================
--  ROLES
-- ============================================================

CREATE TABLE dbo.Roles
(
    RoleID      INT IDENTITY(1,1) NOT NULL,
    RoleName    NVARCHAR(50) NOT NULL,

    CONSTRAINT PK_Roles
        PRIMARY KEY (RoleID),

    CONSTRAINT UQ_Roles_RoleName
        UNIQUE (RoleName)
);
-- ============================================================
-- USERS
-- ============================================================

CREATE TABLE dbo.Users
(
    UsersID       INT IDENTITY(1,1) NOT NULL,
    FirstName     NVARCHAR(100) NOT NULL,
    LastName      NVARCHAR(100) NOT NULL,
    Email         NVARCHAR(255) NOT NULL,
    [Phone number] NVARCHAR(30) NULL,
    password      NVARCHAR(500) NOT NULL,
    CreatedAt     DATETIME2 NOT NULL
                  CONSTRAINT DF_Users_CreatedAt
                  DEFAULT SYSUTCDATETIME(),
    IsActive      BIT NOT NULL
                  CONSTRAINT DF_Users_IsActive
                  DEFAULT 1,
    RolesID       INT NOT NULL,

    CONSTRAINT PK_Users
        PRIMARY KEY (UsersID),

    CONSTRAINT UQ_Users_Email
        UNIQUE (Email),

    CONSTRAINT FK_Users_Roles
        FOREIGN KEY (RolesID)
        REFERENCES dbo.Roles(RoleID)
);
-- ============================================================
-- VENUES
-- ============================================================

CREATE TABLE dbo.Venues
(
    VenuesID      INT IDENTITY(1,1) NOT NULL,
    VenueName     NVARCHAR(150) NOT NULL,
    AddressLine   NVARCHAR(255) NOT NULL,
    City          NVARCHAR(100) NOT NULL,
    [Postal Code] NVARCHAR(20) NOT NULL,
    Province      NVARCHAR(100) NOT NULL,

    CONSTRAINT PK_Venues
        PRIMARY KEY (VenuesID),

    CONSTRAINT UQ_Venues_NameAddress
        UNIQUE (VenueName, AddressLine)
);

-- ============================================================
--  EVENTS
-- ============================================================

CREATE TABLE dbo.Events
(
    EventsID              INT IDENTITY(1,1) NOT NULL,
    EventName             NVARCHAR(200) NOT NULL,
    Description           NVARCHAR(1000) NULL,
    EventDate             DATE NOT NULL,
    [Start Time]          TIME NOT NULL,
    [Registration DeadLine] DATETIME2 NOT NULL,
    Status                NVARCHAR(30) NOT NULL
                          CONSTRAINT DF_Events_Status
                          DEFAULT N'Open',
    CreatedAt             DATETIME2 NOT NULL
                          CONSTRAINT DF_Events_CreatedAt
                          DEFAULT SYSUTCDATETIME(),

    UserID                INT NOT NULL,
    VenuesID              INT NOT NULL,

    CONSTRAINT PK_Events
        PRIMARY KEY (EventsID),

    CONSTRAINT FK_Events_Users
        FOREIGN KEY (UserID)
        REFERENCES dbo.Users(UsersID),

    CONSTRAINT FK_Events_Venues
        FOREIGN KEY (VenuesID)
        REFERENCES dbo.Venues(VenuesID),

    CONSTRAINT CK_Events_Status
        CHECK
        (
            Status IN
            (
                N'Draft',
                N'Open',
                N'Closed',
                N'Cancelled',
                N'Completed'
            )
        )
);



-- ============================================================
-- CATEGORIES
-- ============================================================

CREATE TABLE dbo.Categories
(
    CategoriesID      INT IDENTITY(1,1) NOT NULL,
    [Categories Name] NVARCHAR(100) NOT NULL,
    [Entry Fee]       DECIMAL(10,2) NOT NULL,
    MaxParticipants   INT NOT NULL,
    EventsID          INT NOT NULL,

    CONSTRAINT PK_Categories
        PRIMARY KEY (CategoriesID),

    CONSTRAINT FK_Categories_Events
        FOREIGN KEY (EventsID)
        REFERENCES dbo.Events(EventsID)
        ON DELETE CASCADE,

    CONSTRAINT UQ_Categories_EventName
        UNIQUE (EventsID, [Categories Name]),

    CONSTRAINT CK_Categories_EntryFee
        CHECK ([Entry Fee] >= 0),

    CONSTRAINT CK_Categories_MaxParticipants
        CHECK (MaxParticipants > 0)
);



-- ============================================================
-- ENROLLMENTS
-- ============================================================

CREATE TABLE dbo.Enrollments
(
    EnrollmentsID          INT IDENTITY(1,1) NOT NULL,
    [Enrolled At]          DATETIME2 NOT NULL
                           CONSTRAINT DF_Enrollments_EnrolledAt
                           DEFAULT SYSUTCDATETIME(),

    Status                 NVARCHAR(30) NOT NULL
                           CONSTRAINT DF_Enrollments_Status
                           DEFAULT N'Confirmed',

    [Emergency Contact Name]
                           NVARCHAR(200) NULL,

    [Emergency Contact Phone]
                           NVARCHAR(30) NULL,

    CategoriesID           INT NOT NULL,
    EventsID               INT NOT NULL,
    UsersID                INT NOT NULL,

    CONSTRAINT PK_Enrollments
        PRIMARY KEY (EnrollmentsID),

    CONSTRAINT FK_Enrollments_Categories
        FOREIGN KEY (CategoriesID)
        REFERENCES dbo.Categories(CategoriesID),

    CONSTRAINT FK_Enrollments_Events
        FOREIGN KEY (EventsID)
        REFERENCES dbo.Events(EventsID)
        ON DELETE CASCADE,

    CONSTRAINT FK_Enrollments_Users
        FOREIGN KEY (UsersID)
        REFERENCES dbo.Users(UsersID),

    CONSTRAINT UQ_Enrollments_UserEvent
        UNIQUE (UsersID, EventsID),

    CONSTRAINT CK_Enrollments_Status
        CHECK
        (
            Status IN
            (
                N'Pending',
                N'Confirmed',
                N'Cancelled',
                N'Completed'
            )
        )
);



-- ============================================================
-- RESULTS
-- ============================================================

CREATE TABLE dbo.Results
(
    ResultsID             INT IDENTITY(1,1) NOT NULL,
    Position              INT NULL,
    [FinishTime(seconds)] INT NULL,
    [Result Status]       NVARCHAR(30) NOT NULL
                          CONSTRAINT DF_Results_Status
                          DEFAULT N'Finished',

    [Recorded At]         DATETIME2 NOT NULL
                          CONSTRAINT DF_Results_RecordedAt
                          DEFAULT SYSUTCDATETIME(),

    EnrollmentsID         INT NOT NULL,

    CONSTRAINT PK_Results
        PRIMARY KEY (ResultsID),

    CONSTRAINT UQ_Results_Enrollment
        UNIQUE (EnrollmentsID),

    CONSTRAINT FK_Results_Enrollments
        FOREIGN KEY (EnrollmentsID)
        REFERENCES dbo.Enrollments(EnrollmentsID)
        ON DELETE CASCADE,

    CONSTRAINT CK_Results_Position
        CHECK (Position IS NULL OR Position > 0),

    CONSTRAINT CK_Results_FinishTime
        CHECK
        (
            [FinishTime(seconds)] IS NULL
            OR [FinishTime(seconds)] > 0
        ),

    CONSTRAINT CK_Results_Status
        CHECK
        (
            [Result Status] IN
            (
                N'Finished',
                N'DNF',
                N'DNS',
                N'DQ'
            )
        )
);

-- ============================================================
-- ROLES
-- ============================================================

INSERT INTO dbo.Roles
(
    RoleName
)
VALUES
    (N'Organiser'),
    (N'Participant');



-- ============================================================
-- USERS
-- 2 Organisers
-- 2 Participants
-- ============================================================

INSERT INTO dbo.Users
(
    FirstName,
    LastName,
    Email,
    [Phone number],
    password,
    RolesID
)
VALUES
(
    N'Lerato',
    N'Naidoo',
    N'lerato.organiser@raceday.test',
    N'0821111111',
    N'DEV_PASSWORD_001',
    1
),
(
    N'Michael',
    N'Botha',
    N'michael.organiser@raceday.test',
    N'0822222222',
    N'DEV_PASSWORD_002',
    1
),
(
    N'Ava',
    N'Mokoena',
    N'ava.participant@raceday.test',
    N'0823333333',
    N'DEV_PASSWORD_003',
    2
),
(
    N'Ryan',
    N'Williams',
    N'ryan.participant@raceday.test',
    N'0824444444',
    N'DEV_PASSWORD_004',
    2
);



-- ============================================================
-- VENUES
-- ============================================================

INSERT INTO dbo.Venues
(
    VenueName,
    AddressLine,
    City,
    [Postal Code],
    Province
)
VALUES
(
    N'Green Point Urban Park',
    N'1 Fritz Sonnenberg Road',
    N'Cape Town',
    N'8051',
    N'Western Cape'
),
(
    N'Kirstenbosch National Botanical Garden',
    N'Rhodes Drive',
    N'Cape Town',
    N'7735',
    N'Western Cape'
),
(
    N'Strand Beachfront',
    N'Beach Road',
    N'Strand',
    N'7140',
    N'Western Cape'
);
GO


-- ============================================================
-- EVENTS
-- UsersID 1 = Lerato
-- UsersID 2 = Michael
-- ============================================================

INSERT INTO dbo.Events
(
    EventName,
    Description,
    EventDate,
    [Start Time],
    [Registration DeadLine],
    Status,
    UserID,
    VenuesID
)
VALUES
(
    N'Cape Town Spring 10K',
    N'A fast road race around Green Point and the Cape Town waterfront.',
    '2026-10-10',
    '07:00',
    '2026-10-05 23:59:00',
    N'Open',
    1,
    1
),
(
    N'Kirstenbosch Trail Challenge',
    N'A scenic trail-running event through the Kirstenbosch area.',
    '2026-11-07',
    '06:30',
    '2026-11-01 23:59:00',
    N'Open',
    1,
    2
),
(
    N'Strand Summer Run',
    N'A beachfront running event with family and competitive categories.',
    '2026-12-05',
    '06:00',
    '2026-11-30 23:59:00',
    N'Open',
    2,
    3
);



-- ============================================================
-- CATEGORIES
-- ============================================================

INSERT INTO dbo.Categories
(
    [Categories Name],
    [Entry Fee],
    MaxParticipants,
    EventsID
)
VALUES
(
    N'10K Open',
    180.00,
    500,
    1
),
(
    N'10K Junior',
    100.00,
    150,
    1
),
(
    N'Trail 15K Open',
    250.00,
    300,
    2
),
(
    N'Trail 5K Fun Run',
    120.00,
    250,
    2
),
(
    N'10K Open',
    160.00,
    400,
    3
),
(
    N'5K Family Run',
    90.00,
    300,
    3
);



-- ============================================================
-- ENROLLMENTS
-- ============================================================

INSERT INTO dbo.Enrollments
(
    [Enrolled At],
    Status,
    [Emergency Contact Name],
    [Emergency Contact Phone],
    CategoriesID,
    EventsID,
    UsersID
)
VALUES
(
    '2026-09-01 10:00:00',
    N'Completed',
    N'John Mokoena',
    N'0831111111',
    1,
    1,
    3
),
(
    '2026-09-01 11:00:00',
    N'Completed',
    N'Sarah Williams',
    N'0832222222',
    1,
    1,
    4
),
(
    '2026-09-02 09:00:00',
    N'Confirmed',
    N'John Mokoena',
    N'0831111111',
    3,
    2,
    3
),
(
    '2026-09-02 10:00:00',
    N'Confirmed',
    N'Sarah Williams',
    N'0832222222',
    5,
    3,
    4
),
(
    '2026-09-02 11:00:00',
    N'Confirmed',
    N'John Mokoena',
    N'0831111111',
    6,
    3,
    3
);



-- ============================================================
-- RESULTS
-- ============================================================

INSERT INTO dbo.Results
(
    Position,
    [FinishTime(seconds)],
    [Result Status],
    EnrollmentsID
)
VALUES
(
    1,
    2435,
    N'Finished',
    1
),
(
    2,
    2501,
    N'Finished',
    2
);

SELECT * FROM dbo.Roles;

SELECT * FROM dbo.Users;

SELECT * FROM dbo.Events;

SELECT * FROM dbo.Categories;

SELECT * FROM dbo.Enrollments;

SELECT * FROM dbo.Results;

SELECT * FROM dbo.Venues;
