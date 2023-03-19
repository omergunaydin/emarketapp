import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emarketapp/models/message.dart';

class MessageApiClient {
  final CollectionReference _messagesRef = FirebaseFirestore.instance.collection('messages');

  Future addMessage(Message message) async {
    await _messagesRef.add(message.toJson());
  }
}
