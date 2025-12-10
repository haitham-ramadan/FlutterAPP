import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/message.dart';

class MessageBubble extends StatelessWidget {
  final Message message;
  final String highlightText;

  const MessageBubble({
    super.key,
    required this.message,
    this.highlightText = '',
  });

  @override
  Widget build(BuildContext context) {
    final isMe = message.isUser;
    final timeStr = DateFormat('h:mm a').format(message.timestamp);
    final text = message.text;

    List<InlineSpan> buildTextSpans() {
      if (highlightText.trim().isEmpty) {
        return [
          TextSpan(
            text: text,
            style: TextStyle(
              color: isMe ? Colors.white : Colors.black87,
              fontSize: 16,
            ),
          ),
        ];
      }

      final terms = highlightText
          .trim()
          .toLowerCase()
          .split(' ')
          .where((t) => t.isNotEmpty)
          .toSet() // Use set to avoid duplicate checks for same word
          .toList();

      if (terms.isEmpty) {
        return [
          TextSpan(
            text: text,
            style: TextStyle(
              color: isMe ? Colors.white : Colors.black87,
              fontSize: 16,
            ),
          ),
        ];
      }

      final lowerText = text.toLowerCase();
      final List<TextSpan> spans = [];
      int currentIndex = 0;

      // We need to find all matches for all terms and sort them by position
      // Simple approach: Create a boolean mask or just find the "next earliest match" iteratively
      // Iterative approach: find the earliest occurrence of ANY term after currentIndex

      while (currentIndex < text.length) {
        int bestMatchIndex = -1;
        String bestTerm = '';

        // Find the earliest matching term from current position
        for (final term in terms) {
          final index = lowerText.indexOf(term, currentIndex);
          if (index != -1) {
            if (bestMatchIndex == -1 || index < bestMatchIndex) {
              bestMatchIndex = index;
              bestTerm = term;
            } else if (index == bestMatchIndex &&
                term.length > bestTerm.length) {
              // Prefer longer matches if they start at same position (e.g. "hello" vs "he")
              bestTerm = term;
            }
          }
        }

        if (bestMatchIndex != -1) {
          // Add text before match
          if (bestMatchIndex > currentIndex) {
            spans.add(
              TextSpan(
                text: text.substring(currentIndex, bestMatchIndex),
                style: TextStyle(
                  color: isMe ? Colors.white : Colors.black87,
                  fontSize: 16,
                ),
              ),
            );
          }

          // Add highlighted match
          spans.add(
            TextSpan(
              text: text.substring(
                bestMatchIndex,
                bestMatchIndex + bestTerm.length,
              ),
              style: TextStyle(
                color: isMe
                    ? Colors.black87
                    : Colors.black, // Ensure visibility
                backgroundColor: Colors.yellow,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          );

          currentIndex = bestMatchIndex + bestTerm.length;
        } else {
          // No more matches
          spans.add(
            TextSpan(
              text: text.substring(currentIndex),
              style: TextStyle(
                color: isMe ? Colors.white : Colors.black87,
                fontSize: 16,
              ),
            ),
          );
          break;
        }
      }

      return spans;
    }

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        decoration: BoxDecoration(
          color: isMe ? Colors.blueAccent : Colors.grey[300],
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(12),
            topRight: const Radius.circular(12),
            bottomLeft: isMe ? const Radius.circular(12) : Radius.zero,
            bottomRight: isMe ? Radius.zero : const Radius.circular(12),
          ),
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            RichText(text: TextSpan(children: buildTextSpans())),
            const SizedBox(height: 4),
            Text(
              timeStr,
              style: TextStyle(
                color: isMe ? Colors.white70 : Colors.black54,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
