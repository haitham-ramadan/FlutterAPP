import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/message.dart';
import '../services/storage_service.dart';

class ChatProvider extends ChangeNotifier {
  final StorageService _storageService;
  List<Message> _messages = [];
  bool _isLoading = false;
  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  List<int> _matchIndices = [];
  int _currentMatchIndex = -1;

  ChatProvider(this._storageService);

  List<Message> get messages => _messages;

  List<int> get matchIndices => _matchIndices;
  int get currentMatchIndex => _currentMatchIndex;

  // Helper to get the actual message index of the current match
  int get activeMessageIndex {
    if (_currentMatchIndex >= 0 && _currentMatchIndex < _matchIndices.length) {
      return _matchIndices[_currentMatchIndex];
    }
    return -1;
  }

  bool get isLoading => _isLoading;

  Future<void> loadMessages() async {
    _isLoading = true;
    notifyListeners();

    _messages = _storageService.getMessages();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final newMessage = Message(
      id: const Uuid().v4(),
      text: text,
      timestamp: DateTime.now(),
      isUser: true,
    );

    await _storageService.saveMessage(newMessage);
    _messages = _storageService.getMessages();
    notifyListeners();
  }

  Future<void> clearMessages() async {
    await _storageService.clear();
    _messages = [];
    _matchIndices = [];
    _currentMatchIndex = -1;
    _searchQuery = '';
    notifyListeners();
  }

  void searchMessages(String query) {
    _searchQuery = query;
    if (query.trim().isNotEmpty) {
      final terms = query
          .trim()
          .toLowerCase()
          .split(' ')
          .where((t) => t.isNotEmpty)
          .toList();

      // Find matches where ALL terms are present in the message
      for (int i = 0; i < _messages.length; i++) {
        final msgText = _messages[i].text.toLowerCase();

        bool allTermsPresent = true;
        for (final term in terms) {
          if (!msgText.contains(term)) {
            allTermsPresent = false;
            break;
          }
        }

        if (allTermsPresent) {
          _matchIndices.add(i);
        }
      }

      // If matches found, start at the last one (most recent)
      if (_matchIndices.isNotEmpty) {
        _currentMatchIndex = _matchIndices.length - 1;
      }
    }
    notifyListeners();
  }

  void nextMatch() {
    if (_matchIndices.isEmpty) return;
    if (_currentMatchIndex < _matchIndices.length - 1) {
      _currentMatchIndex++;
    } else {
      _currentMatchIndex = 0; // Wrap around
    }
    notifyListeners();
  }

  void previousMatch() {
    if (_matchIndices.isEmpty) return;
    if (_currentMatchIndex > 0) {
      _currentMatchIndex--;
    } else {
      _currentMatchIndex = _matchIndices.length - 1; // Wrap around
    }
    notifyListeners();
  }
}
