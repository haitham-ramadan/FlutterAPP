# Flutter Chat Application

A robust, modular, and aesthetically pleasing chat application built with Flutter. This project demonstrates best practices in clean architecture, state management using Provider, and offline-first data persistence with Hive.

## 🌟 Key Features

### 💬 Core Chat Experience
-   **Real-time Messaging**: Instant message sending and bubble-style display.
-   **Smart Capitalization**: Chat input automatically capitalizes the start of sentences for a fluid typing experience (WhatsApp-style).
-   **Responsive Design**: Optimized for different screen sizes with a clean, modern UI.

### 🔍 Advanced Search
-   **Case-Insensitive Search**: Find messages regardless of capitalization.
-   **Smart Highlighting**: Search terms are dynamically highlighted in yellow within the message list.
-   **Empty State Handling**: Displays a distinct "No results found" message when searching, ensuring clarity without confusing empty search results with an empty chat.

### 💾 Robust Persistence
-   **Local Storage**: Uses **Hive**, a lightweight and blazing fast key-value database, to store messages locally.
-   **Auto-Pruning**: Automatically limits stored messages to the last 20 items to ensure optimal performance and minimal storage footprint.
-   **Crash Safety**: Includes built-in checks to prevent initialization errors during hot restarts.

## 🛠 Tech Stack & Architecture

This project follows the **MVVM (Model-View-ViewModel)** architectural pattern to ensure separation of concerns and testability.

### 📂 Structure
```
lib/
├── models/             # Data definitions (Message)
├── providers/          # State Management (ChatProvider)
├── services/           # Data Layer (StorageService)
└── ui/                 # UI Components (Screens & Widgets)
```

### 🧩 Components
-   **Provider**: Manages app state (messages, search query, loading status) and exposes it to the UI.
-   **Services**: `StorageService` handles all database operations (init, save, fetch, clear), abstracting Hive details from the rest of the app.
-   **UI widgets**: Reusable components like `MessageBubble` and `ChatInput` keep the code modular and clean.

## 🚀 Getting Started

### Prerequisites
-   [Flutter SDK](https://docs.flutter.dev/get-started/install)
-   Dart SDK

### Installation
1.  **Clone the repository**:
    ```bash
    git clone <repository-url>
    ```
2.  **Install dependencies**:
    ```bash
    flutter pub get
    ```
3.  **Run the app**:
    ```bash
    flutter run
    ```

## 🔮 Future Extensions
The codebase is designed to be easily extensible. Here are some planned or possible features:
-   **Audio Messages**: Integrate `flutter_sound` to record and play voice notes.
-   **Image Sharing**: Use `image_picker` to send photos from the gallery.
-   **Backend Integration**: Swap `StorageService` for a remote repository (Firebase, REST API) without rewriting the UI.
