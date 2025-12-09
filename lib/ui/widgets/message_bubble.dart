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

    List<InlineSpan> _buildTextSpans() {
      if (highlightText.isEmpty) {
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

      final spans = <InlineSpan>[];
      final lowerText = text.toLowerCase();
      final lowerHighlight = highlightText.toLowerCase();
      int start = 0;
      int indexOfHighlight;

      while ((indexOfHighlight = lowerText.indexOf(lowerHighlight, start)) !=
          -1) {
        if (indexOfHighlight > start) {
          spans.add(
            TextSpan(
              text: text.substring(start, indexOfHighlight),
              style: TextStyle(
                color: isMe ? Colors.white : Colors.black87,
                fontSize: 16,
              ),
            ),
          );
        }

        spans.add(
          TextSpan(
            text: text.substring(
              indexOfHighlight,
              indexOfHighlight + lowerHighlight.length,
            ),
            style: TextStyle(
              color: isMe ? Colors.black87 : Colors.black, // Ensure visibility
              backgroundColor: Colors.yellow,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        );

        start = indexOfHighlight + lowerHighlight.length;
      }

      if (start < text.length) {
        spans.add(
          TextSpan(
            text: text.substring(start),
            style: TextStyle(
              color: isMe ? Colors.white : Colors.black87,
              fontSize: 16,
            ),
          ),
        );
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
            RichText(text: TextSpan(children: _buildTextSpans())),
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
