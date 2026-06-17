import 'package:cloud_firestore/cloud_firestore.dart';

class SocialRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Generic method to toggle like on any document
  Future<void> toggleLike({
    required String collection,
    required String docId,
    required String currentUserId,
  }) async {
    final docRef = _db.collection(collection).doc(docId);
    
    await _db.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);
      if (!snapshot.exists) {
        // Create document if it doesn't exist
        transaction.set(docRef, {
          'likes': 1,
          'likedBy': [currentUserId]
        });
        return;
      }
      
      final data = snapshot.data() as Map<String, dynamic>;
      final likedBy = List<String>.from(data['likedBy'] ?? []);
      int currentLikes = data['likes'] ?? 0;
      
      if (likedBy.contains(currentUserId)) {
        likedBy.remove(currentUserId);
        currentLikes--;
      } else {
        likedBy.add(currentUserId);
        currentLikes++;
      }
      
      transaction.update(docRef, {
        'likes': currentLikes,
        'likedBy': likedBy,
      });
    });
  }

  // Get stream of metadata (likes and likedBy)
  Stream<DocumentSnapshot> getMetadataStream(String collection, String docId) {
    return _db.collection(collection).doc(docId).snapshots();
  }

  // Comments
  Future<void> addComment({
    required String collection,
    required String docId,
    required String text,
    required String currentUserId,
  }) async {
    await _db.collection(collection).doc(docId).collection('comments').add({
      'userId': currentUserId,
      'text': text,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot> getCommentsStream(String collection, String docId) {
    return _db
        .collection(collection)
        .doc(docId)
        .collection('comments')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}
