import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/note.dart';

class FirestoreService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  CollectionReference get userNotes {
    final user = auth.currentUser;
    if (user == null) throw Exception('Користувач не авторизований');
    return firestore.collection('users').doc(user.uid).collection('notes');
  }

  // CREATE
  Future<void> createNote(String title, String content, [String? imageUrl]) async {
    final user = auth.currentUser;
    await userNotes.add({
      'title': title,
      'content': content,
      'imageUrl': imageUrl, 
      'userId': user!.uid,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // READ 
  Stream<List<Note>> getNotes() {
    return userNotes
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Note.fromJson(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  // UPD
  Future<void> updateNote(String noteId, String title, String content, [String? imageUrl]) async {
    await userNotes.doc(noteId).update({
      'title': title,
      'content': content,
      'imageUrl': imageUrl, 
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // DEL
  Future<void> deleteNote(String noteId) async {
    await userNotes.doc(noteId).delete();
  }
}