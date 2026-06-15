import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StorageService {
  final FirebaseStorage storage = FirebaseStorage.instance;

  Future<String> uploadImageWithProgress(
    File imageFile,
    String noteId,
    Function(double) onProgress,
  ) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not logged in');

      final fileName = 'image_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final ref = storage.ref().child('users/${user.uid}/notes/$noteId/$fileName');

      final metadata = SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {
          'userId': user.uid,
          'noteId': noteId,
        },
      );

      final uploadTask = ref.putFile(imageFile, metadata);

      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        final progress = snapshot.bytesTransferred / snapshot.totalBytes;
        onProgress(progress);
      });

      await uploadTask;
      return await ref.getDownloadURL();
    } on FirebaseException catch (e) {
      throw Exception('Upload failed: ${e.message}');
    }
  }

  Future<void> deleteImage(String imageUrl) async {
    try {
      final ref = storage.refFromURL(imageUrl);
      await ref.delete();
    } catch (e) {
      print('Error deleting image: $e'); 
    }
  }
}