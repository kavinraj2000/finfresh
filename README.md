FinFresh Flutter App

A responsive, secure, and feature-rich personal finance management app built with Flutter, following BLoC state management and Clean Architecture principles.

Features

Dashboard

Monthly Income, Expenses, Savings, Savings Rate, and Category Breakdown

Interactive charts for better visualization

Financial Health Score

0–100 numeric score

Category label (Excellent / Healthy / Moderate / At Risk)

Actionable improvement suggestions

Transactions

Paginated, scrollable transaction history

Type badges for income/expense

Handles large datasets efficiently with pluto_grid

Secure Authentication

Token stored securely via flutter_secure_storage

Auto-redirect on token expiry (configurable, e.g., 1-minute testing expiry)

Responsive UI

Optimized for mobile, tablet, and desktop layouts

Robust Error Handling

Loading, empty, and error states implemented consistently on every screen

Screens
1. Login / Register

Fields: Email + Password with client-side format validation

Toggle: Switch between Login and Register on a single page

Success Flow: Securely store token → Redirect to Dashboard

Token Expiry: Auto-redirect back to Login if token expires mid-session

2. Dashboard

Cards:

monthlyIncome → Monthly Income

monthlyExpenses → Monthly Expenses

savings → Savings

savingsRate → Savings Rate (safe: shows 0% if income is zero)

Charts: Visualize trends and category breakdown

Health Score Card: Numeric score, label, and improvement suggestions

3. Transactions

Row Data: Date · Type Badge · Category · Amount

Grid: Paginated / Scrollable using pluto_grid

State Handling: Loading, error, and empty states consistent with Dashboard

State Management

BLoC was chosen for strict separation of UI and business logic.

Each screen has its own Bloc, Event, and State files

UI only emits events and rebuilds from states, never holding logic

Ensures traceable, testable, and maintainable data flow

Architecture

Clean Architecture principles applied:

Presentation Layer: Flutter UI + BLoC

Domain Layer: Business logic and entities

Data Layer: Repository implementations, API, or local DB

Makes the app scalable, modular, and easy to test
