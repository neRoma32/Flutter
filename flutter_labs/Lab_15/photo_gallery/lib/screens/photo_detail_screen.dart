import 'dart:io';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class PhotoDetailScreen extends StatelessWidget {
  final String imagePath;
  final int index;
  final VoidCallback onDelete;

  const PhotoDetailScreen({
    super.key,
    required this.imagePath,
    required this.index,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          //B
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: () {
              Share.shareXFiles([XFile(imagePath)], text: 'Дивись, яке фото!');
            },
          ),
          //видалення
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.redAccent),
            onPressed: () {
              Navigator.pop(context);
              onDelete();
            },
          ),
        ],
      ),
      body: Center(
        child: Hero(
          tag: 'photo_$index',
          child: InteractiveViewer(
            minScale: 0.5,
            maxScale: 4.0,
            child: Image.file(File(imagePath)),
          ),
        ),
      ),
    );
  }
}