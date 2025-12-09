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

  ChatProvider(this._storageService);

  List<Message> get messages {
    if (_searchQuery.isEmpty) {
      return _messages;
    }
    return _messages
        .where((m) => m.text.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  bool get isLoading => _isLoading;

  Future<void> loadMessages() async {
    _isLoading = true;
    notifyListeners();

    // Simulate slight delay if needed, or just fetch
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
      isUser: true, // Assuming all sent by user for this demo
    );

    await _storageService.saveMessage(newMessage);
    _messages = _storageService.getMessages(); // Reload to get sorted/limited
    notifyListeners();
  }

  void searchMessages(String query) {
    _searchQuery = query;
    notifyListeners();
  }
}
