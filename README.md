Features
Dashboard               — monthly income, expenses, savings, savings rate, and category breakdown
Financial Health Score — 0–100 score with category label and improvement suggestions
Transactions            — paginated, scrollable transaction history with type badges
Secure Auth — testing Token stored via flutter_secure_storage, auto-redirect on token expiry if i set in 1 min token expiery
Responsive UI — optimised layouts for tablet, and desktop breakpoints
Robust error handling — loading / error / empty states on every screen

_______________________________________________________________________________________________________________________________________________________________________Screens

Screen 1 — Login 

Email + password fields with client-side format validation 
Toggle between Login and Register on a single page
On success: Testig token stored securely → redirect to Dashboard
On token expiry mid-session: auto-redirect back to Login


Screen 2 — Dashboard

CardDataMonthly Incomesummary.monthlyIncomeMonthly Expensessummary.monthlyExpensesSavingssummary.savingsSavings Ratesummary.savingsRate (safe: shows 0% when income is zero)

Added  charts 

Health Score card — numeric score, label (Excellent / Healthy / Moderate / At Risk), and suggestions list


Screen 3 — Transactions

Each row: date · type badge · category · amount  using pluto-gride table
Paginated / scrollable — handles large datasets without freezing
Loading, error, and empty states consistent with Dashboard

_____________________________________________________________________________________________________________________________________________________________

State Management -Bloc

BLoC was chosen over Provider or Riverpod for strict separation between UI and business logic. Each screen has its own Bloc, Event, and State file — the UI only emits events and rebuilds from states, never holding logic itself. This makes the data flow easy to trace and test.


Clean Architeture-


