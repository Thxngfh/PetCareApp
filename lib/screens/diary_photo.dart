import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:pethug/models/diary_entry.dart';

class DiaryPhotoScreen extends StatelessWidget {
  final List<DiaryEntry> entries;
  const DiaryPhotoScreen({super.key, required this.entries});

  @override
  Widget build(BuildContext context) {
    final Color blueColor = const Color(0xFF9FE2FB);

    // กรองเฉพาะ entry ที่มีรูป
    final photos = entries
        .where((e) => e.imageBytes != null)
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: blueColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Diary photo', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: photos.isEmpty
          ? const Center(
              child: Text(
                'ยังไม่มีรูปภาพ',
                style: TextStyle(color: Colors.grey),
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemCount: photos.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _showFullImage(context, photos[index].imageBytes!),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.memory(
                      photos[index].imageBytes!,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
    );
  }

  void _showFullImage(BuildContext context, Uint8List bytes) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.memory(bytes, fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }
}