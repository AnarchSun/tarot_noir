import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/journal_entry.dart';
import '../models/tarot_card.dart';
import '../models/tarot_deck.dart';

class FirestoreSyncService {
  FirestoreSyncService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Future<List<JournalEntry>> synchronizeJournal({
    required User user,
    required Iterable<JournalEntry> localJournal,
    required Iterable<String> deletedEntryIds,
  }) async {
    final userReference = _firestore.collection('users').doc(user.uid);
    final journalReference = userReference.collection('journal');
    final remoteJournal = await _readJournal(journalReference, user.uid);
    final deletedIds = deletedEntryIds.toSet();
    final mergedJournal = <String, JournalEntry>{
      for (final entry in remoteJournal)
        if (!deletedIds.contains(entry.syncId))
          entry.syncId: entry.copyWith(syncOwnerUid: user.uid),
      for (final entry in localJournal)
        if (!deletedIds.contains(entry.syncId) && entry.canSyncTo(user.uid))
          entry.syncId: entry.copyWith(syncOwnerUid: user.uid),
    };

    var batch = _firestore.batch();
    var batchSize = 0;
    for (final id in deletedIds) {
      batch.delete(journalReference.doc(id));
      batchSize++;
      if (batchSize == 450) {
        await batch.commit();
        batch = _firestore.batch();
        batchSize = 0;
      }
    }
    for (final entry in mergedJournal.values) {
      batch.set(journalReference.doc(entry.syncId), _toFirestore(entry));
      batchSize++;
      if (batchSize == 450) {
        await batch.commit();
        batch = _firestore.batch();
        batchSize = 0;
      }
    }
    if (batchSize > 0) await batch.commit();

    final result = mergedJournal.values.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return result;
  }

  Future<List<JournalEntry>> _readJournal(
    CollectionReference<Map<String, dynamic>> collection,
    String userUid,
  ) async {
    final entries = <JournalEntry>[];
    Query<Map<String, dynamic>> query = collection
        .orderBy('createdAt')
        .limit(400);
    while (true) {
      final snapshot = await query.get();
      entries.addAll(
        snapshot.docs.map((document) => _fromFirestore(document, userUid)),
      );
      if (snapshot.docs.length < 400) break;
      query = collection
          .orderBy('createdAt')
          .startAfterDocument(snapshot.docs.last)
          .limit(400);
    }
    return entries;
  }

  Map<String, Object?> _toFirestore(JournalEntry entry) => {
    'cardId': entry.card.id,
    'createdAt': Timestamp.fromDate(entry.createdAt.toUtc()),
    'orientation': entry.orientation.name,
    'drawType': entry.drawType,
    if (entry.note != null) 'note': entry.note,
    if (entry.mood != null) 'mood': entry.mood,
  };

  JournalEntry _fromFirestore(
    QueryDocumentSnapshot<Map<String, dynamic>> document,
    String userUid,
  ) {
    final data = document.data();
    final cardId = data['cardId'];
    final createdAt = data['createdAt'];
    final orientation = data['orientation'];
    final drawType = data['drawType'];
    final note = data['note'];
    final mood = data['mood'];

    if (cardId is! String ||
        createdAt is! Timestamp ||
        orientation is! String ||
        drawType is! String ||
        (note != null && note is! String) ||
        (mood != null && mood is! int)) {
      throw FormatException('Invalid Firestore journal entry ${document.id}.');
    }
    final TarotCard? card = _cardForId(cardId);
    if (card == null) {
      throw FormatException(
        'Firestore journal entry ${document.id} refers to an unknown card.',
      );
    }
    if (orientation != CardOrientation.upright.name &&
        orientation != CardOrientation.reversed.name) {
      throw FormatException(
        'Firestore journal entry ${document.id} has an invalid orientation.',
      );
    }
    if (drawType != 'daily' && drawType != 'free') {
      throw FormatException(
        'Firestore journal entry ${document.id} has an invalid draw type.',
      );
    }

    return JournalEntry(
      card: card,
      createdAt: createdAt.toDate(),
      orientation: CardOrientation.fromStorage(orientation),
      drawType: drawType,
      note: note as String?,
      mood: mood as int?,
      syncOwnerUid: userUid,
    );
  }

  TarotCard? _cardForId(String id) {
    for (final card in tarotDeck) {
      if (card.id == id) return card;
    }
    return null;
  }
}
