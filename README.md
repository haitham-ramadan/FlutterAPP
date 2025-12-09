# Flutter Chat Application

A clean, modular, and extensible Flutter chat application designed for easy maintenance and future expansion. This project demonstrates clean architecture principles, local data persistence, and a polished user interface.

## Table of Contents

- [Features](#features)
- [Getting Started](#getting-started)
- [Project Structure](#project-structure)
- [Architecture](#architecture)
- [Key Components](#key-components)
- [Extension Guide](#extension-guide)
- [Future Improvements](#future-improvements)

## Features

-   **Modern Chat UI**: Bubble-style messages, smooth scrolling, and dynamic layout.
-   **Local Persistence**: Stores the last 20 messages using clean storage abstractions (currently implemented with `SharedPreferences` via a placeholder service, easy to swap for Hive/SQLite).
-   **Search Functionality**: Local message search with **text highlighting** and dynamic filtering.
-   **Optimized UX**: "Back" button handling during search, timestamp formatting, and responsive design.

## Getting Started

### Prerequisites

-   Flutter SDK (Latest Stable)
-   Dart SDK

### Installation

1.  **Clone the repository** (or unzip the project folder).
2.  **Install dependencies**:
    ```bash
    flutter pub get
    ```
3.  **Run the application**:
    ```bash
    flutter run
    ```

## Project Structure

The project follows a feature-first or layer-first organization within `lib/`:

```
lib/
├── models/             # Data models (PODOs)
│   └── message.dart    # Message data structure
├── providers/          # State Management (ChangeNotifier)
│   └── chat_provider.dart # Business logic for chat operations
├── services/           # Data Services (Storage, API - optional)
│   └── storage_service.dart # Interface and implementation for local storage
├── ui/                 # UI Layer
│   ├── widgets/        # Reusable UI components
│   │   ├── chat_input.dart     # Input field, mic, image buttons
│   │   └── message_bubble.dart # Message bubble widget
│   └── chat_screen.dart # Main chat screen
└── main.dart           # App entry point and Provider setup
```

## Architecture

This app uses **MVVM (Model-View-ViewModel)** style architecture with **Provider** for state management.

1.  **Docs/UI (View)**: `ChatScreen` and widgets observe the `ChatProvider`.
2.  **Provider (ViewModel)**: `ChatProvider` holds the state (list of messages, search query, loading status) and exposes methods to modify it (`sendMessage`, `loadMessages`, `searchMessages`).
3.  **Services (Model/Data)**: `StorageService` handles the raw data persistence. This separation ensures the UI doesn't know *how* data is stored, only *that* it is stored.

## Key Components

### ChatProvider (`lib/providers/chat_provider.dart`)
Central hub for app state.
-   `messages`: Returns the list of messages. If a search query is active, it returns the filtered list.
-   `sendMessage(String text)`: Creates a message object, saves it via storage service, and updates state.
-   `searchQuery`: Exposed to allow UI to highlight matching text.

### MessageBubble (`lib/ui/widgets/message_bubble.dart`)
Renders a single message.
-   **Text Highlighting**: Internally handles `RichText` creation to highlight parts of the message that match the current search query.
-   **Dynamic Styling**: Adjusts color and alignment based on whether the message is from the user or another party.

### StorageService (`lib/services/storage_service.dart`)
Abstracts the storage logic. Currently, it saves/retrieves a list of 20 messages.
*Note: This is set up to easily swap the underlying implementation (e.g., to SQLite) without breaking the rest of the app.*

## Extension Guide

Here is how you can extend the application functionality:

### 1. Implement Audio Recording
**Location**: `lib/ui/widgets/chat_input.dart`
**Goal**: Logic for the Mic button.
-   Inside the `IconButton` for `Icons.mic`:
    -   Integrate a package like `flutter_sound` or `record`.
    -   On press, start recording. On release/stop, save the file.
-   **Model Update**: Update `Message` model to support `MessageType.audio` and a `filePath`.
-   **UI Update**: Update `MessageBubble` to render an audio player if type is audio.

### 2. Implement Image Sharing
**Location**: `lib/ui/widgets/chat_input.dart`
**Goal**: Logic for the Image button.
-   Inside the `IconButton` for `Icons.image`:
    -   Use `image_picker` package to select an image.
-   **Model Update**: Update `Message` model to support `MessageType.image` and `imagePath`.
-   **UI Update**: Update `MessageBubble` to render `Image.file(...)`.

### 3. Switch to SQLite/Hive
**Location**: `lib/services/storage_service.dart`
-   Replace the `SharedPreferences` logic with `sqflite` or `hive`.
-   Keep the public methods (`saveMessage`, `getMessages`) the same signature.
-   The `ChatProvider` will not need any changes, demonstrating the power of this architecture.

## Future Improvements

-   **Pagination**: Load older messages as the user scrolls up (Lazy Loading).
-   **Theming**: Add Dark Mode toggle via a `ThemeProvider`.
-   **Backend**: Connect `ChatProvider` to a real backend (Firebase/Socket.io) instead of just local storage.

---
