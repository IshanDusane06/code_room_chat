import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/room_model.dart';

class RoomCodeTakenException implements Exception {
  const RoomCodeTakenException();
}

abstract interface class RoomRemoteDataSource {
  Future<String> ensureSignedIn();
  Future<RoomModel?> fetchRoom(String code);
  Future<String?> fetchMemberName(String code, String uid);
  Future<Set<String>> fetchMemberNames(String code);
  Future<void> createRoom({
    required String code,
    required String uid,
    required String displayName,
  });
  Future<void> addMember({
    required String code,
    required String uid,
    required String displayName,
  });
  Stream<RoomModel> watchRoom(String code);
}

class FirestoreRoomRemoteDataSource implements RoomRemoteDataSource {
  FirestoreRoomRemoteDataSource(this._firestore, this._auth);

  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  DocumentReference<Map<String, dynamic>> _room(String code) =>
      _firestore.collection('rooms').doc(code);

  DocumentReference<Map<String, dynamic>> _member(String code, String uid) =>
      _room(code).collection('members').doc(uid);

  @override
  Future<String> ensureSignedIn() async {
    final current = _auth.currentUser;
    if (current != null) return current.uid;
    final credential = await _auth.signInAnonymously();
    return credential.user!.uid;
  }

  @override
  Future<RoomModel?> fetchRoom(String code) async {
    final snapshot = await _room(code).get();
    return snapshot.exists ? _toModel(snapshot) : null;
  }

  @override
  Future<String?> fetchMemberName(String code, String uid) async {
    final snapshot = await _member(code, uid).get();
    return snapshot.data()?['displayName'] as String?;
  }

  @override
  Future<Set<String>> fetchMemberNames(String code) async {
    final snapshot = await _room(code).collection('members').get();
    return {
      for (final doc in snapshot.docs) doc.data()['displayName'] as String,
    };
  }

  @override
  Future<void> createRoom({
    required String code,
    required String uid,
    required String displayName,
  }) => _firestore.runTransaction((transaction) async {
    final room = _room(code);
    final snapshot = await transaction.get(room);
    if (snapshot.exists) throw const RoomCodeTakenException();
    transaction.set(room, {
      'code': code,
      'createdAt': FieldValue.serverTimestamp(),
      'createdBy': uid,
      'memberCount': 1,
    });
    transaction.set(_member(code, uid), _memberData(displayName));
  });

  @override
  Future<void> addMember({
    required String code,
    required String uid,
    required String displayName,
  }) => _firestore.runTransaction((transaction) async {
    final member = _member(code, uid);
    final snapshot = await transaction.get(member);
    if (snapshot.exists) return;
    transaction.set(member, _memberData(displayName));
    transaction.update(_room(code), {'memberCount': FieldValue.increment(1)});
  });

  @override
  Stream<RoomModel> watchRoom(String code) => _room(code)
      .snapshots()
      .where(
        (snapshot) => snapshot.exists && !snapshot.metadata.hasPendingWrites,
      )
      .map(_toModel);

  Map<String, dynamic> _memberData(String displayName) => {
    'displayName': displayName,
    'joinedAt': FieldValue.serverTimestamp(),
  };

  RoomModel _toModel(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    return RoomModel(
      code: snapshot.id,
      memberCount: data['memberCount'] as int,
      createdAtMicros:
          (data['createdAt'] as Timestamp?)?.microsecondsSinceEpoch,
    );
  }
}
