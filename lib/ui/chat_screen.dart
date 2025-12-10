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
  final Map<String, GlobalKey> _messageKeys = {};

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

  void _scrollToMatch(int index) {
    if (index < 0) return;
    final chatProvider = context.read<ChatProvider>();
    final messages = chatProvider.messages;
    if (index >= messages.length) return;

    final targetMsgId = messages[index].id;
    final key = _messageKeys[targetMsgId];

    if (key?.currentContext != null) {
      Scrollable.ensureVisible(
        key!.currentContext!,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        alignment: 0.5, // Center the item
      );
    }
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
              ? Consumer<ChatProvider>(
                  builder: (context, provider, child) {
                    return Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            autofocus: true,
                            decoration: const InputDecoration(
                              hintText: 'Search...',
                              border: InputBorder.none,
                              hintStyle: TextStyle(color: Colors.black54),
                            ),
                            style: const TextStyle(color: Colors.black),
                            onChanged: (val) {
                              provider.searchMessages(val);
                              // Auto-scroll to first match if found
                              if (provider.activeMessageIndex != -1) {
                                WidgetsBinding.instance.addPostFrameCallback((
                                  _,
                                ) {
                                  _scrollToMatch(provider.activeMessageIndex);
                                });
                              }
                            },
                          ),
                        ),
                        if (provider.matchIndices.isNotEmpty) ...[
                          Text(
                            '${provider.currentMatchIndex + 1} of ${provider.matchIndices.length}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.keyboard_arrow_up),
                            onPressed: () {
                              provider.previousMatch();
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                _scrollToMatch(provider.activeMessageIndex);
                              });
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.keyboard_arrow_down),
                            onPressed: () {
                              provider.nextMatch();
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                _scrollToMatch(provider.activeMessageIndex);
                              });
                            },
                          ),
                        ],
                      ],
                    );
                  },
                )
              : const Text('Flutter Chat'),
          actions: [
            if (!_isSearching)
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: _toggleSearch,
              ),
            if (_isSearching)
              IconButton(
                icon: const Icon(Icons.close),
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
                    return const Center(
                      child: Text(
                        'No messages yet',
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }

                  // Reverse the list for display if we want latest at bottom with reverse: true
                  final displayMessages = messages.reversed.toList();

                  return ListView.builder(
                    reverse: true,
                    itemCount: displayMessages.length,
                    itemBuilder: (context, index) {
                      final msg = displayMessages[index];
                      // Assign global key if needed
                      if (!_messageKeys.containsKey(msg.id)) {
                        _messageKeys[msg.id] = GlobalKey();
                      }

                      return MessageBubble(
                        key: _messageKeys[msg.id],
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
