# Requirements Document

## Introduction

This feature enhances the privacy and user experience of the exercise tracking system by ensuring that users only see their own exercise tracking progress data. Currently, the exercise cards display tracking progress from any user who has tracked that exercise, which creates privacy concerns and confusing user experience. This feature will modify the exercise display logic to show only the current user's tracking data.

## Requirements

### Requirement 1

**User Story:** As a user viewing exercise cards, I want to see only my own tracking progress, so that my workout data remains private and the interface shows relevant information.

#### Acceptance Criteria

1. WHEN a user views an exercise card THEN the system SHALL display only exercise trackings that belong to the current user
2. WHEN a user views an exercise card AND they have no tracking history for that exercise THEN the system SHALL show "Not tracked" status
3. WHEN a user views an exercise card AND they have tracking history THEN the system SHALL show their latest tracking data including weight, reps, and session count
4. WHEN a user views an exercise card AND they have tracking history THEN the system SHALL show the progress bar based on their own tracking data
5. WHEN a user views an exercise card AND they have completed the exercise today THEN the system SHALL show the "Done" badge only if they personally completed it

### Requirement 2

**User Story:** As a user, I want the exercise completion status to reflect only my own activity, so that I can accurately track my personal progress.

#### Acceptance Criteria

1. WHEN a user views an exercise card THEN the "Done" badge SHALL only appear if the current user has tracked that exercise today
2. WHEN a user views an exercise card THEN the completion check SHALL use only the current user's exercise trackings for today
3. WHEN a user views an exercise card THEN the session count SHALL reflect only the current user's total sessions for that exercise

### Requirement 3

**User Story:** As a user, I want the recent progress section to show only my personal tracking data, so that I can monitor my individual fitness journey.

#### Acceptance Criteria

1. WHEN a user views the recent progress section THEN the system SHALL display only the current user's latest tracking for that exercise
2. WHEN a user views the recent progress section THEN the progress percentage SHALL be calculated based only on the current user's tracking data
3. WHEN a user views the recent progress section THEN the "time ago" display SHALL show when the current user last performed the exercise
4. WHEN a user has no tracking history for an exercise THEN the recent progress section SHALL not be displayed