#  Secure Notes App
Demo Login Credentials:-
username:- admin
password:- 1234

A Flutter application for creating, editing, and managing secure notes using **BLoC state management** and **Clean Architecture** principles. All notes are stored locally in **encrypted form** using `flutter_secure_storage`.

---

##  Features

*  Authentication (Login / Logout)
*  Biometric Login Support
*  Add, Edit, Delete Notes
*  Search & Sort Notes
*  Encrypted Local Storage
*  Session Handling on App Restart
   When the app remains idle for 2 minutes, the user is automatically logged out and redirected to the login screen.
*  BLoC (Event–State) Architecture
*  Clean Architecture Structure
*  Tablet & Phone Friendly UI

---

##  Architecture Overview

The app follows **Clean Architecture** with clear separation of concerns:

```
lib/
│
├── core/
│   ├── encryption/        # Encryption & Decryption helpers
│   ├── routes/            # GoRouter configuration
│   └── widgets/           # Reusable UI components
│
├── features/
│   ├── auth/              # Authentication feature
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │       └── bloc/
│   │           ├── event/
│   │           ├── state/
│   │           └── auth_bloc.dart
│   │
│   ├── notes/             # Notes feature
│   │   ├── data/          # Local data source (Secure Storage)
│   │   ├── domain/        # Note entity
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── events/
│   │       │   ├── states/
│   │       │   └── notes_bloc.dart
│   │       └── pages/
│   │
│   └── splash/            # Splash / Auth Gate
│
└── main.dart
```

---

## 🔄 State Management (BLoC)

This app uses **flutter_bloc** with a strict **Event → State** flow.

### 🔐 AuthBloc

**Events**

* `LoginEvent`
* `BioMetricLoginEvent`
* `LogoutEvent`
* `CheckLoginStatus`

**States**

* `AuthInitial`
* `AuthLoading`
* `AuthSuccess`
* `AuthFailure`
* `AuthLogout`

---

### 📝 NotesBloc

**Events**

* `LoadNotes`
* `AddNote`
* `UpdateNote`
* `DeleteNote`

**States**

* `NotesInitial`
* `NotesLoading`
* `NotesLoaded`
* `NotesError`

---

## 🔐 Secure Storage & Encryption

All notes are stored using `flutter_secure_storage`.

* Notes are serialized to JSON
* Encrypted using `EncryptionHelper`
* Saved locally under a secure key

```dart
final encrypted = EncryptionHelper.encryptText(json);
await storage.write(key: 'notes', value: encrypted);
```

This ensures **data privacy even if the device is compromised**.

---

##  Navigation

Navigation is handled using **GoRouter** with authentication-based redirects.

* Splash screen acts as an **Auth Gate**
* Redirects automatically based on `AuthBloc` state
* Router listens to bloc changes using `refreshListenable`

---

##  Reusable Widgets

Common widgets used across the app:

* `CommonTextFormField`
* `CommonButton`
* `CommonNoteCard`

###  CommonNoteCard

Supports:

* Tap to edit
* Edit button
* Delete button

```dart
CommonNoteCard(
  title: note.title,
  subtitle: note.content,
  onEdit: () => editNote(note),
  onDelete: () => deleteNote(note),
)
```

---

##  Validation & UX

* Form validation only triggers on submit
* No premature error messages
* Loading indicators during async actions


## 📦 Dependencies Used

* `flutter_bloc`
* `go_router`
* `flutter_secure_storage`
* `local_auth`


