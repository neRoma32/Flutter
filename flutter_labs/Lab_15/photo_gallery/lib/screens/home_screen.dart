import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/permission_service.dart';
import 'photo_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ImagePicker _picker = ImagePicker();
  final PermissionService _permissionService = PermissionService();
  
  List<String> _imagePaths = [];
  bool _isLoading = false;
  
  //C
  Set<int> _selectedIndices = {};
  bool get _isSelectionMode => _selectedIndices.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _loadSavedImages();
  }

  Future<void> _loadSavedImages() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _imagePaths = prefs.getStringList('saved_photos') ?? [];
    });
  }

  Future<void> _updateSavedImages() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('saved_photos', _imagePaths);
  }

  //A
  Future<String?> _cropImage(String path) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: path,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 90,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Обрізати фото',
          toolbarColor: Colors.blue,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        IOSUiSettings(title: 'Обрізати фото'),
      ],
    );
    return croppedFile?.path;
  }

  Future<String> _saveImageLocally(String tempPath) async {
    final directory = await getApplicationDocumentsDirectory();
    final fileName = 'photo_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final savedPath = '${directory.path}/$fileName';
    await File(tempPath).copy(savedPath);
    return savedPath;
  }

  Future<void> _pickImages(ImageSource source) async {
    bool hasPermission = source == ImageSource.camera
        ? await _permissionService.requestCameraPermission()
        : await _permissionService.requestGalleryPermission();

    if (!hasPermission) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Немає дозволу.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (source == ImageSource.camera) {
        final XFile? image = await _picker.pickImage(source: source);
        if (image != null) {
          final croppedPath = await _cropImage(image.path);
          if (croppedPath != null) {
            final finalPath = await _saveImageLocally(croppedPath);
            setState(() => _imagePaths.add(finalPath));
          }
        }
      } else {
        final List<XFile> images = await _picker.pickMultiImage();
        if (images.isEmpty) return;

        if (images.length == 1) {
          final croppedPath = await _cropImage(images.first.path);
          if (croppedPath != null) {
            final finalPath = await _saveImageLocally(croppedPath);
            setState(() => _imagePaths.add(finalPath));
          }
        } else {
          for (var img in images) {
            final finalPath = await _saveImageLocally(img.path);
            _imagePaths.add(finalPath);
          }
          setState(() {}); 
        }
      }
      await _updateSavedImages();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Помилка: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deletePhoto(int index) async {
    final path = _imagePaths[index];
    if (await File(path).exists()) await File(path).delete();
    setState(() => _imagePaths.removeAt(index));
    await _updateSavedImages();
  }

  //C
  Future<void> _deleteSelectedPhotos() async {
    final sortedIndices = _selectedIndices.toList()..sort((a, b) => b.compareTo(a));
    for (int i in sortedIndices) {
      final path = _imagePaths[i];
      if (await File(path).exists()) await File(path).delete();
      _imagePaths.removeAt(i);
    }
    setState(() => _selectedIndices.clear());
    await _updateSavedImages();
  }

  void _showPickerMenu() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Камера'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImages(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Галерея (можна декілька)'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImages(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isSelectionMode 
            ? 'Вибрано: ${_selectedIndices.length}' 
            : 'My Photos'),
        leading: _isSelectionMode
            ? IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => setState(() => _selectedIndices.clear()),
              )
            : null,
        actions: [
          if (_isSelectionMode)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: _deleteSelectedPhotos,
            )
          else
            IconButton(
              icon: const Icon(Icons.add_a_photo),
              onPressed: _showPickerMenu,
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _imagePaths.isEmpty
              ? const Center(child: Text('Немає фото. Натисніть + щоб додати.'))
              : GridView.builder(
                  padding: const EdgeInsets.all(8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: _imagePaths.length,
                  itemBuilder: (context, index) {
                    final path = _imagePaths[index];
                    final isSelected = _selectedIndices.contains(index);

                    return GestureDetector(
                      onLongPress: () {
                        setState(() => _selectedIndices.add(index));
                      },
                      onTap: () {
                        if (_isSelectionMode) {
                          setState(() {
                            isSelected 
                                ? _selectedIndices.remove(index) 
                                : _selectedIndices.add(index);
                          });
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PhotoDetailScreen(
                                imagePath: path,
                                index: index,
                                onDelete: () => _deletePhoto(index),
                              ),
                            ),
                          );
                        }
                      },
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Hero(
                            tag: 'photo_$index',
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(File(path), fit: BoxFit.cover),
                            ),
                          ),
                          if (isSelected)
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.check_circle, 
                                  color: Colors.white, size: 40),
                            ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}