import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/note.dart';
import '../services/firestore_service.dart';
import '../services/storage_service.dart';

class NotesScreen extends StatefulWidget {
  @override
  NotesScreenState createState() => NotesScreenState();
}

class NotesScreenState extends State<NotesScreen> {
  final FirestoreService firestoreService = FirestoreService();
  final StorageService storageService = StorageService();

  void showNoteDialog({Note? note}) {
    final titleController = TextEditingController(text: note?.title ?? '');
    final contentController = TextEditingController(text: note?.content ?? '');
    
    File? selectedImage;
    bool isUploading = false;
    double uploadProgress = 0.0;
    String? currentImageUrl = note?.imageUrl;

    showDialog(
      context: context,
      barrierDismissible: false, 
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {

          Future<void> pickImage() async {
            final picker = ImagePicker();
            final image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
            
            if (image == null) return;

            final file = File(image.path);
            final fileSize = await file.length();
            
            if (fileSize > 5 * 1024 * 1024) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Файл завеликий! Максимум 5MB.'))
              );
              return;
            }

            setDialogState(() {
              selectedImage = file;
            });
          }

          Future<void> saveNote() async {
            setDialogState(() { isUploading = true; });

            try {
              String? finalImageUrl = currentImageUrl;
              String noteId = note?.id ?? DateTime.now().millisecondsSinceEpoch.toString();

              if (selectedImage != null) {
                if (currentImageUrl != null) {
                  await storageService.deleteImage(currentImageUrl!);
                }
                
                finalImageUrl = await storageService.uploadImageWithProgress(
                  selectedImage!,
                  noteId,
                  (progress) {
                    setDialogState(() { uploadProgress = progress; });
                  },
                );
              }

              if (note == null) {
                await firestoreService.createNote(
                  titleController.text, 
                  contentController.text, 
                  finalImageUrl
                );
              } else {
                await firestoreService.updateNote(
                  note.id, 
                  titleController.text, 
                  contentController.text, 
                  finalImageUrl
                );
              }
              Navigator.pop(context); 
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
              setDialogState(() { isUploading = false; });
            }
          }

          return AlertDialog(
            title: Text(note == null ? 'Нова нотатка' : 'Редагувати нотатку'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(labelText: 'Заголовок'),
                  ),
                  TextField(
                    controller: contentController,
                    decoration: InputDecoration(labelText: 'Текст нотатки'),
                    maxLines: 3,
                  ),
                  SizedBox(height: 15),
                  
                  if (selectedImage != null)
                    Image.file(selectedImage!, height: 120, fit: BoxFit.cover)
                  else if (currentImageUrl != null)
                    Image.network(currentImageUrl!, height: 120, fit: BoxFit.cover),
                  
                  SizedBox(height: 10),
                  
                  if (isUploading) ...[
                    LinearProgressIndicator(value: uploadProgress),
                    SizedBox(height: 5),
                    Text('Uploading... ${(uploadProgress * 100).toInt()}%'),
                  ] else
                    TextButton.icon(
                      onPressed: pickImage,
                      icon: Icon(Icons.image),
                      label: Text('Додати фото'),
                    ),
                ],
              ),
            ),
            actions: [
              if (!isUploading)
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Скасувати'),
                ),
              ElevatedButton(
                onPressed: isUploading ? null : saveNote,
                child: Text('Зберегти'),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Notes'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Note>>(
        stream: firestoreService.getNotes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Немає нотаток. Створи першу!'));
          }

          final notes = snapshot.data!;
          return ListView.builder(
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  leading: note.imageUrl != null 
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.network(note.imageUrl!, width: 50, height: 50, fit: BoxFit.cover),
                      )
                    : Icon(Icons.note, size: 40),
                  title: Text(note.title, style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(note.content, maxLines: 1, overflow: TextOverflow.ellipsis),
                  onTap: () => showNoteDialog(note: note), 
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      if (note.imageUrl != null) {
                        await storageService.deleteImage(note.imageUrl!);
                      }
                      await firestoreService.deleteNote(note.id);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showNoteDialog(), 
        child: Icon(Icons.add),
      ),
    );
  }
}