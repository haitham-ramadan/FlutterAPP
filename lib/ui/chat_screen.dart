import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/chat_provider.dart';
import 'widgets/chat_input.dart';
import 'widgets/message_bubble.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool _isSearching = false;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load messages on start
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatProvider>().loadMessages();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        context.read<ChatProvider>().searchMessages('');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_isSearching,
      onPopInvokedWithResult: (bool didPop, dynamic result) async {
        if (didPop) return;
        _toggleSearch();
      },
      child: Scaffold(
        appBar: AppBar(
          title: _isSearching
              ? TextField(
                  controller: _searchController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: 'Search messages...',
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.black54),
                  ),
                  style: const TextStyle(color: Colors.black),
                  onChanged: (val) {
                    context.read<ChatProvider>().searchMessages(val);
                  },
                )
              : const Text('Flutter Chat'),
          actions: [
            IconButton(
              icon: Icon(_isSearching ? Icons.close : Icons.search),
              onPressed: _toggleSearch,
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: Consumer<ChatProvider>(
                builder: (context, chatProvider, child) {
                  if (chatProvider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final messages = chatProvider.messages;
                  final searchQuery = chatProvider.searchQuery;

                  if (messages.isEmpty) {
                    if (searchQuery.isNotEmpty) {
                      return const Center(
                        child: Text(
                          'No results found',
                          style: TextStyle(color: Colors.grey),
                        ),
                      );
                    }
                    return const Center(
                      child: Text(
                        'No messages yet',
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }

                  // Reverse the list for display if we want latest at bottom with reverse: true
                  // But let's just use standard ListView with latest at bottom.
                  // Actually, efficient chat lists use reverse: true so that when keyboard opens,
                  // it stays at bottom.
                  // If we use reverse: true, index 0 is the bottom-most item.
                  // So we need the list to be [Newest, ..., Oldest].
                  // Provider gives [Oldest, ..., Newest].
                  final displayMessages = messages.reversed.toList();

                  return ListView.builder(
                    reverse: true,
                    itemCount: displayMessages.length,
                    itemBuilder: (context, index) {
                      final msg = displayMessages[index];
                      return MessageBubble(
                        message: msg,
                        highlightText: searchQuery,
                      );
                    },
                  );
                },
              ),
            ),
            const ChatInput(),
          ],
        ),
      ),
    );
  }
}
