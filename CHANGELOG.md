# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]

### Fixed
-   **Hive Crash on Restart**: Added a guard clause `!Hive.isAdapterRegistered(0)` in `StorageService.init()` to prevent `Adapter already registered` errors when re-initializing the app (e.g., during development hot restarts).
-   **Crash Prevention**: Modified `getMessages()` to strictly return the last 20 messages using `sublist`. This prevents potential UI overflow or memory issues if the local database grows unexpectedly.

### Added
-   **Clear Chat**: A new `clearMessages()` method in `ChatProvider` to wipe conversation history.
-   **Search Highlighting**: Search terms are now visually highlighted in yellow within message bubbles.
-   **Search UX**: Pressing the physical/system back button while searching now closes the search bar instead of minimising the app.

## [0.1.0] - 2025-12-09

### Added
-   **Initial Release**: Core chat functionality.
-   **Local Storage**: Implementation of Hive for message persistence.
-   **UI**: Bubble-style chat interface, input field, and search toggle.
-   **Architecture**: MVVM structure with Provider, Services, and UI separation.
