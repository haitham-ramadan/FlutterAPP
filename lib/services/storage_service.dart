import 'package:hive_flutter/hive_flutter.dart';
import '../models/message.dart';



class StorageService {
static const String _boxName = 'chat_messages';



Future<void> init() async {
try {
await Hive.initFlutter();



// Register adapter only once to avoid "Adapter already registered" crash
if (!Hive.isAdapterRegistered(0)) {
Hive.registerAdapter(MessageAdapter());
}



await Hive.openBox<Message>(_boxName);
} catch (e) {
// Optional: add logging here if needed
// e.g. print('Hive init error: $e');
}
}



Box<Message> get _box => Hive.box<Message>(_boxName);



List<Message> getMessages() {
final msgs = _box.values.toList();
msgs.sort((a, b) => a.timestamp.compareTo(b.timestamp));



// Extra safety: always limit to last 20 messages
if (msgs.length > 20) {
return msgs.sublist(msgs.length - 20);
}
return msgs;
}



Future<void> saveMessage(Message message) async {
await _box.add(message);
await _enforceLimit();
}



/// Keep only the last 20 messages in the box
Future<void> _enforceLimit() async {
while (_box.length > 20) {
await _box.deleteAt(0);
}
}



Future<void> clear() async {
await _box.clear();
}
}
