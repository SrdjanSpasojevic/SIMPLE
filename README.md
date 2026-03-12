SIMPLE
=====

![Works on my machine](https://img.shields.io/badge/works%20on%20my%20machine-YES-brightgreen)
![Unit tests](https://img.shields.io/badge/unit%20tests-YES-brightgreen)
### Requirements

- **Xcode**: 15 or newer  
- **iOS target**: iOS 17 or newer 
- **SwiftData** support


### Seeded demo users (username / password)

These users are created the first time the app runs, if there are no existing users in the database (see `MockDataRepository.seedUsersIfNeeded`).

- **John Doe**
  - **Username**: `john.doe`
  - **Password**: `password1`
- **Jane Doe**
  - **Username**: `jane.doe`
  - **Password**: `password2`
- **Alice Smith**
  - **Username**: `alice.smith`
  - **Password**: `password3`
- **Bob Brown**
  - **Username**: `bob.brown`
  - **Password**: `password4`
- **Charlie Johnson**
  - **Username**: `charlie.johnson`
  - **Password**: `password5`

You can use any of these username/password pairs on the login screen.

### How user IDs are generated and how to see them

- Every seeded user gets a **random UUID string** as their `id` when seeding runs:
  - `User.id` is created with `UUID().uuidString` in `MockDataRepository`.
- During seeding, the app **prints each user’s id, username, and password** to the Xcode console:
  - `"[MOCK DATA] User to be saved: <id> | <username> | <password>"`

**To see the seeded user IDs:**

1. Open the project in Xcode and run the app (Cmd+R) on a fresh install (no existing SwiftData store).  
2. In Xcode, open the **Debug area** (View → Debug Area → Activate Console or press **Cmd+Shift+C**).  
3. Look for log lines starting with **`[MOCK DATA]`**; each line shows:
   - `id` (UUID string)
   - `username`
   - `password`
4. Copy or note the IDs you need (for example, to use in API mocks or tests).

If you already ran the app and the users were seeded once, these log lines will not appear again unless you **reset the data** (e.g., delete the app from the simulator or reset the simulator/device so SwiftData starts fresh).

### Biometric authentication

On app startup, if there is a currently logged-in user, the app will prompt for biometric authentication (Face ID / Touch ID) using the system dialogs.

### App flows

- **First launch**
  - The app creates the SwiftData store and seeds demo users if none exist.
  - No user is logged in yet, so you start on the **Login** screen.
- **Register**
  - From the **Login** screen, tap the **Register** action to open the registration screen.
  - Fill in user details and create a new account; on success, the new user is stored in SwiftData and you are taken back into the main flow.
- **Login**
  - Enter any seeded or newly registered `username` / `password` pair and tap **Log in**.
  - On success, the app sets the logged-in user and navigates to **Home**.
- **Home**
  - Shows the current user’s balance and recent transactions.
  - From here you can navigate to the **Transfer** screen or log out.
- **Transfer**
  - Choose a recipient (another user) and an amount.
  - When the transfer completes, balances and transactions are updated for both parties and you are navigated back.
- **Subsequent launches**
  - If a user is still marked as logged in, the app will ask for **biometric authentication** on startup.
  - On successful biometrics, you go straight to **Home**; on failure, you stay logged out and see the **Login** screen again.

### Demo

https://github.com/user-attachments/assets/6d4093c6-054b-433c-bdd7-fcdcaa2ac837


