# UAWS Animal Welfare App – Complete Functional Specification

This document outlines the detailed requirements for a mobile and web-based application for the Universal Animal Welfare Society (UAWS).

---

## User Roles and Access Levels (Layer-wise Structure)

### 1. Layer 1 – Field Staff (Catchers, Vaccinators, LSS)

-   Full access to: **Vaccination Tracker** and **Sterilization Tracker**
-   Can enter and update assigned data only
-   Must upload photo + GPS in real-time

### 2. Layer 2 – NGO Supervisors & Area Managers

-   Full access to all modules for their assigned city/ward/area
-   Can view, edit, and monitor data from field teams
-   Responsible for data quality checks, follow-ups, and coordination

### 2B. Layer 2B – Municipal Corporation Officials

-   Read-only access to dashboards and data for their respective jurisdiction
-   View vaccination, sterilization, rabies, bite, and education tracker logs
-   Cannot create, edit or delete entries
-   Can view stats, logs, photo entries, and summaries

### 3. Layer 3 – Central Admin Team

-   **Super Admins (2–3):** Control all layers, users, roles, and permissions
-   **Data & Reporting Admins:** Validate, audit and generate auto-reports
-   Full access to all modules, all cities, and automated monthly reporting tools

---

## Sterilization Tracker Module – Detailed Breakdown

**Purpose:** To log, track, and manage every animal (dog or cat) picked up for sterilization, through three key stages:

### I. Pickup Stage

-   Animal details collected from field location with GPS and photo

**Data Fields Required:**

-   Species (Dog/Cat)
-   Sex (Male/Female/Unnoticed)
-   Age Group (Puppy/Kitten/Young/Adult/Senior) - **Updated to match database standardization**
-   Ward/Zone (Dropdown based on city)
-   Tag Number (Manual entry)
-   Cage Number (Manual entry) - **Mandatory**
-   Identification Marks (Color, scars, collar, ear notch, etc.)
-   Pickup Date & Time (Auto)
-   Pickup Photo (Mandatory)
-   Pickup GPS (Auto-captured)
-   Picked By (Dropdown – Field Staff Name)

### II. Operation Stage

-   Performed at designated sterilization center

**Data Fields Required:**

-   Surgery Status (Operated/Not Operated)
-   Operated Date
-   Surgeon/Doctor Name (Dropdown)
-   Operation Photo (Optional)
-   Complications (Yes/No – with remarks if Yes)

### III. Release Stage

-   After post-operative care and recovery, animal is released

**Data Fields Required:**

-   Release Date
-   Released By (Dropdown – Staff Name)
-   Release Photo (Optional)
-   Final Status (Released/Death/Postponed)
-   Recovery Notes (Free Text)
-   Final GPS (Optional)

---

## Validation Rules and Functional Flow

-   Every stage (Pickup, Operation, Release) must be saved sequentially
-   GPS location and photograph are mandatory during Pickup
-   Tag and Cage Numbers are manually entered by staff at shelter
-   Operation and Release stages remain locked until Pickup is completed
-   Each animal entry is uniquely identified by Tag Number and Date
-   Layer 1 users can only enter Pickup stage data. Operation & Release stages are managed by Layer 2 & Layer 3 users

---

## Sterilization Tracker – Role-Based Access Summary

| Process Stage | Layer 1 (Field) | Layer 2 (NGO Supervisors) | Layer 3 (Admin) |
| ------------- | --------------- | ------------------------- | --------------- |
| Pickup        | ✅ Entry        | ✅ View/Edit              | ✅ Full Access  |
| Operation     | ❌              | ✅ Entry/Edit             | ✅ Full Access  |
| Release       | ✅ Entry        | ✅ Entry/Edit             | ✅ Full Access  |

---

## 2. Bite Case Tracker

**Purpose:** Track each dog bite incident in the city by public complaints or field observation

**Required Fields:**

-   **Source:** Complaint Source (Public/PMC/Online)
-   **Victim Details:** Name, Age, Gender, Contact, Address, Ward, Incident Location (Address + GPS)
-   **Incident:** Incident Date, Bite Details (Severity: Minor/Major/Severe, Body Part, Circumstances)
-   **Animal Information:** Species (Dog/Cat/Other), Sex, Size, Color, Behavior, Vaccination Status, Stray Status, Owner Details (if applicable)
-   **Medical Follow-up:** Hospital Name, Doctor Name, Treatment Given, Anti-rabies Vaccine Status, Treatment Date, Follow-up Required, Next Appointment
-   **Quarantine:** Quarantine Required (Yes/No), Quarantine ID (if linked)
-   **Case Management:** Status (Open/Under Investigation/Closed/Referred), Case Photos, Notes
-   **Metadata:** Created At, Created By

