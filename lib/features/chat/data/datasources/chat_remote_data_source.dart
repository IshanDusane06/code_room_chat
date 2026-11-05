import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/message.dart';
import '../models/message_model.dart';

abstract interface class ChatRemoteDataSource {
  Future<List<MessageModel>> fetchLatest(String roomCode, int limit);
  Future<List<MessageModel>> fetchUpTo(
    String roomCode,
    int beforeMicros,
    int limit,
  );
  Future<MessageModel?> fetchMessage(String roomCode, String id);
  Future<void> send(Message message);
  Stream<List<MessageModel>> watchFrom(String roomCode, int? fromMicros);
}

class FirestoreChatRemoteDataSource implements ChatRemoteDataSource {
  const FirestoreChatRemoteDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _messages(String roomCode) =>
      _firestore.collection('rooms').doc(roomCode).collection('messages');

  @override
  Future<List<MessageModel>> fetchLatest(String roomCode, int limit) async {
    final snapshot = await _messages(roomCode)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .get(const GetOptions(source: Source.server));
    return snapshot.docs.map((doc) => _toModel(roomCode, doc)).toList();
  }

  @override
  Future<List<MessageModel>> fetchUpTo(
    String roomCode,
    int beforeMicros,
    int limit,
  ) async {
    final snapshot = await _messages(roomCode)
        .where(
          'createdAt',
          isLessThanOrEqualTo: Timestamp.fromMicrosecondsSinceEpoch(
            beforeMicros,
          ),
        )
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .get(const GetOptions(source: Source.server));
    return snapshot.docs.map((doc) => _toModel(roomCode, doc)).toList();
  }

  @override
  Future<MessageModel?> fetchMessage(String roomCode, String id) async {
    final snapshot = await _messages(
      roomCode,
    ).doc(id).get(const GetOptions(source: Source.server));
    return snapshot.exists ? _toModel(roomCode, snapshot) : null;
  }

  @override
  Future<void> send(Message message) =>
      _messages(message.roomCode).doc(message.id).set({
        'text': message.text,
        'senderId': message.senderId,
        'senderName': message.senderName,
        'createdAt': FieldValue.serverTimestamp(),
      });

  @override
  Stream<List<MessageModel>> watchFrom(String roomCode, int? fromMicros) {
    final start = Timestamp.fromMicrosecondsSinceEpoch(fromMicros ?? 0);
    return _messages(roomCode)
        .where('createdAt', isGreaterThanOrEqualTo: start)
        .orderBy('createdAt')
        .snapshots(includeMetadataChanges: true)
        .map(
          (snapshot) => [
            for (final change in snapshot.docChanges)
              if (change.type != DocumentChangeType.removed &&
                  !change.doc.metadata.hasPendingWrites)
                _toModel(roomCode, change.doc),
          ],
        )
        .where((models) => models.isNotEmpty);
  }

  MessageModel _toModel(
    String roomCode,
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;
    return MessageModel(
      id: doc.id,
      roomCode: roomCode,
      senderId: data['senderId'] as String,
      senderName: data['senderName'] as String,
      text: data['text'] as String,
      createdAtMicros: (data['createdAt'] as Timestamp).microsecondsSinceEpoch,
    );
  }
}
