import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/note.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference get _userNotes {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Користувач не авторизований');
    return _firestore.collection('users').doc(user.uid).collection('notes');
  }

  //CREATE
  Future<void> createNote(String title, String content) async {
    final user = _auth.currentUser;
    await _userNotes.add({
      'title': title,
      'content': content,
      'userId': user!.uid,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  //READ 
  Stream<List<Note>> getNotes() {
    return _userNotes
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Note.fromJson(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  //UPD
  Future<void> updateNote(String noteId, String title, String content) async {
    await _userNotes.doc(noteId).update({
      'title': title,
      'content': content,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  //DEL
  Future<void> deleteNote(String noteId) async {
    await _userNotes.doc(noteId).delete();
  }
}