**Layer Access:**

-   Layer 1: ❌ No Access
-   Layer 2: Full Entry + Editing + Monitoring
-   Layer 2B: View-only
-   Layer 3: Full Control

---

## 3. Biting Animal Quarantine Tracker

**Purpose:** Monitor animals isolated under 10-day observation after a confirmed or suspected bite

**Required Fields:**

-   **Related Case:** Bite Case ID (linked to bite incident)
-   **Animal Information:** Species (Dog/Cat/Other), Sex, Age, Color, Size, Identification Marks, Tag Number
-   **Quarantine Period:** Start Date, End Date, Observation Status
-   **Location:** Quarantine Location Type (Home/Facility/Street), Address, GPS Coordinates
-   **Daily Observations (10 days):**
    -   Date, Status (Alive & Healthy/Sick/Dead/Escaped/Not Observed)
    -   Symptoms, Temperature, Appetite (Normal/Reduced/Loss/Increased)
    -   Behavior (Normal/Lethargic/Aggressive/Restless/Depressed)
    -   Notes, Observed By, Photos
-   **Owner Details:** Name, Contact, Address, Cooperation Level (if applicable)
-   **Final Outcome:** Released/Euthanized/Natural Death/Transferred
-   **Documentation:** Notes, Created At, Created By

**Layer Access:**

-   Layer 1: ❌ No Access
-   Layer 2: Entry/Monitoring Access
-   Layer 2B: View-only Access
-   Layer 3: Full Access

---

## 4. Rabies Case Surveillance Tracker

**Purpose:** Log and monitor animals with clinical symptoms of rabies and confirmed cases

**Required Fields:**

-   **Related Cases:** Bite Case ID, Quarantine ID (if applicable)
-   **Report Details:** Report Date, Suspicion Level (Low/Medium/High)
-   **Animal Information:** Species, Sex, Age, Color, Size, Identification Marks, Tag Number, Vaccination Status
-   **Location:** Address, Ward/Zone, GPS Coordinates
-   **Clinical Signs:**
    -   Behavioral (Aggression, Restlessness, Excessive barking, etc.)
    -   Neurological (Drooling, Paralysis, Seizures, Incoordination, etc.)
    -   Physical (Fever, Lethargy, Loss of appetite, etc.)
    -   Onset and Progression details
-   **Lab Samples:** Sample Type, Collection Date, Lab Name, Test Method, Result (Positive/Negative/Pending), Result Date, Lab Report Number
-   **Outcome:** Status, Date, Cause, Post-mortem details, Disposal method
-   **Public Health Measures:** Area disinfection, Contact tracing, Exposure assessment, Community alert, Mass vaccination, Quarantine area
-   **Documentation:** Reported By, Verified By, Notes, Photos
-   **Metadata:** Created At, Created By

**Layer Access:**

-   Layer 1: ❌ No Access
-   Layer 2: Full Data Entry and Updates
-   Layer 2B: View-only (Read Dashboard/Reports)
-   Layer 3: Full Admin Access

---

## 5. Education Initiative Tracker

**Purpose:** Log community awareness and educational outreach campaigns by UAWS

**Required Fields:**

-   Type of Campaign (School Visit / Workshop / Street Play / Hoarding / Online Poster / Radio Ad / Others)
-   Location & Ward
-   Date of Event
-   Materials Used (Video / PDF / Hoarding Photos / Audio)
-   No. of Participants Reached
-   Upload Photos/Proofs (Mandatory)
-   Conducted By (NGO Name / Partner)

**Layer Access:**

-   Layer 1: ❌ No Access
-   Layer 2: Entry Access + Uploads
-   Layer 2B: View-only
-   Layer 3: Full Admin + Audit Access

---

## Note to Developer

-   This Sterilization Tracker must function in a 3-step process (Pickup > Operation > Release) and support strict role-based entry
-   Dashboard required for:

    -   Different locations in a city
    -   Different cities
    -   Separate dashboards for hospitals
    -   Cumulative all center/hospital dashboard for Layer 3 Admin
    -   Single city dashboard for Municipality

-   Monthly auto-report generation for municipal authorities between 1–5th of next month based on sterilization and vaccination tracker
-   Validation checks must prevent incomplete or skipped processes
-   Photos and GPS are **mandatory** for audit compliance
-   App should support:
    -   Marathi + English
    -   Offline data collection
    -   Auto-sync when internet is available
    -   Reporting with full metadata export (GPS, photo, timestamps, operator details)
