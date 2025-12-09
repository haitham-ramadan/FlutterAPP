# Changelog

All notable changes to this project will be documented in this file.

## [1.0.0] - 2025-12-10

### Added
-   **Smart Text Input**: Enabled `TextCapitalization.sentences` in the chat input field for automatic sentence capitalization.
-   **Enhanced Search Logic**: Implemented case-insensitive partial matching (using `.contains()` on lowercased text) for more natural search results.
-   **Improved Search UI**: Added a dedicated "No results found" state to distinguish between empty search results and an empty conversation.
-   **Clear Chat**: Added functionality to clear all messages from local storage.

### Changed
-   **Storage Pruning**: Optimized `StorageService` to strictly enforce a 20-message limit, ensuring performance stability.
-   **Error Handling**: Added robust initialization checks in `StorageService` to prevent Hive "Adapter already registered" crashes during hot restarts.

## [0.1.0] - 2025-12-09

### Added
-   **Initial Release**: Core skeleton of the Flutter Chat Application.
-   **Local Storage**: Integrated Hive for offline message persistence.
-   **UI**: Basic chat screen with message bubbles and input field.
-   **Architecture**: Established MVVM pattern with Provider and Services.
