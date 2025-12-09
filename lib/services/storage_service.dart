import 'package:hive_flutter/hive_flutter.dart';
import '../models/message.dart';

class StorageService {
  static const String _boxName = 'chat_messages';

  Future<void> init() async {
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(MessageAdapter());
    }
    await Hive.openBox<Message>(_boxName);
  }

  Box<Message> get _box => Hive.box<Message>(_boxName);

  List<Message> getMessages() {
    final msgs = _box.values.toList();
    msgs.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    // Extra safety protection
    if (msgs.length > 20) {
      return msgs.sublist(msgs.length - 20);
    }

    return msgs;
  }

  Future<void> saveMessage(Message message) async {
    await _box.add(message);
    await _enforceLimit();
  }

  /// Keep only the last 20 messages
  Future<void> _enforceLimit() async {
    if (_box.length > 20) {
      // Sort keys to find oldest?
      // Hive keys are usually auto-incrementing int if not specified,
      // or we can just rely on values. But deleting by index is safest if we know order.
      // _box.values is iterable.
      // Simplest:
      // Get all, sort, keep last 20, clear box, re-add? No, expensive.
      // Better: Delete first (oldest) items until length <= 20.
      // Assuming insertion order preserved.

      while (_box.length > 20) {
        await _box.deleteAt(0);
      }
    }
  }

  Future<void> clear() async {
    await _box.clear();
  }
}
