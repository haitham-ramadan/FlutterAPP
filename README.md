# Flutter Chat Application

A clean, modular, and extensible Flutter chat application designed for easy maintenance and future expansion. This project demonstrates clean architecture principles, local data persistence using Hive, and a polished user interface.

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Getting Started](#getting-started)
- [Project Structure](#project-structure)
- [Architecture](#architecture)
- [Key Components](#key-components)
- [Extension Guide](#extension-guide)

## Overview

This application serves as a robust foundational template for a modern chat application. It provides a complete UI without backend dependencies, simulating a real-world experience through local persistence and thoughtful state management.

## Features

-   **Modern Chat UI**: Bubble-style messages, smooth scrolling, and responsive design.
-   **Robust Local Persistence**: Uses **Hive** for fast, offline-first message storage.
-   **Stability & Safety**:
    -   Prevents crashes from double-initialization of Hive adapters.
    -   Automatically limits storage to the last 20 messages to ensure performance.
-   **Advanced Search**:
    -   Local message search with **dynamic text highlighting**.
    -   Smart navigation (Back button closes search first).
-   **Clean Architecture**: Strict separation of UI, Business Logic (Providers), and Data (Services).

## Getting Started

### Prerequisites

-   Flutter SDK (Latest Stable)
-   Dart SDK

### Installation

1.  **Clone the repository**:
    ```bash
    git clone <repository-url>
    cd flutter_application_1
    ```

2.  **Install dependencies**:
    ```bash
    flutter pub get
    ```

3.  **Run the application**:
    ```bash
    flutter run
    ```

## Project Structure

The project follows a feature-first organization within the `lib/` directory:

```
lib/
├── models/             # Data models (PODOs)
│   └── message.dart    # Hive-annotated Message model
├── providers/          # State Management
│   └── chat_provider.dart # ViewModel managing chat state and business logic
├── services/           # Data Layer
│   └── storage_service.dart # Abstraction for Hive storage operations
├── ui/                 # Presentation Layer
│   ├── widgets/        # Reusable components
│   │   ├── chat_input.dart     # Message input bar
│   │   └── message_bubble.dart # Individual chat bubble
│   └── chat_screen.dart # Primary chat interface
└── main.dart           # Application entry point
```

## Architecture

This project implements the **MVVM (Model-View-ViewModel)** pattern using the `Provider` package.

### 1. Data Layer (Model & Services)
-   **`Message` Model**: Defines the data structure. It uses `HiveType` annotations for efficient binary serialization.
-   **`StorageService`**: A dedicated service class that handles all database interactions. It abstracts the underlying Hive box implementation, making it easy to mock for testing or swap for another database (like SQLite) in the future.

### 2. ViewModel Layer (Provider)
-   **`ChatProvider`**: Bridges the gap between the UI and the Data Layer.
    -   Manages the list of messages and the current search query.
    -   Exposes simple methods like `sendMessage()` and `clearMessages()`.
    -   Handles loading states (`isLoading`).

### 3. View Layer (UI)
-   **Reactive UI**: Widgets use `Consumer<ChatProvider>` to rebuild only when necessary.
-   **Separation of Concerns**: The UI contains no business logic, only display logic.

## Key Components

### Search System
The app features a dynamic search system:
-   **State**: The search query is held in the `ChatProvider`.
-   **Visuals**: The `MessageBubble` widget listens to the query and uses `RichText` to highlight matching substrings in real-time.
-   **UX**: The `PopScope` widget in `ChatScreen` ensures that pressing the system back button closes the search bar before exiting the app.

### Safety Protocols
To ensure a crash-free experience:
-   **Initialization**: `StorageService.init()` includes checks (`!Hive.isAdapterRegistered`) to prevent runtime errors during hot restarts.
-   **Data Integerity**: `StorageService.getMessages()` enforces a strict limit (last 20 messages) to prevent memory bloat over time.

## Extension Guide

### Implementing Audio Messages
1.  **Dependency**: Add `flutter_sound` or `record` to `pubspec.yaml`.
2.  **Model**: Update `Message` to include a `String? audioPath` and `MessageType type` enum.
3.  **UI**: In `ChatInput`, wire up the Mic button to record to a temporary file.
4.  **Display**: In `MessageBubble`, check the message type and render a playback widget if it's audio.

### Implementing Image Support
1.  **Dependency**: Add `image_picker`.
2.  **Model**: Update `Message` to include `String? imagePath`.
3.  **UI**: In `ChatInput`, wire up the Image button to pick from gallery.
4.  **Display**: In `MessageBubble`, render `Image.file(File(path))` if an image path is present.

### Backend Integration
To switch from local storage to a live backend (e.g., Firebase, WebSocket):
1.  Create a `backend_service.dart` or standard `repository`.
2.  Update `ChatProvider` to call this new service instead of `StorageService`.
3.  The UI will remain completely unchanged, demonstrating the power of the architecture.
