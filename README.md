🪑 Exam Seat Arrangement System

The Exam Seat Arrangement System is a Flutter-based application backed by Firebase that helps educational institutions automatically generate fair and secure exam seating plans.
The platform includes separate interfaces for students and admin/teachers, reducing manual effort and preventing malpractice through intelligent seat distribution.

📌 Problem Statement

Manual exam seat allocation is time-consuming, error-prone, and difficult to scale. Handling large student datasets—especially from Excel sheets—and ensuring subject-wise separation adds further complexity.

This system automates seat allocation while efficiently processing and managing structured student data.

✨ Key Features
👨‍🎓 Student Interface

View assigned exam room and seat details

Access seating information in real time

👩‍🏫 Admin / Teacher Interface

Secure login using Firebase Authentication

Upload and manage student data via Excel or CSV

Edit and validate imported data before processing

Automatic seat arrangement with subject-wise separation

Filter seating data by room, subject, or class

Export seating plans as printable PDFs

🛠 Technologies Used

Flutter & Dart

Firebase Authentication & Firestore

Provider (State Management)

CSV / Excel parsing libraries

PDF generation & printing

Git & GitHub

🔧 Development Process

Designed role-based UI for students and admin/teachers

Implemented Excel/CSV parsing to read structured student data

Handled data validation, correction, and editing after import

Built Dart-based seat arrangement logic to prevent same-subject adjacency

Applied Provider for clean and efficient state handling

Integrated Firebase for secure authentication and real-time storage

Implemented PDF generation for offline and printed reports

⚙️ Technical Challenges Solved

Parsing large Excel/CSV files reliably in Flutter

Mapping spreadsheet data to structured Dart models

Allowing admins to edit and correct imported data before final processing

Handling inconsistent or missing values in spreadsheets

Ensuring performance while processing large datasets

📚 Key Learnings

Working with real-world data formats like Excel and CSV

Designing robust data validation and editing flows

Implementing complex business logic using Dart

Building scalable, admin-focused Flutter applications

Managing large datasets with clean state management
![App Preview](screenshots/exam_app_preview.jpeg)

