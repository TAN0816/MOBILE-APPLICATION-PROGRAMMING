// search_history_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SearchHistoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<List<String>> getSearchHistory() async {
    User? user = _auth.currentUser;
    if (user == null) return [];

    DocumentSnapshot<Map<String, dynamic>> doc = await _firestore.collection('users').doc(user.uid).get();
    List<String>? history = (doc.data()?['searchHistory'] as List<dynamic>?)?.map((item) => item as String).toList();
    return history ?? [];
  }

  Future<void> addSearchQuery(String query) async {
    User? user = _auth.currentUser;
    if (user == null) return;

    DocumentReference<Map<String, dynamic>> docRef = _firestore.collection('users').doc(user.uid);
    DocumentSnapshot<Map<String, dynamic>> doc = await docRef.get();
    List<String> history = (doc.data()?['searchHistory'] as List<dynamic>?)?.map((item) => item as String).toList() ?? [];

    history.remove(query); // Remove existing query to avoid duplicates
    history.insert(0, query); // Add query to the beginning

    await docRef.set({'searchHistory': history}, SetOptions(merge: true));
  }
}
