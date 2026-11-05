# Code Room

Anonymous, room-based realtime chat for Android, built with Flutter and Firebase. Join a room with a 6-digit code or create a new one, get a generated identity for that room, and chat. Rooms you have already loaded stay readable with no connection, and messages you send offline are delivered when you reconnect.

- **APK:** [apk/code-room.apk](apk/code-room.apk)
- **Demo video:** https://drive.google.com/file/d/1e8wCqrnX_Sium6EyRJcVTh-oR2iopOlz/view

## Features

- Realtime text messaging with server timestamps
- Date separators (Today, Yesterday, then the full date)
- Generated names per room, unique within the room
- Paginated chat history, 30 messages per page
- Join an existing room or create a new one
- Offline persistence: loaded chat stays visible when rejoining without connectivity
- Offline sending: messages queue locally and deliver in order on reconnect
- UI animations and local notifications
- Dark and light mode, with a toggle on the Join screen. The app follows the system setting until the toggle is used, and the choice is saved

## Tech stack

| Concern | Choice |
|---|---|
| State management | Riverpod |
| Persistent storage | Drift (SQLite) |
| Backend | Cloud Firestore, Firebase Anonymous Auth |
| Routing | go_router |
| Notifications | flutter_local_notifications |
| Layout scaling | flutter_screenutil, from the 375×812 Figma frame |

## Codebase structure

The app uses feature-first clean architecture. Each feature has three layers, and dependencies only point inward: `presentation` → `domain` ← `data`. The `domain` layer is pure Dart, with no Flutter, Firebase or Drift imports.

```
lib/
├── main.dart                     Firebase and notification setup, ProviderScope
├── app.dart                      MaterialApp, themes, screen scaling
├── firebase_options.dart
├── core/
│   ├── database/                 Drift database and table definitions
│   ├── error/                    Sealed Failure types
│   ├── network/                  Connectivity service
│   ├── notifications/            Local notification service
│   ├── providers/                Firebase, database and lifecycle providers
│   ├── router/                   Routes and page transitions
│   ├── theme/                    AppColors (dark and light), text styles, theme
│   └── widgets/                  Room header, primary button, custom icons
└── features/
    ├── room/                     Join, create, identity
    │   ├── domain/               Entities, repository contract, use cases
    │   ├── data/                 Remote and local data sources, models,
    │   │                         repository, name and code generators
    │   └── presentation/         Providers, pages, widgets
    ├── chat/                     Messages, sync, pagination
    │   ├── domain/
    │   ├── data/
    │   └── presentation/
    └── settings/                 Saved theme choice and the theme toggle
        ├── domain/
        ├── data/
        └── presentation/

test/
├── features/                     Sync, outbox, pagination, date and name logic
├── helpers/                      Fake remote and connectivity
└── ui/                           Golden tests for every screen, dark and light
```

## Data flow

Drift is the single source of truth. The UI only ever reads Drift streams, and Firestore only ever writes into Drift. Firestore's own offline cache is disabled so there is one local store.

```
          watch                 upsert
   UI  <---------  Drift  <-----------------  Firestore
   |                 ^                            ^
   |  send           |  insert as pending         |  write with
   +-----------------+----------------------------+  serverTimestamp
```

- **First open:** the newest 30 messages are fetched into Drift.
- **Realtime and catch-up:** a listener runs from the newest stored server timestamp, so it delivers new messages and anything missed while offline. It restarts on reconnect.
- **Pagination:** the Drift query has a growing limit. Scrolling up reveals stored rows first, then fetches older pages from Firestore when the device is online. Local history is always one contiguous range, so gaps can't form.
- **Sending:** a message is stored as `pending` with a client-generated UUID, so it appears immediately, then written to Firestore under that same ID. The listener's copy replaces it with the real server timestamp. Pending messages retry in order on reconnect and when a room opens, and a retry first checks whether the server already has the message.
- **Rejoining:** the code is checked against Drift first, so a known room opens with no network.

Messages sent offline take their server timestamp when they are delivered, so they sort by delivery time, not by when they were typed.

## Firebase Cloud Firestore data structure

```
rooms (collection)
└── {roomCode} (document)
    ├── code: string              6 digits, same as the document ID
    ├── createdAt: timestamp      server timestamp
    ├── createdBy: string         creator's uid
    ├── memberCount: number
    │
    ├── members (subcollection)
    │   └── {uid} (document)
    │       ├── displayName: string    e.g. "Brave Badger"
    │       └── joinedAt: timestamp    server timestamp
    │
    └── messages (subcollection)
        └── {messageId} (document)     client-generated UUID
            ├── text: string           1 to 2000 characters
            ├── senderId: string       sender's uid
            ├── senderName: string     denormalised, avoids a lookup per message
            └── createdAt: timestamp   server timestamp
```

Access is enforced in [firestore.rules](firestore.rules):

- Every request requires authentication.
- Rooms can be fetched by code but never listed, so codes can't be enumerated.
- Only members of a room can read or create its messages.
- Messages must carry the caller's own uid and the server's timestamp, and can't be edited or deleted.
- `memberCount` can only increase by 1, and only together with a new member document.

## Notifications

Notifications are local. While a chat is open and the app is in the background, messages from other members raise a notification, and tapping it opens the room.

This only works for a few seconds after leaving the app. On the Android 15 and 16 emulators tested, the system cuts a background app's network access about 6 seconds after it leaves the screen, so later messages arrive when the app is reopened and raise no notification. Nothing arrives after the OS stops the app either. Reliable delivery would need FCM and a Cloud Function, which requires Firebase's paid Blaze plan.

## Running the project

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

Firebase config for the project is included, so no extra setup is needed.

```bash
flutter test
FLUTTER_ROOT=$(dirname $(dirname $(which flutter))) flutter test test/ui
```

Golden images were generated on macOS. Font rendering varies by platform, so regenerate them with `--update-goldens` when running elsewhere.
